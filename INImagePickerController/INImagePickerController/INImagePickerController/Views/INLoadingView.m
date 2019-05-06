//
//  INLoadingView.m
//  INImagePickerController
//
//  Created by Yuuki on 2019/5/6.
//  Copyright © 2019 Yuuki. All rights reserved.
//

#import "INLoadingView.h"

@interface INLoadingView ()

@property (strong, nonatomic) UIVisualEffectView *backgroundView;

@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;

@end

@implementation INLoadingView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        self.backgroundView = [[UIVisualEffectView alloc] initWithEffect:effect];
        self.backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.backgroundView];
        
        
        self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.backgroundView.contentView addSubview:self.indicatorView];
        [self.indicatorView startAnimating];
        
        
        NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.backgroundView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:70.0];
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.backgroundView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:70.0];
        NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.backgroundView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
        NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.backgroundView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
        [self addConstraints:@[width, height, centerX, centerY]];
        
        NSLayoutConstraint *indicatorCenterX = [NSLayoutConstraint constraintWithItem:self.indicatorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.backgroundView.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
        NSLayoutConstraint *indicatorCenterY = [NSLayoutConstraint constraintWithItem:self.indicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.backgroundView.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
        [self.backgroundView.contentView addConstraints:@[indicatorCenterX, indicatorCenterY]];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
