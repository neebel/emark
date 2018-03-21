//
//  GKImageCropView.m
//  GKImagePicker
//
//  Created by Georg Kitz on 6/1/12.
//  Copyright (c) 2012 Aurora Apps. All rights reserved.
//

#import "GKImageCropView.h"
#import "GKImageCropOverlayView.h"
//#import "GKResizeableCropOverlayView.h"

#import <QuartzCore/QuartzCore.h>

#define rad(angle) ((angle) / 180.0 * M_PI)

static CGRect GKScaleRect(CGRect rect, CGFloat scale)
{
	return CGRectMake(rect.origin.x * scale, rect.origin.y * scale, rect.size.width * scale, rect.size.height * scale);
}

@interface ScrollView : UIScrollView
@end

@implementation ScrollView

- (void)layoutSubviews{
    [super layoutSubviews];

    UIView *zoomView = [self.delegate viewForZoomingInScrollView:self];
    
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = zoomView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    zoomView.frame = frameToCenter;
}

@end

@interface GKImageCropView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) GKImageCropOverlayView *cropOverlayView;
@property (nonatomic, assign) CGFloat xOffset;
@property (nonatomic, assign) CGFloat yOffset;

//- (CGRect)_calcVisibleRectForResizeableCropArea;
- (CGRect)_calcVisibleRectForCropArea;
- (CGAffineTransform)_orientationTransformedRectOfImage:(UIImage *)image;
@end

@implementation GKImageCropView

#pragma mark -
#pragma Getter/Setter

@synthesize scrollView, imageView, cropOverlayView, resizableCropArea, xOffset, yOffset;

- (void)setImageToCrop:(UIImage *)imageToCrop{
    self.imageView.image = imageToCrop;
}

- (UIImage *)imageToCrop{
    return self.imageView.image;
}

- (void)setCropSize:(CGSize)cropSize{
    
    if (self.cropOverlayView == nil){
//        if(self.resizableCropArea)
//            self.cropOverlayView = [[GKResizeableCropOverlayView alloc] initWithFrame:self.bounds andInitialContentSize:CGSizeMake(cropSize.width, cropSize.height)];
//        else
            self.cropOverlayView = [[GKImageCropOverlayView alloc] initWithFrame:self.bounds];
        
        [self addSubview:self.cropOverlayView];
    }
    self.cropOverlayView.cropSize = cropSize;
    
    
    
//    CGFloat minZoomScale = 1.0;
//    if (self.imageToCrop.size.width > self.imageToCrop.size.height) {
//        minZoomScale = self.imageToCrop.size.height/self.imageView.frame.size.height;
//    } else {
//        minZoomScale = self.imageToCrop.size.width/self.imageView.frame.size.width;
//    }
//    [self.scrollView setMinimumZoomScale:minZoomScale];
//    self.scrollView.maximumZoomScale = 3*minZoomScale;
//    [self.scrollView setZoomScale:1.2];
}

- (CGSize)cropSize{
    return self.cropOverlayView.cropSize;
}

#pragma mark -
#pragma Public Methods

- (UIImage *)croppedImage{
    
    //Calculate rect that needs to be cropped
    CGRect visibleRect = [self _calcVisibleRectForCropArea];
    
    //transform visible rect to image orientation
    CGAffineTransform rectTransform = [self _orientationTransformedRectOfImage:self.imageToCrop];
    visibleRect = CGRectApplyAffineTransform(visibleRect, rectTransform);
    
    //finally crop image
    CGImageRef imageRef = CGImageCreateWithImageInRect([self.imageToCrop CGImage], visibleRect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:self.imageToCrop.scale orientation:self.imageToCrop.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}

//- (CGRect)_calcVisibleRectForResizeableCropArea{
//    GKResizeableCropOverlayView* resizeableView = (GKResizeableCropOverlayView*)self.cropOverlayView;
//    
//    //first of all, get the size scale by taking a look at the real image dimensions. Here it doesn't matter if you take
//    //the width or the hight of the image, because it will always be scaled in the exact same proportion of the real image
//    CGFloat sizeScale = self.imageView.image.size.width / self.imageView.frame.size.width;
//    sizeScale *= self.scrollView.zoomScale;
//    
//    //then get the postion of the cropping rect inside the image
//    CGRect visibleRect = [resizeableView.contentView convertRect:resizeableView.contentView.bounds toView:imageView];
//    return visibleRect = GKScaleRect(visibleRect, sizeScale);
//}

-(CGRect)_calcVisibleRectForCropArea{
    //scaled width/height in regards of real width to crop width
    CGFloat scaleWidth = self.imageToCrop.size.width / self.cropSize.width;
    CGFloat scaleHeight = self.imageToCrop.size.height / self.cropSize.height;
    CGFloat scale = MIN(scaleWidth, scaleHeight);
    
//    if (self.cropSize.width > self.cropSize.height) {
//        scale = (self.imageToCrop.size.width < self.imageToCrop.size.height ?
//                 MIN(scaleWidth, scaleHeight) :
//                 MAX(scaleWidth, scaleHeight));
//        scale = MIN(scaleWidth, scaleHeight);
//    }else{
//        scale = (self.imageToCrop.size.width < self.imageToCrop.size.height ?
//                 MAX(scaleWidth, scaleHeight) :
//                 MIN(scaleWidth, scaleHeight));
//        scale = MIN(scaleWidth, scaleHeight);
//    }
    
    //extract visible rect from scrollview and scale it
    CGRect visibleRect = [scrollView convertRect:scrollView.bounds toView:imageView];
    return visibleRect = GKScaleRect(visibleRect, scale);
}


- (CGAffineTransform)_orientationTransformedRectOfImage:(UIImage *)img
{
	CGAffineTransform rectTransform;
	switch (img.imageOrientation)
	{
		case UIImageOrientationLeft:
			rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(90)), 0, -img.size.height);
			break;
		case UIImageOrientationRight:
			rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-90)), -img.size.width, 0);
			break;
		case UIImageOrientationDown:
			rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-180)), -img.size.width, -img.size.height);
			break;
		default:
			rectTransform = CGAffineTransformIdentity;
	};
	
	return CGAffineTransformScale(rectTransform, img.scale, img.scale);
}

