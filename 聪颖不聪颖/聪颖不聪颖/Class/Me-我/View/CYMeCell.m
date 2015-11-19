//
//  CYMeCell.m
//  聪颖不聪颖
//
//  Created by 葛聪颖 on 15/10/10.
//  Copyright © 2015年 gecongying. All rights reserved.
//

#import "CYMeCell.h"

@implementation CYMeCell

//- (void)setFrame:(CGRect)frame
//{
//    frame.origin.y = 10;
//    
//    [super setFrame:frame];
//}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.textLabel.textColor = [UIColor darkGrayColor];
        
        // 设置背景图片
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.imageView.image == nil) return;
    
    // 调整imageView
    self.imageView.y = CYCommonMargin * 0.5;
    self.imageView.height = self.contentView.height - 2 * self.imageView.y;
    self.imageView.width = self.imageView.height;
    
    // 调整Label
    //    self.textLabel.x = self.imageView.x + self.imageView.width + CYCommonMargin;
    self.textLabel.x = CGRectGetMaxX(self.imageView.frame) + CYCommonMargin;
    
    // CGRectGetMaxX(self.imageView.frame) == self.imageView.x + self.imageView.width
    // CGRectGetMinX(self.imageView.frame) == self.imageView.x
    // CGRectGetMidX(self.imageView.frame) == self.imageView.x + self.imageView.width * 0.5
    // CGRectGetMidX(self.imageView.frame) == self.imageView.centerX
}

@end
