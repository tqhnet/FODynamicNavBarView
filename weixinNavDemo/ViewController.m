//
//  ViewController.m
//  weixinNavDemo
//
//  Created by tqh on 2018/6/14.
//  Copyright © 2018年 tqh. All rights reserved.
//

#import "ViewController.h"
#import "CircleOfFriendsController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *pushButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)pushButtonPressed:(UIButton *)sender {
    
    
    
    CircleOfFriendsController *circle = [[CircleOfFriendsController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:circle];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
