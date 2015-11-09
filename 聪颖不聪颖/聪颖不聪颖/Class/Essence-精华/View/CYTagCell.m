//
//  CYTagCell.m
//  聪颖不聪颖
//
//  Created by 葛聪颖 on 15/10/6.
//  Copyright © 2015年 gecongying. All rights reserved.
//

#import "CYTagCell.h"
#import "CYTag.h"
#import <UIImageView+WebCache.h>

@interface CYTagCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageListView;
@property (weak, nonatomic) IBOutlet UILabel *themeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subNumberLabel;
@end

@implementation CYTagCell


- (void)awakeFromNib
{
    //     如果使用过于频繁，可能会导致拖拽起来的感觉比较卡
//    self.imageListView.layer.cornerRadius = self.imageListView.width * 0.5;
//    self.imageListView.layer.masksToBounds = YES;
}

/**
 * 重写这个方法的目的：拦截cell的frame设置
 */
- (void)setFrame:(CGRect)frame
{
    frame.size.height -= 1;
    frame.origin.x = 5;
    frame.size.width -= 2 * frame.origin.x;
    
    [super setFrame:frame];
    
}
- (void)setTagModel:(CYTag *)tagModel
{
    _tagModel = tagModel;
    
    // 设置头像
    [self.imageListView setHeader:tagModel.image_list];
    
    self.themeNameLabel.text = tagModel.theme_name;
    
    // 订阅数
    if (tagModel.sub_number >= 10000) {
        self.subNumberLabel.text = [NSString stringWithFormat:@"%.1f万人订阅", tagModel.sub_number / 10000.0];
    } else {
        self.subNumberLabel.text = [NSString stringWithFormat:@"%zd人订阅", tagModel.sub_number];
    }
}



@end
