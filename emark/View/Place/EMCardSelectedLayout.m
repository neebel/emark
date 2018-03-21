//
//  EMCardSelectedLayout.m
//
//  Created by neebel on 16/10/11.
//  Copyright © 2016年 neebel. All rights reserved.
//

#import "EMCardSelectedLayout.h"

static CGFloat cellWidth;   //卡片宽度
static CGFloat cellHeight;  //卡片高度

@interface EMCardSelectedLayout()

@property (nonatomic, assign) CGFloat        cellToTop;     //距顶部距离
@property (nonatomic, assign) CGFloat        cellToBottom;  //距底部距离
@property (nonatomic, strong) NSMutableArray *cellLayoutList;

@end

@implementation EMCardSelectedLayout

- (instancetype)initWithIndexPath:(NSIndexPath *)indexPath offsetY:(CGFloat)offsetY ContentSizeHeight:(CGFloat)sizeHeight
{
    self = [self init];
    if (self) {
        self.selectedIndexPath = indexPath;
        self.contentOffsetY = offsetY;
        self.contentSizeHeight = sizeHeight;
    }
    return self;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        cellWidth = [UIScreen mainScreen].bounds.size.width - 12 * 2;
        cellHeight = 210;
        self.cellToTop = -cellHeight;
        self.cellToBottom = [UIScreen mainScreen].bounds.size.height + cellHeight;
        self.cellLayoutList = [NSMutableArray array];
    }
    
    return self;
}


- (void)prepareLayout
{
    [super prepareLayout];
    
    [self.cellLayoutList removeAllObjects];
    [self.collectionView setContentOffset:CGPointMake(0, self.contentOffsetY)];
    
    CGFloat scale = 1;
    CGFloat width = cellWidth;
    CGFloat height = cellHeight;
    NSInteger rowsCount = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger row = 0; row < rowsCount; row++) {
        NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:cellIndexPath];
        
        CGFloat centerX = self.collectionView.bounds.size.width / 2.0;
        CGFloat currentY = 0;
        if (row < self.selectedIndexPath.row) {
            currentY = self.contentOffsetY + self.cellToTop;
            scale = 0.8;
            height = cellHeight;
        } else if (row == self.selectedIndexPath.row) {
            height = cellHeight;
            currentY = self.contentOffsetY + (self.collectionView.bounds.size.height) / 2.0 - height /2.0;
            scale = 1;
            
        } else {
            height = cellHeight;
            currentY = self.contentOffsetY + self.cellToBottom;
            scale = 1.2;
        }
        
        attribute.frame = CGRectMake(centerX - cellWidth / 2.0, currentY, width, height);
        CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
        attribute.transform = transform;
        attribute.zIndex = row;
        
        [self.cellLayoutList addObject:attribute];
    }
}


- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.collectionView.frame.size.width, self.contentSizeHeight);
}


- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
{
    return CGPointMake(0, self.contentOffsetY);
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


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.cellLayoutList objectAtIndex:indexPath.row];
}

@end
