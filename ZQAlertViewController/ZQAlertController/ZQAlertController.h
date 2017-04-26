//
//  ZQAlertController.h
//  Demo
//
//  Created by 阮巧华 on 2017/3/23.
//  Copyright © 2017年 阮巧华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQAlertController : UIViewController

typedef void(^SelectedCallBack)(ZQAlertController *alertController,NSInteger selectedIndex);

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSArray<NSString *> *)messages images:(NSArray<NSString *> *)images selectedCallBack:(SelectedCallBack)callBack;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, assign) CGFloat spacing;

@property (nonatomic, assign) CGFloat lineSpacing;

@property (nonatomic, assign) BOOL arrowHidden;

@property (nonatomic, strong) NSMutableArray <UIButton *> *buttons;

- (void)setTextColor:(UIColor *)color;

- (void)setStartPoint:(CGPoint)point;

- (void)show;

- (void)hidden;

@end