#pragma mark -

- (void)resetZoomScale:(UITapGestureRecognizer *)sender {
    if (self.scrollView.zoomScale == self.scrollView.minimumZoomScale) {
        [self.scrollView setZoomScale:self.scrollView.maximumZoomScale/2 animated:YES];
    } else {
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    }
}

#pragma Override Methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor blackColor];
        self.scrollView = [[ScrollView alloc] initWithFrame:self.bounds ];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.delegate = self;
        self.scrollView.clipsToBounds = NO;
        self.scrollView.decelerationRate = 0.0; 
        self.scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.scrollView];
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.scrollView.frame];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.backgroundColor = [UIColor blackColor];
        [self.scrollView addSubview:self.imageView];
    
        CGFloat minZoomScale = CGRectGetHeight(self.scrollView.frame) / CGRectGetHeight(self.imageView.frame);
        self.scrollView.minimumZoomScale = minZoomScale;
        self.scrollView.maximumZoomScale = 5*minZoomScale;
        //[self.scrollView setZoomScale:1.0];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetZoomScale:)];
        doubleTap.numberOfTapsRequired = 2;
        [self.scrollView addGestureRecognizer:doubleTap];
    }
    return self;
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    if (!self.resizableCropArea)
        return self.scrollView;

//    GKResizeableCropOverlayView* resizeableCropView = (GKResizeableCropOverlayView*)self.cropOverlayView;
//    
//    CGRect outerFrame = CGRectInset(resizeableCropView.cropBorderView.frame, -10 , -10);
//    if (CGRectContainsPoint(outerFrame, point)){
//        
//        if (resizeableCropView.cropBorderView.frame.size.width < 60 || resizeableCropView.cropBorderView.frame.size.height < 60 )
//            return [super hitTest:point withEvent:event];
//        
//        CGRect innerTouchFrame = CGRectInset(resizeableCropView.cropBorderView.frame, 30, 30);
//        if (CGRectContainsPoint(innerTouchFrame, point))
//            return self.scrollView;
//        
//        CGRect outBorderTouchFrame = CGRectInset(resizeableCropView.cropBorderView.frame, -10, -10);
//        if (CGRectContainsPoint(outBorderTouchFrame, point))
//            return [super hitTest:point withEvent:event];
//        
//        return [super hitTest:point withEvent:event];
//    }
//    return self.scrollView;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize size = self.cropSize;
    CGFloat toolbarSize = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 0 : 54;
    self.xOffset = floor((CGRectGetWidth(self.bounds) - size.width) * 0.5);
    self.yOffset = floor((CGRectGetHeight(self.bounds) - toolbarSize - size.height) * 0.5); //fixed

    CGFloat height = self.imageToCrop.size.height;
    CGFloat width = self.imageToCrop.size.width;
    
    CGFloat faktor = 0.f;
    CGFloat faktoredHeight = 0.f;
    CGFloat faktoredWidth = 0.f;
    
    if(width < height){
        
        faktor = width / size.width;
        faktoredWidth = size.width;
        faktoredHeight =  height / faktor;
        
    } else {
        
        faktor = height / size.height;
        faktoredWidth = width / faktor;
        faktoredHeight =  size.height;
    }
    
    self.cropOverlayView.frame = self.bounds;
    self.scrollView.frame = CGRectMake(xOffset, yOffset, size.width, size.height);
    self.scrollView.contentSize = CGSizeMake(faktoredWidth, faktoredHeight);
    //self.imageView.frame = CGRectMake(floor((size.width - faktoredWidth) * 0.5), floor((size.height - faktoredHeight) * 0.5), faktoredWidth, faktoredHeight);
    self.imageView.frame = CGRectMake(0, 0, faktoredWidth, faktoredHeight);
    
    self.scrollView.minimumZoomScale = MIN(faktoredWidth / size.width, faktoredHeight / size.height);
}

#pragma mark -
#pragma UIScrollViewDelegate Methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

@end
