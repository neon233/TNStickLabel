//
//  StickLabelLayout.h
//  StickLabelDemo
//
//  Created by neon on 2017/3/16.
//  Copyright © 2017年 neon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StickLabelLayout;
NS_ASSUME_NONNULL_BEGIN
@protocol StickLabelLayoutDelegate <NSObject>
- (CGSize)stickLabelCollectionView:(UICollectionView *)collectionView collectionLayout:(StickLabelLayout *)customLayout itemSizeAtIndexpath:(NSIndexPath *)itemIndexpath;

@end
NS_ASSUME_NONNULL_END
@interface StickLabelLayout : UICollectionViewLayout
@property (nonatomic,weak,nullable) id <StickLabelLayoutDelegate> delegate;
@end
