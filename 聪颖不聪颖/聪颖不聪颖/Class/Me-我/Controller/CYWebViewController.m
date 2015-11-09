//
//  CYWebViewController.m
//  聪颖不聪颖
//
//  Created by 葛聪颖 on 15/10/30.
//  Copyright © 2015年 gecongying. All rights reserved.
//

#import "CYWebViewController.h"
#import "CYSquare.h"

@interface CYWebViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardItem;
@end

@implementation CYWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.square.name;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.square.url]]];
    
    self.webView.backgroundColor = CYCommonBgColor;
    // webView是继承于UIView的，但是它能滚动，是因为它里面镶嵌了一个ScrollView的属性
    // NS_CLASS_AVAILABLE_IOS(2_0) __TVOS_PROHIBITED @interface UIWebView : UIView <NSCoding, UIScrollViewDelegate>
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
}

- (IBAction)back {
    [self.webView goBack];
}

- (IBAction)forward {
    [self.webView goForward];
}

- (IBAction)refresh {
    [self.webView reload];
}

#pragma mark - <UIWebViewDelegate>
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.backItem.enabled = webView.canGoBack;
    self.forwardItem.enabled = webView.canGoForward;
}
@end
