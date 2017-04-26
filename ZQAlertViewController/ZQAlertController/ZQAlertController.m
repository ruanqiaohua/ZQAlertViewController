//
//  ZQAlertController.m
//  Demo
//
//  Created by 阮巧华 on 2017/3/23.
//  Copyright © 2017年 阮巧华. All rights reserved.
//

#import "ZQAlertController.h"

@interface ZQAlertController ()
{
    BOOL _isBotton;
}
@property (nonatomic, copy) SelectedCallBack selectedCb;

@end

@implementation ZQAlertController

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSArray<NSString *> *)messages images:(NSArray<NSString *> *)images selectedCallBack:(void (^)(NSInteger))callBack {
    
    ZQAlertController *alert = [[ZQAlertController alloc] init];
    alert.contentView = [[UIView alloc] init];
    [alert.contentView setBackgroundColor:[UIColor whiteColor]];
    alert.spacing = 10.0;
    
    UILabel *titleLabel;
    CGRect frame = alert.contentView.frame;
    if (title) {
        
        titleLabel = [alert titleLabel:title];
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
            UIButton *button = [alert buttonWithMessage:message image:image];
            button.tag = 100+i;
            frame.size.width = (CGRectGetWidth(frame) > CGRectGetWidth(button.frame)) ? CGRectGetWidth(frame):CGRectGetWidth(button.frame);
            frame.size.height = line + (CGRectGetHeight(frame) + CGRectGetHeight(button.frame));
            [mArr addObject:button];
        }

    }
    
    frame.size.width += 2*space;
    frame.size.height += 2*space;
    alert.contentView.frame = frame;
    
    if (mArr) {
        
        for (int i=0; i<mArr.count; i++) {
            
            UIButton *button = [mArr objectAtIndex:i];
            button.bounds = CGRectMake(0, 0, frame.size.width-2*space, button.frame.size.height);
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
            [alert.contentView addSubview:button];
        }
    }
    
    if (titleLabel && !messages ) {
        titleLabel.center = CGPointMake(CGRectGetWidth(frame)/2, space+CGRectGetMidY(titleLabel.frame));
    }

    [alert.view addSubview:alert.contentView];
    [alert.contentView addSubview:titleLabel];
    alert.contentView.center = alert.view.center;
    alert.contentView.layer.cornerRadius = 6.0;
    alert.contentView.layer.masksToBounds = YES;
    
    alert.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [alert.view setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.4]];
    if (callBack) {
        alert.selectedCb = callBack;
    }
    
    return alert;
}

- (void)addArrowWithFrame:(CGRect)frame {

    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // 如果超过下边缘
    _isBotton = CGRectGetMaxY(frame)+CGRectGetHeight(_contentView.frame) > CGRectGetHeight(self.view.frame);
    if (_isBotton) {
        
        [path moveToPoint:CGPointMake(CGRectGetMinX(frame), CGRectGetMinY(frame))];
        [path addLineToPoint:CGPointMake(CGRectGetMaxX(frame), CGRectGetMinY(frame))];
        [path addLineToPoint:CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame))];
        [path closePath];
    } else {
        [path moveToPoint:CGPointMake(CGRectGetMidX(frame), CGRectGetMinY(frame))];
        [path addLineToPoint:CGPointMake(CGRectGetMaxX(frame), CGRectGetMaxY(frame))];
        [path addLineToPoint:CGPointMake(CGRectGetMinX(frame), CGRectGetMaxY(frame))];
        [path closePath];
    }

    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.path = path.CGPath;
    layer.fillColor = _contentView.backgroundColor.CGColor;
    [self.view.layer addSublayer:layer];
    
    /** change contentView frame */
    // 如果超过下边缘
    if (_isBotton) {
        _contentView.center = CGPointMake(CGRectGetMidX(frame), CGRectGetMinY(frame)-CGRectGetHeight(_contentView.frame)/2);
    } else {
        _contentView.center = CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame)+CGRectGetHeight(_contentView.frame)/2);
    }
    // 如果超过左边缘
    if (CGRectGetMinX(_contentView.frame) < 0) {
        
        _contentView.frame = CGRectOffset(_contentView.frame, -CGRectGetMinX(_contentView.frame)+_spacing, 0);
        CGFloat spacing = _spacing+_contentView.layer.cornerRadius*2;
        if (CGRectGetMinX(frame) <  spacing) {
            layer.frame = CGRectOffset(layer.frame, spacing, 0);
        }
    }
    // 如果超过右边缘
    if (CGRectGetMaxX(_contentView.frame) > CGRectGetWidth(self.view.frame)) {
        
        _contentView.frame = CGRectOffset(_contentView.frame, -(CGRectGetMaxX(_contentView.frame)-CGRectGetWidth(self.view.frame))-_spacing, 0);
        CGFloat spacing = _spacing+_contentView.layer.cornerRadius*2;
        if (CGRectGetMaxX(frame)-CGRectGetWidth(self.view.frame) >  spacing) {
            layer.frame = CGRectOffset(layer.frame, -spacing, 0);
        }
    }
}

- (UILabel *)titleLabel:(NSString *)title {
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor blackColor];
    [titleLabel sizeToFit];
    return titleLabel;
}

- (UIButton *)buttonWithMessage:(NSString *)message image:(UIImage *)image {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setTitle:message forState:UIControlStateNormal];;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)buttonAction:(UIButton *)sender {
    
    NSInteger index = sender.tag - 100;
    if (self.selectedCb) {
        self.selectedCb(index);
    }
}

- (void)show {
    
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    __block CGRect frame = _contentView.frame;
    CGFloat height = frame.size.height;
    
    if (_isBotton) {
        
        frame.origin.y += height;
        frame.size.height = 0.0;
        _contentView.frame = frame;
        [rootViewController presentViewController:self animated:NO completion:^{
            
            [UIView animateWithDuration:0.36 animations:^{
                frame.origin.y -= height;
                frame.size.height = height;
                _contentView.frame = frame;
            }];
        }];
    } else {
        
        frame.size.height = 0.0;
        _contentView.frame = frame;
        [rootViewController presentViewController:self animated:NO completion:^{
            
            [UIView animateWithDuration:0.36 animations:^{
                frame.size.height = height;
                _contentView.frame = frame;
            }];
        }];
    }
    
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
