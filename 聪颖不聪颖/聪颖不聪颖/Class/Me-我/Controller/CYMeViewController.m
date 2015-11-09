//
//  CYMeViewController.m
//  聪颖不聪颖
//
//  Created by 葛聪颖 on 15/9/6.
//  Copyright (c) 2015年 gecongying. All rights reserved.
//
#import "CYMeViewController.h"
#import "CYSettingViewController.h"
#import "CYMeCell.h"
#import "CYMeFooter.h"

@interface CYMeViewController ()

@end

@implementation CYMeViewController

static NSString * const CYMeCellId = @"me";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupTable];

}

- (void)setupNav
{
    self.navigationItem.title = @"我的";
    
    // 我的导航栏右边的内容
    UIBarButtonItem *moonButton = [UIBarButtonItem itemWithImage:@"mine-moon-icon" highImage:@"mine-moon-icon-click" target:self action:@selector(moonClick)];
    UIBarButtonItem *settingButton = [UIBarButtonItem itemWithImage:@"mine-setting-icon" highImage:@"mine-setting-icon-click" target:self action:@selector(settingClick)];
    
    self.navigationItem.rightBarButtonItems = @[settingButton,moonButton];
}
- (void)setupTable
{
    self.tableView.backgroundColor = CYCommonBgColor;
    [self.tableView registerClass:[CYMeCell class] forCellReuseIdentifier:CYMeCellId];
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = CYCommonMargin;
    // 设置内边距(-25代表：所有内容往上移动25)
    self.tableView.contentInset = UIEdgeInsetsMake(CYCommonMargin - 35, 0, 0, 0);
    // 设置footer
    self.tableView.tableFooterView = [[CYMeFooter alloc] init];
}

- (void)moonClick
{
    CYLogFunc
}


- (void)settingClick
{
    //    self.navigationController.navigationBar.barTintColor = [UIColor darkGrayColor]; //设置导航栏的颜色
    //    self.navigationController.navigationBar.tintColor = [UIColor yellowColor]; // 设置返回按钮字体的颜色
    
    CYSettingViewController *setting = [[CYSettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:setting animated:YES];
}

#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CYMeCell *cell = [tableView dequeueReusableCellWithIdentifier:CYMeCellId];
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"登录/注册";
        cell.imageView.image = [UIImage imageNamed:@"setup-head-default"];
    }else{
        
        cell.textLabel.text = @"离线下载";
    }
    
    return cell;
}


//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return CYCommonMargin;
//}






@end