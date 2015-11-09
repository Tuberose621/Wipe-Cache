//
//  CYEssenceViewController.m
//  聪颖不聪颖
//
//  Created by 葛聪颖 on 15/9/6.
//  Copyright (c) 2015年 gecongying. All rights reserved.
//

#import "CYEssenceViewController.h"
#import "CYTagViewController.h"

@interface CYEssenceViewController ()

@end

@implementation CYEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = CYCommonBgColor;
    // 这样传图片，它传的图片尺寸和原始尺寸一样
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    // 导航栏左边的内容
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(tagClick)];
}

- (void)tagClick
{
    NSLog(@"%s",__func__);
    CYTagViewController *tag = [[CYTagViewController alloc] init];
    [self.navigationController pushViewController:tag animated:YES];
    
}


@end