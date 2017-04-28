//
//  ZQPickViewController.m
//  Demo
//
//  Created by 阮巧华 on 2017/3/23.
//  Copyright © 2017年 阮巧华. All rights reserved.
//

#import "ZQPickViewController.h"

@interface ZQPickViewController ()
{
    BOOL _isBotton;
    CAShapeLayer *_arrowLayer;
    CGFloat _screen_w;
    CGFloat _screen_h;
    CGPoint _arrowPoint;
    NSMutableArray *_temporaryMessages;
    NSMutableArray *_temporaryImages;
}

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, copy) SelectedCallBack selectedCb;

@property (nonatomic, strong) NSMutableArray *messages;

@property (nonatomic, strong) NSMutableArray *images;

@property (nonatomic, copy) NSString *titleText;

@end

@implementation ZQPickViewController

+ (instancetype)alertControllerWithTitle:(NSString *)title messages:(NSMutableArray<NSString *> *)messages images:(NSMutableArray<NSString *> *)images selectedCallBack:(SelectedCallBack)callBack {
    
    ZQPickViewController *alert = [[ZQPickViewController alloc] init];
    alert.contentView = [[UIView alloc] init];
    [alert.contentView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.6]];
    alert.spacing = 10.0;
    alert.lineSpacing = 4.0;
    
    alert.titleText = title;
    alert.messages = messages;
    alert.images = images;
    
    alert.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [alert.view setBackgroundColor:[UIColor clearColor]];
    if (callBack) {
        alert.selectedCb = callBack;
    }
    
    return alert;
}

- (void)loadUI {
    
    [_contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (_temporaryMessages.count > 0) {
        [_messages addObjectsFromArray:_temporaryMessages];
    }
    if (_temporaryImages.count > 0) {
        [_images addObjectsFromArray:_temporaryImages];
    }
    CGRect frame = _contentView.frame;
    if (_titleText) {
        _titleLabel = [self titleLabel:_titleText];
        frame = _titleLabel.frame;
    }
    
    if (_messages) {
        
        _buttons = [NSMutableArray arrayWithCapacity:_messages.count];
        for (int i=0; i<_messages.count; i++) {
            
            NSString *message = [_messages objectAtIndex:i];
            UIImage *image;
            NSString *imageName;
            if (i < _images.count) {
                imageName = _images[i];
            } else {
                imageName = _images[0];
            }
            image = [UIImage imageNamed:imageName];
            UIButton *button = [self buttonWithMessage:message image:image];
            UIImage *highlightedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_p",imageName]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            if (highlightedImage) {
                [button setImage:highlightedImage forState:UIControlStateHighlighted];
            }
            button.tag = 100+i;
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            frame.size.width = (CGRectGetWidth(frame) > CGRectGetWidth(button.frame)) ? CGRectGetWidth(frame):CGRectGetWidth(button.frame);
            frame.size.height = _lineSpacing + (CGRectGetHeight(frame) + CGRectGetHeight(button.frame));
            [_buttons addObject:button];
        }
        
    }
    
    frame.size.width += 2*_spacing;
    frame.size.height += 2*_spacing;
    _contentView.frame = frame;
    
    if (_buttons) {
        
        for (int i=0; i<_buttons.count; i++) {
            
            UIButton *button = [_buttons objectAtIndex:i];
            button.bounds = CGRectMake(0, 0, frame.size.width-2*_spacing, button.frame.size.height);
            if (i) {
                UIButton *oldButton = [_buttons objectAtIndex:i-1];
                button.center = CGPointMake(CGRectGetWidth(frame)/2,_lineSpacing + CGRectGetMaxY(oldButton.frame)+CGRectGetMidY(button.frame));
            } else {
                if (_titleLabel) {
                    _titleLabel.center = CGPointMake(CGRectGetWidth(frame)/2, _spacing+CGRectGetMidY(_titleLabel.frame));
                    button.center = CGPointMake(CGRectGetWidth(frame)/2,_lineSpacing + CGRectGetMaxY(_titleLabel.frame)+CGRectGetMidY(button.frame));
                } else {
                    button.center = CGPointMake(CGRectGetWidth(frame)/2,_spacing + CGRectGetMaxY(_titleLabel.frame)+CGRectGetMidY(button.frame));
                }
            }
            [_contentView addSubview:button];
        }
    }
    
    if (_titleLabel && !_messages ) {
        _titleLabel.center = CGPointMake(CGRectGetWidth(frame)/2, _spacing+CGRectGetMidY(_titleLabel.frame));
    }
    
    [self.view addSubview:_contentView];
    [_contentView addSubview:_titleLabel];
    _contentView.center = self.view.center;
    _contentView.layer.cornerRadius = 6.0;
    _contentView.layer.masksToBounds = YES;
    
    
    [self addArrowWithFrame:CGRectMake(_arrowPoint.x-10, _arrowPoint.y-5, 20, 10)];
    
}

