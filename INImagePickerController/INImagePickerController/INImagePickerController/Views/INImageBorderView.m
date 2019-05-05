//
//  INImageBorderView.m
//  INImagePickerController
//
//  Created by Yuuki on 16/10/10.
//  Copyright © 2016年 Yuuki. All rights reserved.
//

#import "INImageBorderView.h"

@interface INImageBorderView () <CALayerDelegate>

@end

@implementation INImageBorderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.cropRect = CGRectMake(0, (self.frame.size.height - self.frame.size.width) / 2.0, self.frame.size.width, self.frame.size.width);
        
        CALayer *bgLayer = [CALayer layer];
        bgLayer.frame = self.bounds;
        bgLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
        bgLayer.contentsScale = [UIScreen mainScreen].scale;
        [self.layer addSublayer:bgLayer];
        
        CAShapeLayer *borderLayer = [CAShapeLayer layer];
        borderLayer.frame = self.cropRect;
        borderLayer.strokeColor = [UIColor whiteColor].CGColor;
        borderLayer.fillColor = [UIColor clearColor].CGColor;
        borderLayer.path = [self borderPathWithRect:borderLayer.bounds];
        borderLayer.lineWidth = 3;
        [self.layer addSublayer:borderLayer];
        
        CAShapeLayer *lineLayer = [CAShapeLayer layer];
        lineLayer.frame = self.cropRect;
        lineLayer.strokeColor = [UIColor whiteColor].CGColor;
        lineLayer.fillColor = [UIColor clearColor].CGColor;
        lineLayer.path = [self linePathWithRect:lineLayer.bounds];
        lineLayer.lineWidth = 1;
        [self.layer addSublayer:lineLayer];
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = self.bounds;
        maskLayer.contentsScale = [UIScreen mainScreen].scale;
        maskLayer.fillColor = [UIColor blackColor].CGColor;
        maskLayer.fillRule = kCAFillRuleEvenOdd;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
//        UIBezierPath *cloudPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0) radius:self.bounds.size.width / 2.0 startAngle:0 endAngle:M_PI * 2 clockwise:0];
//        [path appendPath:cloudPath];
        UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:self.cropRect];
        [path appendPath:rectPath];
        
        [path addClip];
        maskLayer.path = path.CGPath;
        
        bgLayer.mask = maskLayer;
        
    }
    return self;
}

- (CGPathRef)borderPathWithRect:(CGRect)rect {
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:rect];
    
    
    return bezierPath.CGPath;
}

- (CGPathRef)linePathWithRect:(CGRect)rect {
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    //row
    CGFloat perWidth = rect.size.width / 3;
    for (int i = 1; i < 3; i++) {
        [bezierPath moveToPoint:CGPointMake(i * perWidth, CGRectGetMinY(rect))];
        [bezierPath addLineToPoint:CGPointMake(i * perWidth, CGRectGetMaxY(rect))];
    }
    
    CGFloat perHeight = rect.size.height / 3;
    
    for (int i = 1; i < 3; i++) {
        [bezierPath moveToPoint:CGPointMake(CGRectGetMinX(rect), i * perHeight)];
        [bezierPath addLineToPoint:CGPointMake(CGRectGetMaxX(rect), i * perHeight)];
    }
    
    return bezierPath.CGPath;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
