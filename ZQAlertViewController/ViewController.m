//
//  ViewController.m
//  ZQAlertViewController
//
//  Created by 阮巧华 on 2017/3/26.
//  Copyright © 2017年 阮巧华. All rights reserved.
//

#import "ViewController.h"
#import "ZQPickViewController.h"

@interface ViewController ()

@property (nonatomic, strong) ZQPickViewController *pickVC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    NSString *message1 = @"每个恋爱";
    NSString *message2 = @"每个恋爱中的人";
    NSString *message3 = @"每个恋爱中的人都是";
    NSString *message4 = @"每个恋爱中的人都是诗人";
    NSArray *_list = @[message1,message2,message3,message4];

    _pickVC = [ZQPickViewController alertControllerWithTitle:@"诗人" message:_list images:@[@"06.png",@"11.png",@"鹿鹿.png",@"夜晚.png",] selectedCallBack:^(ZQPickViewController *alertController,NSInteger selectedIndex) {
        
        [alertController hidden];
        NSLog(@"%ld",selectedIndex);
    }];

}

- (IBAction)showAlert:(UIButton *)sender {
    
    [_pickVC setStartPoint:CGPointMake(sender.center.x, CGRectGetMaxY(sender.frame))];
    [_pickVC addNewMessage:@"小心心" image:@"06.png"];
    [_pickVC show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
