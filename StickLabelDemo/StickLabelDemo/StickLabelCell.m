//
//  StickLabelCell.m
//  StickLabelDemo
//
//  Created by neon on 2017/3/16.
//  Copyright © 2017年 neon. All rights reserved.
//

#import "StickLabelCell.h"

@implementation StickLabelCell
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.dataLabel.numberOfLines = 0;
        [self.dataLabel sizeToFit];
        [self.dataLabel setAdjustsFontSizeToFitWidth:YES];
        
        self.layer.cornerRadius = 6;
//        self.dataLabel.preferredMaxLayoutWidth = self.view.frame.size.width;
    }
    return self;
}
@end
