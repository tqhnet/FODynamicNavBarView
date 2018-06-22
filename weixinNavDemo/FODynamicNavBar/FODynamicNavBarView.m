//
//  FODynamicNavBarView.m
//  weixinNavDemo
//
//  Created by tqh on 2018/6/14.
//  Copyright © 2018年 tqh. All rights reserved.
//

#import "FODynamicNavBarView.h"

#define kSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define kSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define kiPhoneX (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125,2436), [[UIScreen mainScreen] currentMode].size) : NO))
@interface FODynamicNavBarView()
{
    CGRect _normalFrame;        //原来rect
    CGFloat _normalHeight;      //普通高度
    CGFloat _normalMinHeight;   //默认最小高度
    CGRect _cacheTopVireRect;   //缓存的top的高度
    CGFloat _statusSpace;       //状态栏区域
}
@property (nonatomic,strong) UIScrollView *scrollView;  //监听的滚动视图
@property (nonatomic,strong) UIView *lineView;      //线条
@property (nonatomic,strong) UILabel *titleLabel;   //标题视图
@property (nonatomic,strong) UIView *bgView;        //背景视图
@property (nonatomic,strong) UIButton *leftButton;  //左边按钮
@property (nonatomic,strong) UIButton *rightButton; //右边按钮

@property (nonatomic,assign) CGFloat tempScrollY;   //临时缓存滚动坐标
@property (nonatomic,assign) BOOL lockScroll;       //下滑锁定
@property (nonatomic,assign) BOOL lockScroll2;      //上滑锁定
@property (nonatomic,assign) BOOL lock;             //顶部锁
@property (nonatomic,assign) BOOL otherScrollLock;       //回调的
@end

@implementation FODynamicNavBarView

- (void)dealloc {
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.leftButton];
        [self addSubview:self.rightButton];
        [self addSubview:self.lineView];
        _normalFrame = frame;
        _normalHeight = frame.size.height;
        _fixedHeight = 0;
        
        _upToShowHeight = 40;
        if (kiPhoneX) {
            _statusSpace = 44;
            _normalMinHeight = 64;
        }else {
            _statusSpace = 20;
            _normalMinHeight = 40;
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPressed)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)layoutSubviews {
    
    CGFloat topSpace = _statusSpace;
    CGFloat changeSpace = _normalHeight - self.frame.size.height;
    self.bgView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, self.frame.size.height);
    self.titleLabel.frame = CGRectMake((kSCREEN_WIDTH - 200)/2, topSpace, 200, self.frame.size.height - topSpace);

    CGFloat fontSize = 16*(self.frame.size.height)/_normalHeight;
    fontSize = fontSize>12?fontSize:12;
    self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    self.lineView.frame = CGRectMake(0, self.frame.size.height - 0.5, kSCREEN_WIDTH, 0.5);
    
    //改变子控件的frame
    self.leftButton.frame = CGRectMake(0, topSpace - changeSpace, 44, 44);
    self.rightButton.frame = CGRectMake(kSCREEN_WIDTH - 44, topSpace - changeSpace, 44, 44);
    self.rightView.frame = CGRectMake(kSCREEN_WIDTH - 44, topSpace - changeSpace, 44, 44);
    
    //自定义视图大小
    if ((!self.leftButton.hidden && !self.rightButton.hidden) || (!self.leftButton.hidden && self.rightView)) {
        self.titleView.frame = CGRectMake(44,_statusSpace+7-changeSpace, kSCREEN_WIDTH - 88, 30);
    }else if (!self.leftButton.hidden) {
        self.titleView.frame = CGRectMake(44,_statusSpace+7-changeSpace, kSCREEN_WIDTH-44-14, 30);
    }else if (!self.rightButton.hidden || self.rightView){
        if ([self.titleView isKindOfClass:[UILabel class]]) {
            self.titleView.frame = CGRectMake(44,_statusSpace+7-changeSpace, kSCREEN_WIDTH-88, 30);
        }else {
            self.titleView.frame = CGRectMake(7,_statusSpace+7-changeSpace, kSCREEN_WIDTH-44-14, 30);
        }
    }else {
        self.titleView.frame = CGRectMake(7,_statusSpace+7-changeSpace, kSCREEN_WIDTH -14, 30);
    }
    
    CGFloat alpha = 0;
    if (self.frame.size.height < _normalHeight -2) {
        alpha = 0;
        
    }else {
        alpha = 1;
    }
    //避免东动画出错
    [UIView animateWithDuration:0.2 animations:^{
        self.titleLabel.alpha = 1-alpha;
        self.leftButton.alpha = alpha;
        self.rightButton.alpha = alpha;
        self.rightView.alpha = alpha;
        self.titleView.alpha = alpha;
    } completion:^(BOOL finished) {
        self.titleLabel.alpha = 1-alpha;
        self.leftButton.alpha = alpha;
        self.rightButton.alpha = alpha;
        self.rightView.alpha = alpha;
        self.titleView.alpha = alpha;
    }];
    
    if (self.frame.size.height == _normalMinHeight) {
        self.lineView.alpha = 1;
    }else {
        self.lineView.alpha = 0;
    }
}

