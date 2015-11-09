//
//  CYTagViewController.m
//  聪颖不聪颖
//
//  Created by 葛聪颖 on 15/9/7.
//  Copyright © 2015年 gecongying. All rights reserved.
//

#import "CYTagViewController.h"
#import "CYTagCell.h"
#import <AFNetworking.h>
#import "CYTag.h"
#import <MJExtension.h>
#import <SVProgressHUD.h>



@interface CYTagViewController ()
/** 所有的标签数据（里面存放的都是CYTag模型） */
@property (nonatomic, strong) NSArray *tags;

/** 请求管理者 */
@property (nonatomic, weak) AFHTTPSessionManager *manager;

@end

@implementation CYTagViewController

/**cell的循环利用标识*/
// NSString *CYTagCellID = @"tag;

// #define CYTagCellID @"tag"
static NSString * const CYTagCellId = @"tag";

- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"推荐标签";
    
    [self setUpTable];
    [self loadTags];
}



# pragma mark- 设置表格都和TableView有关
- (void)setUpTable
{
    self.view.backgroundColor = CYCommonBgColor;
    
    // 设置行高
    self.tableView.rowHeight = 70;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CYTagCell class]) bundle:nil] forCellReuseIdentifier:CYTagCellId];
}


# pragma mark- 专门加载标签数据
- (void)loadTags
{
    // 弹框
    //    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    
    // 加载标签数据
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"tag_recommend";
    params[@"action"] = @"sub";
    params[@"c"] = @"topic";
    
    // 发送请求
    CYWeakSelf;
    [self.manager GET:CYRequestURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (responseObject == nil) {
            // 关闭弹框
            [SVProgressHUD showErrorWithStatus:@"加载标签数据失败"];
            return;
        }
        
        // responseObject：字典数组
        // weakSelf.tags：模型数组
        // responseObject -> weakSelf.tags
        weakSelf.tags = [CYTag objectArrayWithKeyValuesArray:responseObject];
        
        // 刷新表格
        [weakSelf.tableView reloadData];
        
        // 关闭弹框
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 如果是取消了任务，就不算请求失败，就直接返回
        if (error.code == NSURLErrorCancelled) return;
        
        if (error.code == NSURLErrorTimedOut) {
            // 关闭弹框
            [SVProgressHUD showErrorWithStatus:@"加载标签数据超时，请稍后再试！"];
        } else {
            // 关闭弹框
            [SVProgressHUD showErrorWithStatus:@"加载标签数据失败"];
        }
    }];
}


- (void)dealloc
{
    // 停止请求
    [self.manager invalidateSessionCancelingTasks:YES];
    
    //    [self.manager.downloadTasks makeObjectsPerformSelector:@selector(cancel)];
    //    [self.manager.dataTasks makeObjectsPerformSelector:@selector(cancel)];
    //    [self.manager.uploadTasks makeObjectsPerformSelector:@selector(cancel)];
    
    //    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //    for (NSURLSessionTask *task in self.manager.tasks) {
    //        [task cancel];
    //    }
    
    [SVProgressHUD dismiss];
}


#pragma mark- <UITableViewDataSource>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tags.count;
}


/**
 * 返回indexPath位置对应的cell
 */
-(UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    CYTagCell *cell = [tableView dequeueReusableCellWithIdentifier:CYTagCellId];
    cell.tagModel = self.tags[indexPath.row];
    return cell;
}

@end
