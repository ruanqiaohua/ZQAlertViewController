//
//  ZQPickViewController.h
//  Demo
//
//  Created by 阮巧华 on 2017/3/23.
//  Copyright © 2017年 阮巧华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQPickViewController : UIViewController

typedef void(^SelectedCallBack)(ZQPickViewController *alertController,NSInteger selectedIndex);

/**
 初始化

 @param title 标题
 @param messages 列表
 @param images 列表图片
 @param callBack 点击回调
 */
+ (instancetype)alertControllerWithTitle:(NSString *)title messages:(NSMutableArray<NSString *> *)messages images:(NSMutableArray<NSString *> *)images selectedCallBack:(SelectedCallBack)callBack;
/** 弹窗 */
@property (nonatomic, strong) UIScrollView *contentView;
/** 弹窗最大高度 */
@property (nonatomic, assign) CGFloat maxHeight;
/** 内容间距 */
@property (nonatomic, assign) CGFloat spacing;
/** 行间距 */
@property (nonatomic, assign) CGFloat lineSpacing;
/** 选中第几行 */
@property (nonatomic, assign) NSInteger selectedIndex;
/** 箭头隐藏 (默认显示) */
@property (nonatomic, assign) BOOL arrowHidden;
/** 标题文本颜色 */
@property (nonatomic, strong) UIColor *titleTextColor;
/** 文本颜色 */
@property (nonatomic, strong) UIColor *textColor;
/** 文本高亮颜色 */
@property (nonatomic, strong) UIColor *textHighlightedColor;
/** 标题文本字体大小 */
@property (nonatomic, strong) UIFont *titleTextFont;
/** 文本字体大小 */
@property (nonatomic, strong) UIFont *textFont;
/** 出生点 */
- (void)setStartPoint:(CGPoint)point;
/** 添加新的数据 */
- (void)addNewMessage:(NSString *)message image:(NSString *)image;
/** 显示 */
- (void)show;
/** 隐藏 */
- (void)hidden;

@end
