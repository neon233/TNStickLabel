//
//  StickLabelDataSource.m
//  StickLabelDemo
//
//  Created by neon on 2017/3/16.
//  Copyright © 2017年 neon. All rights reserved.
//

#import "StickLabelDataSource.h"
#import "StickLabelCell.h"
@interface StickLabelDataSource ()
@property (nonatomic,strong) NSMutableArray *dataList;
@property (nonatomic,strong) NSString *reuseIdentifier;
@property (nonatomic,copy) ConfigCellBlock configBlock;
@end
@implementation StickLabelDataSource

- (instancetype)initWithDataList:(NSMutableArray *)tdataList reuseIdentifier:(NSString *)treuseIdentifier configCellBlock:(ConfigCellBlock)tconfigBlock {
    self = [super init];
    if (self) {
        self.dataList = tdataList;
        self.reuseIdentifier = treuseIdentifier;
        self.configBlock = [tconfigBlock copy];
    }
    return self;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    

    return self.dataList.count;
}
// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    StickLabelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.reuseIdentifier forIndexPath:indexPath];
    self.configBlock(cell,self.dataList[indexPath.row]);
    return cell;
}


@end