- (void)setStartPoint:(CGPoint)point {
    
    _arrowPoint = point;
}

- (void)setArrowHidden:(BOOL)arrowHidden {
    
    if (arrowHidden) {
        _arrowLayer.hidden = YES;
    }
}

- (void)addArrowWithFrame:(CGRect)frame {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    _screen_w = [UIScreen mainScreen].bounds.size.width;
    _screen_h = [UIScreen mainScreen].bounds.size.height;
    // 如果超过下边缘
    _isBotton = CGRectGetMaxY(frame)+CGRectGetHeight(_contentView.frame) > _screen_h;
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
    if (_arrowLayer) {
        [_arrowLayer removeFromSuperlayer];
    }
    _arrowLayer = [[CAShapeLayer alloc] init];
    _arrowLayer.path = path.CGPath;
    _arrowLayer.fillColor = _contentView.backgroundColor.CGColor;
    [self.view.layer addSublayer:_arrowLayer];
    
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
            _arrowLayer.frame = CGRectOffset(_arrowLayer.frame, spacing, 0);
        }
    }
    // 如果超过右边缘
    if (CGRectGetMaxX(_contentView.frame) > _screen_w) {
        
        _contentView.frame = CGRectOffset(_contentView.frame, -(CGRectGetMaxX(_contentView.frame)-_screen_w)-_spacing, 0);
        CGFloat spacing = _spacing+_contentView.layer.cornerRadius*2;
        if (CGRectGetMaxX(frame)-_screen_w >  spacing) {
            _arrowLayer.frame = CGRectOffset(_arrowLayer.frame, -spacing, 0);
        }
    }
}

- (void)addNewMessage:(NSString *)message image:(NSString *)image {
    
    if (message) {
        if (!_temporaryMessages) {
            _temporaryMessages = [NSMutableArray array];
        }
        [_temporaryMessages addObject:message];
    }
    if (image) {
        if (!_temporaryImages) {
            _temporaryImages = [NSMutableArray array];
        }
        [_temporaryImages addObject:image];
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
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:message forState:UIControlStateNormal];;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if (image) {
        UIImage *newImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [button setImage:newImage forState:UIControlStateNormal];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, _lineSpacing, 0, 0)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 2*_lineSpacing, 0, 0)];
        [button sizeToFit];
        [button setFrame:CGRectMake(0, 0, CGRectGetWidth(button.frame)+2*_lineSpacing, CGRectGetHeight(button.frame)+_spacing)];
    } else {
        [button sizeToFit];
        [button setFrame:CGRectMake(0, 0, CGRectGetWidth(button.frame), CGRectGetHeight(button.frame)+_spacing)];
    }
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    return button;
}

- (void)buttonAction:(UIButton *)sender {
    
    NSInteger index = sender.tag - 100;
    if (self.selectedCb) {
        self.selectedCb(self,index);
    }
}

- (void)show {
    
    [self loadUI];
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
    
    for (id object in _temporaryImages) {
        [_images removeObject:object];
    }
    for (id object in _temporaryMessages) {
        [_messages removeObject:object];
    }
    [_temporaryImages removeAllObjects];
    [_temporaryMessages removeAllObjects];
    
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
        [self hidden];
    }
}

@end
