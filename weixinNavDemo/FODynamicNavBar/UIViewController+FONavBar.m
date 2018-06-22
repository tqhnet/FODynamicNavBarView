//
//  UIViewController+FONavBar.m
//  weixinNavDemo
//
//  Created by tqh on 2018/6/14.
//  Copyright © 2018年 tqh. All rights reserved.
//

#import "UIViewController+FONavBar.h"
#import <objc/runtime.h>
#define kSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define kiPhoneX (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125,2436), [[UIScreen mainScreen] currentMode].size) : NO))

static char *navBarViewKey = "navBarViewKey";

@implementation UIViewController (FONavBar)

- (void)setNavBarView:(FODynamicNavBarView *)navBarView {
        objc_setAssociatedObject(self, &navBarViewKey, navBarView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (FODynamicNavBarView *)navBarView {
    FODynamicNavBarView *navBarView = objc_getAssociatedObject(self, &navBarViewKey);
    if (!navBarView) {
        if (kiPhoneX) {
            navBarView = [[FODynamicNavBarView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 88)];
        }else {
            navBarView = [[FODynamicNavBarView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 64)];
        }
        objc_setAssociatedObject(self, &navBarViewKey, navBarView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return navBarView;
}


@end
