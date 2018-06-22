//
//  CircleOfFriendsController.m
//  weixinNavDemo
//
//  Created by tqh on 2018/6/14.
//  Copyright © 2018年 tqh. All rights reserved.
//

#import "CircleOfFriendsController.h"
#import "FODynamicNavBarView.h"
#import "UIViewController+FONavBar.h"

#define kSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define kSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface CircleOfFriendsController ()


@property (nonatomic,strong) UIScrollView *scrollView;              //滚动视图
@property (nonatomic,strong) UIView *showView;
@property (nonatomic,strong) UIView *topView;//选择菜单
@end

@implementation CircleOfFriendsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [[UINavigationBar appearance] setBarTintColor:[UIColor redColor]];
    
    [self.view addSubview:self.scrollView];
   
    [self.view addSubview:self.topView];
    [self.scrollView addSubview:self.showView];
    
    
     [self.view addSubview:self.navBarView];
    [self.navBarView bingScrollView:self.scrollView title:@"标题"];
    self.navBarView.topView = self.topView;
    self.navBarView.fixedHeight = 200;
    __weak typeof(self) myself = self;
    [self.navBarView setScrollDistanceBlock:^(CGFloat distance) {
       myself.scrollView.frame = CGRectMake(0, 64 - distance, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64+distance);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
//    self.navigationController.
//    self.navBarView.oldPushHaveNav = !self.navigationController.navigationBar.hidden;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
//    if (self.navBarView.oldPushHaveNav) {
//        self.navigationController.navigationBar.hidden = !self.navBarView.oldPushHaveNav;
//    }
}

#pragma mark - 懒加载


- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64)];
        _scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH, kSCREEN_HEIGHT *2);
    }
     return _scrollView;
}

- (UIView *)showView {
    if (!_showView) {
        _showView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 200)];
        _showView.backgroundColor = [UIColor yellowColor];
    }
    return _showView;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, 50)];
        _topView.backgroundColor = [UIColor blueColor];
    }
    return _topView;
}


@end
