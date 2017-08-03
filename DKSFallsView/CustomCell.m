//
//  CustomCell.m
//  DKSFallsView
//
//  Created by aDu on 2017/8/2.
//  Copyright © 2017年 DuKaiShun. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorWithRed:arc4random() % 256 / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 255.0 alpha:1.0];
}

@end
