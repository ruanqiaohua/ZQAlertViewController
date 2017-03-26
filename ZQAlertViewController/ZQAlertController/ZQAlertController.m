//
//  ZQAlertController.m
//  Demo
//
//  Created by 阮巧华 on 2017/3/23.
//  Copyright © 2017年 阮巧华. All rights reserved.
//

#import "ZQAlertController.h"

@interface ZQAlertController ()

@property (nonatomic, copy) void (^cb)(NSInteger);

@end

static ZQAlertController *alert;

@implementation ZQAlertController

+ (nonnull instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSArray<NSString *> *)messages images:(nullable NSArray<NSString *> *)images cb:(void (^ _Nullable)(NSInteger))cb {
    
    alert = [[ZQAlertController alloc] init];
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *titleLabel;
    CGRect frame = view.frame;
    if (title) {
        
        titleLabel = [self titleLabel:title];
        frame = titleLabel.frame;
    }
    
    NSMutableArray<UIButton *> *mArr;
    if (messages) {
        
        mArr = [NSMutableArray arrayWithCapacity:messages.count];
        for (int i=0; i<messages.count; i++) {
            
            NSString *message = [messages objectAtIndex:i];
            UIImage *image;
            if (i < images.count) {
                image = [UIImage imageNamed:images[i]];
            } else {
                image = [UIImage imageNamed:images[0]];
            }
            UIButton *button = [self buttonWithMessage:message image:image];
            button.tag = 100+i;
            frame.size.width = (CGRectGetWidth(frame) > CGRectGetWidth(button.frame)) ? CGRectGetWidth(frame):CGRectGetWidth(button.frame);
            frame.size.height = line + (CGRectGetHeight(frame) + CGRectGetHeight(button.frame));
            [mArr addObject:button];
        }

    }
    
    frame.size.width += 2*space;
    frame.size.height += 2*space;
    view.frame = frame;
    
    if (mArr) {
        
        for (int i=0; i<mArr.count; i++) {
            
            UIButton *button = [mArr objectAtIndex:i];
            if (i) {
                UIButton *oldLabel = [mArr objectAtIndex:i-1];
                button.center = CGPointMake(CGRectGetWidth(frame)/2,line + CGRectGetMaxY(oldLabel.frame)+CGRectGetMidY(button.frame));
            } else {
                if (titleLabel) {
                    titleLabel.center = CGPointMake(CGRectGetWidth(frame)/2, space+CGRectGetMidY(titleLabel.frame));
                    button.center = CGPointMake(CGRectGetWidth(frame)/2,line + CGRectGetMaxY(titleLabel.frame)+CGRectGetMidY(button.frame));
                } else {
                    button.center = CGPointMake(CGRectGetWidth(frame)/2,space + CGRectGetMaxY(titleLabel.frame)+CGRectGetMidY(button.frame));
                }
            }
            [view addSubview:button];
        }
    }
    
    if (titleLabel && !messages ) {
        titleLabel.center = CGPointMake(CGRectGetWidth(frame)/2, space+CGRectGetMidY(titleLabel.frame));
    }

    [alert.view addSubview:view];
    [view addSubview:titleLabel];
    view.center = alert.view.center;
    view.layer.cornerRadius = 6.0;
    view.layer.masksToBounds = YES;
    
    alert.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [alert.view setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.4]];
    if (cb) {
        alert.cb = cb;
    }
    return alert;
}

+ (UILabel *)titleLabel:(NSString *)title {
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor blackColor];
    [titleLabel sizeToFit];
    return titleLabel;
}

+ (UIButton *)buttonWithMessage:(NSString *)message image:(UIImage *)image {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:message forState:UIControlStateNormal];;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (void)buttonAction:(UIButton *)sender {
    
    NSInteger index = sender.tag - 100;
    if (alert.cb) {
        alert.cb(index);
    }
}

- (void)show {
    
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootViewController presentViewController:self animated:NO completion:nil];
}

- (void)hidden {
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UIView *view = touches.allObjects.firstObject.view;
    if (view == self.view) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

@end
