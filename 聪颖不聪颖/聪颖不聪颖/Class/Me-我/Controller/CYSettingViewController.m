//
//  CYSettingViewController.m
//  聪颖不聪颖
//
//  Created by 葛聪颖 on 15/9/6.
//  Copyright (c) 2015年 gecongying. All rights reserved.
//

#import "CYSettingViewController.h"
#import <SDImageCache.h>
#import "CYClearCacheCell.h"
#import "CYThirdCell.h"

@interface CYSettingViewController ()

@end

@implementation CYSettingViewController

static NSString * const CYClearCacheCellId = @"clearCache";
static NSString * const CYOtherCellId = @"other";
static NSString * const CYThirdCellId = @"third";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
    self.view.backgroundColor = CYCommonBgColor;
    
    [self.tableView registerClass:[CYClearCacheCell class] forCellReuseIdentifier:CYClearCacheCellId];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CYOtherCellId];
    [self.tableView registerClass:[CYThirdCell class] forCellReuseIdentifier:CYThirdCellId];
    
    // 设置内边距(-25代表：所有内容往上移动25)
    self.tableView.contentInset = UIEdgeInsetsMake(CYCommonMargin - 35, 0, 0, 0);
}

#pragma mark - <数据源>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) { // 清除缓存的cell
        CYClearCacheCell *cell = [tableView dequeueReusableCellWithIdentifier:CYClearCacheCellId];
        [cell updateStatus];
        return cell;
    } else if (indexPath.section == 1 && indexPath.row == 2) {
        return [tableView dequeueReusableCellWithIdentifier:CYThirdCellId];
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CYOtherCellId];
        cell.textLabel.text = [NSString stringWithFormat:@"%zd - %zd", indexPath.section, indexPath.row];
        return cell;
    }
}

#pragma mark - <代理>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 清除缓存
    CYClearCacheCell *cell = (CYClearCacheCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell clearCache];
}
@end
