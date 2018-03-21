//
//  EMPlaceHolderTextView.m
//  emark
//
//  Created by neebel on 2017/5/29.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "EMPlaceHolderTextView.h"

@interface EMPlaceHolderTextView()

@property (nonatomic, assign) CGPoint placeHolderPosition;

@end


@implementation EMPlaceHolderTextView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initUI];
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initUI];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer
{
    self = [super initWithFrame:frame textContainer:textContainer];
    if (self) {
        [self initUI];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame placeHolderPosition:(CGPoint)placeHolderPosition
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        self.placeHolderPosition = placeHolderPosition;
    }
    return self;
}


- (void)initUI
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
}


- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    [self setNeedsDisplay];
}


- (void)setText:(NSString *)text
{
    [super setText:text];
    [self setNeedsDisplay];
}


- (void)textDidChange
{
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect
{
    if (self.text.length) {
        return;
    }
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor colorWithWhite:0.5 alpha:0.5], NSFontAttributeName: self.font};
    CGFloat x = 15;
    CGFloat y = 10;
    if (self.placeHolderPosition.x) {
        x = self.placeHolderPosition.x;
    }
    if (self.placeHolderPosition.y) {
        y = self.placeHolderPosition.y;
    }
    
    CGSize size = [self.placeholder boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                                 options: NSStringDrawingTruncatesLastVisibleLine
                                              attributes:attributes
                                                 context:nil].size;
    CGFloat width = size.width;
    CGFloat height = self.frame.size.height - 2 * y;
    if (self.textAlignment == NSTextAlignmentRight) {
        x = self.frame.size.width - x - width;
    }
    CGRect frame = CGRectMake(x, y, width, height);
    [self.placeholder drawInRect:frame withAttributes:attributes];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
