//
//  StickLabelDataSource.h
//  StickLabelDemo
//
//  Created by neon on 2017/3/16.
//  Copyright © 2017年 neon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^ConfigCellBlock)(id cell,id item);
@interface StickLabelDataSource : NSObject <UICollectionViewDataSource>

-(instancetype)initWithDataList:(NSArray *)dataList
                reuseIdentifier:(NSString *)reuseIdentifier
                configCellBlock:(ConfigCellBlock)configBlock;
@end
