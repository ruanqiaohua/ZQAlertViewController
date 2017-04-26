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

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSArray<NSString *> *)messages images:(NSArray<NSString *> *)images selectedCallBack:(SelectedCallBack)callBack {
    
    ZQAlertController *alert = [[ZQAlertController alloc] init];
    alert.contentView = [[UIView alloc] init];
    [alert.contentView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.6]];
    alert.spacing = 10.0;
    alert.lineSpacing = 4.0;
    
    CGRect frame = alert.contentView.frame;
    if (title) {
        
        alert.titleLabel = [alert titleLabel:title];
        frame = alert.titleLabel.frame;
    }
    
    if (messages) {
        
        alert.buttons = [NSMutableArray arrayWithCapacity:messages.count];
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
            frame.size.height = alert.lineSpacing + (CGRectGetHeight(frame) + CGRectGetHeight(button.frame));
            [alert.buttons addObject:button];
        }

    }
    
    frame.size.width += 2*alert.spacing;
    frame.size.height += 2*alert.spacing;
    alert.contentView.frame = frame;
    
    if (alert.buttons) {
        
        for (int i=0; i<alert.buttons.count; i++) {
            
            UIButton *button = [alert.buttons objectAtIndex:i];
            button.bounds = CGRectMake(0, 0, frame.size.width-2*alert.spacing, button.frame.size.height);
            if (i) {
                UIButton *oldLabel = [alert.buttons objectAtIndex:i-1];
                button.center = CGPointMake(CGRectGetWidth(frame)/2,alert.lineSpacing + CGRectGetMaxY(oldLabel.frame)+CGRectGetMidY(button.frame));
            } else {
                if (alert.titleLabel) {
                    alert.titleLabel.center = CGPointMake(CGRectGetWidth(frame)/2, alert.spacing+CGRectGetMidY(alert.titleLabel.frame));
                    button.center = CGPointMake(CGRectGetWidth(frame)/2,alert.lineSpacing + CGRectGetMaxY(alert.titleLabel.frame)+CGRectGetMidY(button.frame));
                } else {
                    button.center = CGPointMake(CGRectGetWidth(frame)/2,alert.spacing + CGRectGetMaxY(alert.titleLabel.frame)+CGRectGetMidY(button.frame));
                }
            }
            [alert.contentView addSubview:button];
        }
    }
    
    if (alert.titleLabel && !messages ) {
        alert.titleLabel.center = CGPointMake(CGRectGetWidth(frame)/2, alert.spacing+CGRectGetMidY(alert.titleLabel.frame));
    }

    [alert.view addSubview:alert.contentView];
    [alert.contentView addSubview:alert.titleLabel];
    alert.contentView.center = alert.view.center;
    alert.contentView.layer.cornerRadius = 6.0;
    alert.contentView.layer.masksToBounds = YES;
    
    alert.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [alert.view setBackgroundColor:[UIColor clearColor]];
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
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel sizeToFit];
    return titleLabel;
}

- (UIButton *)buttonWithMessage:(NSString *)message image:(UIImage *)image {
    
    UIImage *newImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setTitle:message forState:UIControlStateNormal];;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setImage:newImage forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, _lineSpacing, 0, 0)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 2*_lineSpacing, 0, 0)];
    [button sizeToFit];
    [button setFrame:CGRectMake(0, 0, CGRectGetWidth(button.frame)+2*_lineSpacing, CGRectGetHeight(button.frame)+10)];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)buttonAction:(UIButton *)sender {
    
    NSInteger index = sender.tag - 100;
    if (self.selectedCb) {
        self.selectedCb(self,index);
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

- (void)setTextColor:(UIColor *)color {
    
    _titleLabel.textColor = color;
    for (UIButton *button in _buttons) {
        [button setTitleColor:color forState:UIControlStateNormal];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UIView *view = touches.allObjects.firstObject.view;
    if (view == self.view) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

@end
