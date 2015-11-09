//
//  CYSquareButton.m
//  聪颖不聪颖
//
//  Created by 葛聪颖 on 15/10/10.
//  Copyright © 2015年 gecongying. All rights reserved.
//

#import "CYSquareButton.h"
#import "CYSquare.h"
#import <UIButton+WebCache.h>

@implementation CYSquareButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"mainCellBackground"] forState:UIControlStateNormal];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.width = self.width * 0.5;
    self.imageView.height = self.imageView.width;
    self.imageView.y = self.height * 0.1;
    self.imageView.centerX = self.width * 0.5;
    
    self.titleLabel.width = self.width;
    self.titleLabel.y = CGRectGetMaxY(self.imageView.frame);
    self.titleLabel.x = 0;
    self.titleLabel.height = self.height - self.titleLabel.y;
}
- (void)setSquare:(CYSquare *)square
{
    _square = square;
    
    // 数据
    [self setTitle:square.name forState:UIControlStateNormal];
    // 设置按钮的image
    [self sd_setImageWithURL:[NSURL URLWithString:square.icon] forState:UIControlStateNormal];
}

@end
