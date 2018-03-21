//
//  EMCardLayout.m
//
//  Created by neebel on 16/10/10.
//  Copyright © 2016年 neebel. All rights reserved.
//

#import "EMCardLayout.h"

#define GBL_UIKIT_D0 16
#define GBL_UIKIT_D1 12

static CGFloat cellWidth;   //卡片宽度
static CGFloat cellHeight;  //卡片高度

@interface EMCardLayout()

//公式2
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, assign) CGFloat m0;          //是指当第0个cell从初始位置，往上滑m0个点时卡片会移动到最顶点
@property (nonatomic, assign) CGFloat n0;          //当contentOffset.y为0时，第0个cell的y坐标为n0
@property (nonatomic, assign) CGFloat deltaOffsetY;//每个cell之间的偏移量间距，即第0个cell往下滑动deltaOffsetY个点时会到达第1个cell的位置
@property(nonatomic, strong)  NSMutableArray *cellLayoutList;

@end

@implementation EMCardLayout

- (instancetype)init
{
    self = [self initWithOffsetY:0];
    return self;
}


- (instancetype)initWithOffsetY:(CGFloat)offsetY
{
    self = [super init];
    if (self) {
        cellWidth = [UIScreen mainScreen].bounds.size.width - 12 * 2;
        cellHeight = 210;
        self.offsetY = offsetY;
        self.cellLayoutList = [NSMutableArray array];
        
        self.screenHeight = [UIScreen mainScreen].bounds.size.height;
        self.m0 = 1000;
        self.n0 = 250;
        self.deltaOffsetY = 140;
    }
    
    return self;
}


- (void)prepareLayout
{
    [super prepareLayout];
    [self.cellLayoutList removeAllObjects];
    
    NSInteger rowCount = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger row = 0; row < rowCount; row++) {
        UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        [self.cellLayoutList addObject:attribute];
    }
}


- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.collectionView.frame.size.width, [self getContentSizeY]);
}


//目标offset，在应用layout的时候会调用这个回调来设置collectionView的contentOffset
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
{
    return CGPointMake(0, self.offsetY);
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *array = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attribute in self.cellLayoutList) {
        if (CGRectIntersectsRect(attribute.frame, rect)) {
            [array addObject:attribute];
        }
    }
    return array;
}


//每次手指滑动时，都会调用这个方法来返回每个cell的布局
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowCount = [self.collectionView numberOfItemsInSection:0];
    //如果超过两张卡片，则用多卡片布局
    if (rowCount >2) {
        return [self getAttributesWhen3orMoreRows:indexPath];
    } else {
        return [self getAttributesWhenLessThan2:indexPath];
    }
}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return !CGRectEqualToRect(newBounds, self.collectionView.bounds);
}

#pragma mark - Private

//少于等于两张时的布局
- (UICollectionViewLayoutAttributes *)getAttributesWhenLessThan2:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat originY = GBL_UIKIT_D1 + indexPath.row *(cellHeight + GBL_UIKIT_D0);
    attributes.frame = CGRectMake(GBL_UIKIT_D0, originY, cellWidth, cellHeight);
    return attributes;
}


//超过三张时的布局
- (UICollectionViewLayoutAttributes *)getAttributesWhen3orMoreRows:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.size = CGSizeMake(cellWidth, cellHeight);
    
    //计算位置
    CGFloat originY = [self getOriginYWithOffsetY:self.collectionView.contentOffset.y row:indexPath.row];
    CGFloat centerY = originY + self.collectionView.contentOffset.y + cellHeight / 2.0;
    attributes.center = CGPointMake(CGRectGetWidth(self.collectionView.frame) / 2, centerY);
    
    //计算缩放比例
    CGFloat rat = [self transformRatio:originY];
    attributes.transform = CGAffineTransformMakeScale(rat, rat);
    
    //计算透明度
    //y = (1-1.14x)^0.3
    CGFloat blur = 0;
    if ((1 - 1.14 * rat) < 0 ) {
        blur = 0;
    } else {
        blur = powf((1 - 1.14 * rat), 0.4);
    }
    
    [self.blurList setObject:@(blur) atIndexedSubscript:indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateBlur:ForRow:)]) {
        [self.delegate updateBlur:blur ForRow:indexPath.row];
    }
    
    attributes.zIndex = originY;//这里设置zIndex，是为了cell的层次顺序达到下面的cell覆盖上面的cell的效果
    return attributes;
}


- (NSMutableArray *)blurList
{
    if (!_blurList) {
        _blurList = [NSMutableArray array];
        NSInteger rowCount = [self.collectionView numberOfItemsInSection:0];
        for (NSInteger row = 0; row < rowCount; row++) {
            [_blurList addObject:@0];
        }
    }
    
    return _blurList;
}


- (CGFloat)getContentSizeY
{
    self.contentSizeHeight = [self getSizeY];
    return self.contentSizeHeight;
}


//根据下标、当前偏移量来获取对应的y坐标
-(CGFloat)getOriginYWithOffsetY:(CGFloat)offsetY row:(NSInteger)row
{
    // 公式： y0 = ((m0 - x)/m0)^4*n0
    // 公式:  yi=((m0 + i*140-x)/(m0 + i*140))^4*((m0+140*i)/m0)^4*n0
    CGFloat x = offsetY;    //这里offsetY就是自变量x
    CGFloat ni = [self defaultYWithRow:row];
    CGFloat mi = self.m0 + row * self.deltaOffsetY;
    CGFloat tmp = mi - x;
    CGFloat y = 0;
    if (tmp >= 0) {
        y = powf((tmp) / mi, 4) * ni;
    } else {
        y = 0 - (cellHeight - tmp);
    }
    
    return y;
}


//获取当contentOffset.y=0时每个cell的y值
- (CGFloat)defaultYWithRow:(NSInteger)row
{
    CGFloat x0 = 0; //初始状态
    CGFloat xi = x0 - self.deltaOffsetY * row;
    CGFloat ni = powf((self.m0 - xi) / self.m0, 4) * self.n0;
    return ni;
}


//根据偏移量、下标获取对应的尺寸变化
- (CGFloat)transformRatio:(CGFloat)originY
{
    // y = (x/range)^0.4
    if (originY < 0) {
        return 1;
    }
    CGFloat range = [UIScreen mainScreen].bounds.size.height;
    originY = fminf(originY, range);
    CGFloat ratio = powf(originY / range, 0.04);
    return ratio;
}


- (CGFloat)getSizeY
{
    NSInteger rowCount = [self.collectionView numberOfItemsInSection:0];
    if (rowCount <= 2) {
        return self.collectionView.frame.size.height;
    }
    CGFloat scrollY = self.deltaOffsetY * (rowCount - 1);
    return scrollY + self.screenHeight;
}

@end
