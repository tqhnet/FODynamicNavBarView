//
//  FODynamicNavBarView.h
//  weixinNavDemo
//
//  Created by tqh on 2018/6/14.
//  Copyright © 2018年 tqh. All rights reserved.
//

#import <UIKit/UIKit.h>

/**动态导航栏（需要自己控制导航栏显示隐藏）*/

@interface FODynamicNavBarView : UIView

@property (nonatomic,assign) CGFloat fixedHeight;       //固定偏移多少才滑动(默认为0)
@property (nonatomic,assign) CGFloat upToShowHeight;    //上滑一定距离才恢复原状（默认为40）
@property (nonatomic,assign) CGFloat needChangeHeight;  //需要格外改变的参数，scrollview上移动

@property (nonatomic,strong) UIView *topView;           //绑定的顶部视图（***）
@property (nonatomic,strong) UIView *titleView;         //标题视图
@property (nonatomic,strong) UIView *rightView;         //右侧视图不是默认按钮

@property (nonatomic,copy) void (^scrollDistanceBlock)(CGFloat distance); //回调偏移的距离（+）
//添加左右按钮
- (void)addLeftImage:(UIImage *)image highlightImage:(UIImage *)highlightImage target:(id)target action:(SEL)action;
- (void)addRightImage:(UIImage *)image highlightImage:(UIImage *)highlightImage target:(id)target action:(SEL)action;

//绑定scrollView并且切换标题（***）
- (void)bingScrollView:(UIScrollView *)scrollView title:(NSString *)title;

@end
