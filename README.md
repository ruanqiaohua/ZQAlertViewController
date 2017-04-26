# ZQAlertViewController
弹窗

![image](https://github.com/ruanqiaohua/ZQAlertViewController/blob/master/image.gif)

可以不设置标题

自适应内容

当传一张图片的时候所有都使用第一张

按钮的点击状态是系统默认状态


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