//
//  ViewController.m
//  ZQAlertViewController
//
//  Created by 阮巧华 on 2017/3/26.
//  Copyright © 2017年 阮巧华. All rights reserved.
//

#import "ViewController.h"
#import "ZQAlertController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)showAlert:(UIButton *)sender {
    
    NSString *networkError = @"每个恋爱";
    NSString *hardwareFailure = @"每个恋爱中的人";
    NSString *softwareFailures = @"每个恋爱中的人都是";
    NSString *useConsulting = @"每个恋爱中的人都是诗人";
    NSArray *_list = @[networkError,hardwareFailure,softwareFailures,useConsulting];
    
    CGRect frame = CGRectMake(CGRectGetMidX(sender.frame)-10, CGRectGetMaxY(sender.frame), 20, 10);
        
    ZQAlertController *vc = [ZQAlertController alertControllerWithTitle:@"诗人" message:_list images:@[@"06.png",@"11.png",@"鹿鹿.png",@"夜晚.png",] selectedCallBack:^(ZQAlertController *alertController,NSInteger selectedIndex) {

        [alertController hidden];
        NSLog(@"%ld",selectedIndex);
    }];
    [vc addArrowWithFrame:frame];
    [vc show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
