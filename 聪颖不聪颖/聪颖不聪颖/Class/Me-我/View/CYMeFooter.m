//
//  CYMeFooter.m
//  聪颖不聪颖
//
//  Created by 葛聪颖 on 15/10/10.
//  Copyright © 2015年 gecongying. All rights reserved.
//

#import "CYMeFooter.h"
#import <AFNetworking.h>
#import "CYSquare.h"
#import <MJExtension.h>
#import "CYSquareButton.h"
#import "CYWebViewController.h"

@implementation CYMeFooter

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        // 请求参数
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"a"] = @"square";
        params[@"c"] = @"topic";
        
        // 发送请求
        CYWeakSelf;
        [[AFHTTPSessionManager manager] GET:CYRequestURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
//            CYWriteToPlist(responseObject, @"square");
            [weakSelf createSquares:[CYSquare objectArrayWithKeyValuesArray:responseObject[@"square_list"]]];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
    return self;
}

/**
 * 创建方块
 */
- (void)createSquares:(NSArray *)squares
{
    // 每行的列数
    int colsCount = 4;
    
    // 按钮尺寸
    CGFloat buttonW = self.width / colsCount;
    CGFloat buttonH = buttonW;
    
    // 遍历所有的模型
    NSUInteger count = squares.count;
    for (NSUInteger i = 0; i < count; i++) {
        
        // 创建按钮
        CYSquareButton *button = [CYSquareButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        // frame
        CGFloat buttonX = (i % colsCount) * buttonW;
        CGFloat buttonY = (i / colsCount) * buttonH;
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        // 设置模型数据
        button.square = squares[i];
        
//        // 数据
//        [button setTitle:square.name forState:UIControlStateNormal];
//        // 设置按钮的image
//        [button sd_setImageWithURL:[NSURL URLWithString:square.icon] forState:UIControlStateNormal];
        
        // 设置footer的高度
        self.height = CGRectGetMaxY(button.frame);
    }
    
    // 设置footer的高度
    NSUInteger rowsCount = (count + colsCount - 1) / colsCount;
    self.height = rowsCount * buttonH;
    
    // 重新设置footerView
    UITableView *tableView = (UITableView *)self.superview;
    //    tableView.tableFooterView = self;
    tableView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.frame));
}

- (void)buttonClick:(CYSquareButton *)button
{
    if ([button.square.url hasPrefix:@"http"] == NO) return;
    
    CYWebViewController *webVc = [[CYWebViewController alloc] init];
    webVc.square = button.square;
    
    // 取出当前选中的导航控制器
    UITabBarController *rootVc = (UITabBarController *)self.window.rootViewController;
    UINavigationController *nav = (UINavigationController *)rootVc.selectedViewController;
    [nav pushViewController:webVc animated:YES];
    
}

/**
 1个控件不能响应点击事件，原因可能有：
 1> userInteractionEnabled = NO;
 2> enabled = NO;
 3> 父控件的userInteractionEnabled = NO;
 4> 父控件的enabled = NO;
 5> 控件已经超出父控件的边框范围
 */

@end
