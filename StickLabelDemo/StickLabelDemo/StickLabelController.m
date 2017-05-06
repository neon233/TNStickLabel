//
//  StickLabelController.m
//  StickLabelDemo
//
//  Created by neon on 2017/3/16.
//  Copyright © 2017年 neon. All rights reserved.
//

#import "StickLabelController.h"
#import "StickLabelCell.h"
#import "StickLabelLayout.h"
#import "StickLabelDataSource.h"
@interface StickLabelController () <StickLabelLayoutDelegate,UITextFieldDelegate>

@property (strong, nonatomic) StickLabelDataSource *stickLabelDataSource;
@property (nonatomic,strong) UIImageView *movingCell;
@property (nonatomic,strong) NSIndexPath *oldIndexPath;
@property (nonatomic,strong) NSIndexPath *targetIndexPath;
@property (nonatomic,strong) NSMutableArray *dataList;
@property (nonatomic,strong) UIButton *tagAddBtn;
@property (nonatomic,strong) UITextField *tagInputTextField;
@property (nonatomic,strong) UIView *bottomView;
@end

@implementation StickLabelController

static NSString * const reuseIdentifier = @"stickcell";
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.dataList = [NSMutableArray arrayWithArray:@[@"很简单",
                                                         @"有趣",
                                                         @"就原谅我第一次失败吧",
                                                         @"梦并没有破碎",
                                                         @"哦突然出现奇迹",
                                                         @"失落的深夜啊",
                                                         @"就在这一刻你想起了谁"
                                        
                                                         /*,
                                                         
                                                         @"3-有的养殖户",
                                                         @"4-正因如此，我国2005年版《兽药典》以及《饲料药物添加剂使用规范》都明确规定，喹乙醇适用范围：35公斤以下的猪，禁用于禽、禁用于体重超过35kg的猪、休药期35",
                                                         @"5233",
                                                         @"6233",
                                                         @"7233",
                                                         @"8-记者调查发现，在獭兔养殖中,被滥用的兽药不止是喹乙醇。",
                                                         @"9-这是硫酸黏菌素，它助生长的。"*/]];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView addGestureRecognizer: [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longGestureAction:)]];
    
    
    self.stickLabelDataSource = [[StickLabelDataSource alloc]initWithDataList:self.dataList reuseIdentifier:reuseIdentifier configCellBlock:^(id cell, id item) {
        [self configCollectionViewCell:cell data:item];
    }];
    self.collectionView.dataSource = self.stickLabelDataSource;
    ((StickLabelLayout *)(self.collectionViewLayout)).delegate  = self;
    
    [self.view addSubview:self.bottomView];
}



- (void)configCollectionViewCell:(StickLabelCell *)cell data:(NSString *)item {
    cell.dataLabel.text = item;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark <UICollectionViewDelegate>
- (void)longGestureAction:(UILongPressGestureRecognizer *)panRecognizer {
    
    CGPoint locationPoint = [panRecognizer locationInView:self.collectionView];
    
    if (panRecognizer.state == UIGestureRecognizerStateBegan) {
    
        NSIndexPath *indexPathOfMovingCell = [self.collectionView indexPathForItemAtPoint:locationPoint];
        self.oldIndexPath = indexPathOfMovingCell;
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPathOfMovingCell];
        
        UIGraphicsBeginImageContext(cell.bounds.size);
        [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *cellImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.movingCell = [[UIImageView alloc] initWithImage:cellImage];
        [self.movingCell setCenter:locationPoint];
        [self.movingCell setAlpha:0.75f];
        [self.collectionView addSubview:self.movingCell];
    }
    
    if (panRecognizer.state == UIGestureRecognizerStateChanged) {

        [self.movingCell setCenter:locationPoint];
    }
    if (panRecognizer.state == UIGestureRecognizerStateEnded) {

        [self.movingCell removeFromSuperview];
        self.targetIndexPath = [self.collectionView indexPathForItemAtPoint:locationPoint];

        

        
        [self.dataList exchangeObjectAtIndex:self.oldIndexPath.row withObjectAtIndex:self.targetIndexPath.row];
        [self.collectionView reloadData];
    
        
//        [self.collectionView moveItemAtIndexPath:self.oldIndexPath toIndexPath:self.targetIndexPath];
        
    }
    
}

- (CGSize)stickLabelCollectionView:(UICollectionView *)collectionView collectionLayout:(StickLabelLayout *)customLayout itemSizeAtIndexpath:(NSIndexPath *)itemIndexpath {
    NSString *contentstr = self.dataList[itemIndexpath.row];
    return [contentstr boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-28, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} context:nil].size;
}

#pragma mark event
- (void)addLabelAction {
    
    [self.tagInputTextField resignFirstResponder];
    [self.dataList addObject:self.tagInputTextField.text];
    self.tagInputTextField.text = @"";
    [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dataList.count-1 inSection:0]]];
}
#pragma mark setter & getter

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-60, [UIScreen mainScreen].bounds.size.width, 60)];
        _bottomView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_bottomView addSubview:self.tagInputTextField];
        [_bottomView addSubview:self.tagAddBtn];
    }
    return _bottomView;
}

- (UITextField *)tagInputTextField {
    if (!_tagInputTextField) {
        _tagInputTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-80, 40)];
        _tagInputTextField.borderStyle = UITextBorderStyleRoundedRect;
        _tagInputTextField.placeholder = @"请输入标签";
        _tagInputTextField.font = [UIFont systemFontOfSize:13];
        _tagInputTextField.delegate = self;
    }
    return _tagInputTextField;
}
- (UIButton *)tagAddBtn {
    if (!_tagAddBtn) {
        _tagAddBtn = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60, 10, 40, 40)];
        [_tagAddBtn setTitle:@"好哒" forState:UIControlStateNormal];
        _tagAddBtn.backgroundColor = [UIColor orangeColor];
        _tagAddBtn.layer.cornerRadius = 6;
        _tagAddBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_tagAddBtn addTarget:self action:@selector(addLabelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tagAddBtn;
}



@end
