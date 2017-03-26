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
    
    NSString *networkError = @"网络故障,请检查网络";
    NSString *hardwareFailure = @"硬件故障";
    NSString *softwareFailures = @"软件故障";
    NSString *useConsulting = @"使用咨询";
    NSArray *_list = @[networkError,hardwareFailure,softwareFailures,useConsulting];
    
    ZQAlertController *vc = [ZQAlertController alertControllerWithTitle:@"Title" message:_list images:nil cb:^(NSInteger index) {
        NSLog(@"%ld",(long)index);
    }];
    [vc show];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
