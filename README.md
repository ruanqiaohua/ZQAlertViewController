# ZQAlertViewController
弹窗

![image](https://github.com/ruanqiaohua/ZQAlertViewController/blob/master/image.gif)

```Objective-C

    NSString *message1 = @"每个恋爱";
    NSString *message2 = @"每个恋爱中的人";
    NSString *message3 = @"每个恋爱中的人都是";
    NSString *message4 = @"每个恋爱中的人都是诗人";
    NSArray *_list = @[message1,message2,message3,message4];
    
    ZQAlertController *vc = [ZQAlertController alertControllerWithTitle:@"诗人" message:_list images:@[@"06.png",@"11.png",@"鹿鹿.png",@"夜晚.png",] selectedCallBack:^(ZQAlertController *alertController,NSInteger selectedIndex) {

        [alertController hidden];
        NSLog(@"%ld",selectedIndex);
    }];
    [vc setStartPoint:CGPointMake(sender.center.x, CGRectGetMaxY(sender.frame))];
    [vc show];


```