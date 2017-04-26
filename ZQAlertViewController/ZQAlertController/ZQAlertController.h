//
//  ZQAlertController.h
//  Demo
//
//  Created by 阮巧华 on 2017/3/23.
//  Copyright © 2017年 阮巧华. All rights reserved.
//

#import <UIKit/UIKit.h>
#define space 10
#define line 4

typedef void(^SelectedCallBack)(NSInteger selectedIndex);

@interface ZQAlertController : UIViewController

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSArray<NSString *> *)messages images:(NSArray<NSString *> *)images selectedCallBack:(SelectedCallBack)callBack;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, assign) CGFloat spacing;

- (void)addArrowWithFrame:(CGRect)frame;

- (void)show;

@end
