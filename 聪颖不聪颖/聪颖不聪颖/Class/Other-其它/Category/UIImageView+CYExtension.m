//
//  UIImageView+CYExtension.m
//  聪颖不聪颖
//
//  Created by 葛聪颖 on 15/10/10.
//  Copyright © 2015年 gecongying. All rights reserved.
//

#import "UIImageView+CYExtension.h"
#import <UIImageView+WebCache.h>

@implementation UIImageView (CYExtension)
- (void)setHeader:(NSString *)url
{
    [self setCircleHeader:url];
}

- (void)setRectHeader:(NSString *)url
{
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
}

- (void)setCircleHeader:(NSString *)url
{
    CYWeakSelf;
    // PCH文件中有定义
    UIImage *placeholder = [[UIImage imageNamed:@"defaultUserIcon"] circleImage];
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder completed:
     ^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
         // 如果图片下载失败，就不做任何处理，按照默认的做法：会显示占位图片
         if (image == nil) return;
         
         weakSelf.image = [image circleImage];
     }];
}
@end
