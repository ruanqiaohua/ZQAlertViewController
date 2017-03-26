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

@interface ZQAlertController : UIViewController

+ (nonnull instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSArray<NSString *> *)messages images:(nullable NSArray<NSString *> *)images cb:(void (^ _Nullable)(NSInteger))cb;

- (void)show;

- (void)hidden;

@end
