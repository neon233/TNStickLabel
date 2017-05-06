//
//  StickLabelLayout.m
//  StickLabelDemo
//
//  Created by neon on 2017/3/16.
//  Copyright © 2017年 neon. All rights reserved.
//

#import "StickLabelLayout.h"
#import <math.h>

#define INTERVALVALUE 10.0f
@interface StickLabelLayout ()
@property (nonatomic) CGFloat contentHeight;
@property (nonatomic,strong) NSMutableArray *frameList;
@end

@implementation StickLabelLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.contentHeight = self.collectionView.bounds.size.height;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.frameList = [[NSMutableArray alloc]init];
    }
    return self;
}
- (void)prepareLayout {
    [super prepareLayout];
    [self.frameList removeAllObjects];
}

-(CGSize)collectionViewContentSize {
    
    return CGSizeMake(self.collectionView.frame.size.width, self.contentHeight);
//    return [self collectionView].frame.size;
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray* attributes = [NSMutableArray array];
    
    NSInteger sectionCount = [self.collectionView numberOfSections];
    for (int i=0; i<sectionCount; i++) {
        NSInteger rowCount = [self.collectionView numberOfItemsInSection:i];
        for (int j=0; j<rowCount; j++) {
            NSIndexPath* indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            //这里利用了-layoutAttributesForItemAtIndexPath:来获取attributes
            [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        }
    }
    return attributes;
}
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize itemSize = [self.delegate stickLabelCollectionView:self.collectionView collectionLayout:self itemSizeAtIndexpath:indexPath];
    UICollectionViewLayoutAttributes *currentAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
currentAttributes.frame =  [self detectPositionWithCurrentSize:itemSize andLastItem:indexPath.row-1];
    [self.frameList addObject:[NSValue valueWithCGRect:currentAttributes.frame]];
    return currentAttributes;
}

- (CGRect)detectPositionWithCurrentSize:(CGSize)currentSize andLastItem:(NSInteger)lastIndex {
    CGPoint currentPoint;
    
    if (lastIndex<0) {
        self.contentHeight = 0;
        currentPoint = CGPointMake(INTERVALVALUE,INTERVALVALUE);
        self.contentHeight += currentSize.height+INTERVALVALUE;
        return CGRectMake(currentPoint.x, currentPoint.y, currentSize.width, currentSize.height);
    }
    
    CGRect lastFrame = [self.frameList[lastIndex] CGRectValue];
    if ((lastFrame.origin.x+lastFrame.size.width+currentSize.width ) > (self.collectionView.frame.size.width-28)) {
        currentPoint = CGPointMake(INTERVALVALUE, lastFrame.origin.y+lastFrame.size.height+INTERVALVALUE);
    }else {
        currentPoint = CGPointMake(lastFrame.origin.x+lastFrame.size.width+INTERVALVALUE, lastFrame.origin.y);
    }
    self.contentHeight = currentSize.height+currentPoint.y+INTERVALVALUE+60;
    return CGRectMake(currentPoint.x, currentPoint.y, currentSize.width, currentSize.height);
    
}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    CGRect oldBounds = self.collectionView.bounds;
    if (!CGSizeEqualToSize(oldBounds.size, newBounds.size)) {
        return YES;
    }
    return NO;
}


- (void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems {

}

@end