- (void)addLeftImage:(UIImage *)image highlightImage:(UIImage *)highlightImage target:(id)target action:(SEL)action{
    self.leftButton.frame = CGRectMake(0, _statusSpace, 44, 44);
    [self.leftButton setImage:image forState:UIControlStateNormal];
    [self.leftButton setImage:highlightImage forState:UIControlStateHighlighted];
    [self.leftButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    self.leftButton.hidden = NO;
}
- (void)addRightImage:(UIImage *)image highlightImage:(UIImage *)highlightImage target:(id)target action:(SEL)action {
    self.rightButton.frame = CGRectMake(kSCREEN_WIDTH - 44, _statusSpace, 44, 44);
    [self.rightButton setImage:image forState:UIControlStateNormal];
    [self.rightButton setImage:highlightImage forState:UIControlStateHighlighted];
    [self.rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.hidden = NO;
}

- (void)setTitleView:(UIView *)titleView {
    _titleView = titleView;
    CGRect rect = titleView.frame;
    if (self.leftButton.frame.size.height>0) {
         titleView.frame = CGRectMake(7+44,_statusSpace+7, rect.size.width-44, rect.size.height);
    }else {
         titleView.frame = CGRectMake(7,_statusSpace+7, rect.size.width, rect.size.height);
    }
   
    [self addSubview:titleView];
}

- (void)setRightView:(UIView *)rightView {
    _rightView = rightView;
    _rightView.frame = CGRectMake(kSCREEN_WIDTH - 44, _statusSpace, 44, 44);
    [self addSubview:rightView];
}
- (void)setTopView:(UIView *)topView {
    _topView = topView;
    _cacheTopVireRect = topView.frame;
}

- (void)bingScrollView:(UIScrollView *)scrollView title:(NSString *)title {
    if (self.scrollView) {
        //移除以前的监听
        [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    }
    self.scrollView = scrollView;
    //添加最新的监听
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    self.titleLabel.text = title;
}

#pragma mark - 事件监听

- (void)tapPressed {
    [UIView animateWithDuration:0.2 animations:^{
        if (self.topView) {
            self.topView.frame = CGRectMake(0, _cacheTopVireRect.origin.y,_cacheTopVireRect.size.width,_cacheTopVireRect.size.height);
            self.topView.alpha = 1;
        }
        self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, _normalHeight);
    } completion:^(BOOL finished) {
    }];
}

//一个往上滑动的趋势

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        NSValue *oldvalue = change[NSKeyValueChangeOldKey];
        NSValue *newvalue = change[NSKeyValueChangeNewKey];
        CGFloat oldoffset_y = oldvalue.UIOffsetValue.vertical;
        CGFloat newoffset_y = newvalue.UIOffsetValue.vertical;
        
        //拦截最大高度

        if (newoffset_y < 0 || oldoffset_y < 0) {

            self.lockScroll = NO;
            self.lockScroll2 = NO;

            if (!self.lock) {
                self.lock = YES;
                if (self.topView) {
                    self.topView.frame = CGRectMake(0, _cacheTopVireRect.origin.y,_cacheTopVireRect.size.width,_cacheTopVireRect.size.height);
                    self.topView.alpha = 1; 
                }
                self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, _normalHeight);
                self.lock = NO;

                if (self.scrollDistanceBlock && !self.otherScrollLock) {
                    self.otherScrollLock = YES;
                    self.scrollDistanceBlock(0);
                    self.otherScrollLock = NO;
//                    [UIView animateWithDuration:0.1 animations:^{
//                        self.scrollDistanceBlock(0);
//                    } completion:^(BOOL finished) {
////                           self.scrollDistanceBlock(0);
//                        self.otherScrollLock = NO;
//                    }];
                }
            }
            return;
        }
        //后拦截这个避免便不会原状
        CGFloat space = self.scrollView.contentSize.height - kSCREEN_HEIGHT ;
        if (newoffset_y > space || oldoffset_y > space) {
            return;
        }
        //固定时候判断
        if (newoffset_y < _fixedHeight) {
            return;
        }
        
        //持续的时候记录缓存坐标
        if (newoffset_y > oldoffset_y)
        {

            //当开始下滑的时候记录开始坐标
            self.lockScroll2 = NO;
            if (!self.lockScroll) {
                self.tempScrollY = oldoffset_y;
                self.lockScroll = YES;
           
            }

            CGFloat fixedHeight = newoffset_y - self.tempScrollY; //算出改变的大小
            
            if (self.topView) {
                if (self.topView.frame.origin.y <= _normalMinHeight-_cacheTopVireRect.size.height) {
                    return;
                }
            }
            
            CGFloat navHeight = _normalHeight - fixedHeight;
            
            //改变后的高度
            navHeight = navHeight < _normalMinHeight ?_normalMinHeight : navHeight;
            
            self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, navHeight);

            
            CGFloat topY = fixedHeight;
            
            if (topY > _cacheTopVireRect.size.height +  _normalHeight - _normalMinHeight + self.needChangeHeight) {
                topY = _cacheTopVireRect.size.height +  _normalHeight - _normalMinHeight + self.needChangeHeight;
            }
            
            //top的高度
            if (self.topView) {
               self.topView.frame = CGRectMake(0, _cacheTopVireRect.origin.y - topY,_cacheTopVireRect.size.width,_cacheTopVireRect.size.height);
            }

            if (self.scrollDistanceBlock && !self.otherScrollLock) {
                self.scrollDistanceBlock(topY);
            }

        }
        else if(newoffset_y < oldoffset_y)
        {
            self.lockScroll = NO;
            if (!self.lockScroll2) {
                self.tempScrollY = oldoffset_y;
                self.lockScroll2 = YES;
            }
            CGFloat fixedHeight = self.tempScrollY -  newoffset_y; //算出改变的大小
            
            //到了一定的点再判断
            if (fixedHeight - _normalHeight - _upToShowHeight > 0) {

                
                
                CGFloat navHeight = fixedHeight - _normalHeight - _upToShowHeight;

                
                navHeight = navHeight < _normalMinHeight ?_normalMinHeight : navHeight;
                
                if (navHeight>_normalHeight) {
                    navHeight = _normalHeight;
                }
                self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, navHeight);
                
                //现在的减去原来的
                CGFloat topY = fixedHeight - _normalHeight - _upToShowHeight - _cacheTopVireRect.size.height - (_normalHeight - _normalMinHeight) - self.needChangeHeight;
                if (topY > 0) {
                    topY = 0;
                }

               self.topView.frame = CGRectMake(0,
                                               _cacheTopVireRect.origin.y + topY,
                                               _cacheTopVireRect.size.width,
                                               _cacheTopVireRect.size.height);

                if (self.scrollDistanceBlock && !self.otherScrollLock) {
                    self.scrollDistanceBlock(-topY);
                }
                
            }else {
                
            }
        }
    }
}

- (void)changeFrameNormal:(BOOL)normal {
    if (normal) {
        self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, _normalHeight);
        
    }else {
        self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, _normalMinHeight);
    }
}

#pragma mark - 懒加载

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"";
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.alpha = 1;
    }
    return _titleLabel;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [[UIButton alloc]init];
        _leftButton.hidden = YES;
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton new];
        _rightButton.hidden = YES;
    }
    return _rightButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor lightGrayColor];
        _lineView.alpha = 0.3;
    }
    return _lineView;
}

@end
