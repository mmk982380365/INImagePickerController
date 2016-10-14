//
//  INImageBorderView.m
//  INImagePickerController
//
//  Created by MaMingkun on 16/10/10.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import "INImageBorderView.h"

@implementation INImageBorderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    
    CGPoint center = CGPointMake(rect.size.width * 0.5, rect.size.height * 0.5);

    CGContextRef context1 = UIGraphicsGetCurrentContext();
    CGContextAddRect(context1, CGRectMake(0, 0, rect.size.width, center.y - rect.size.width * 0.5));
    
    [[[UIColor grayColor] colorWithAlphaComponent:0.6] setFill];
    CGContextClosePath(context1);
    
    CGContextDrawPath(context1, kCGPathFill);
    
    
    CGContextRef context2 = UIGraphicsGetCurrentContext();
    CGContextAddRect(context2, CGRectMake(0, center.y + rect.size.width * 0.5, rect.size.width, center.y - rect.size.width * 0.5 + 1));
    
    [[[UIColor grayColor] colorWithAlphaComponent:0.6] setFill];
    CGContextClosePath(context2);
    
    CGContextDrawPath(context2, kCGPathFill);
    
    
    
    rect.size.height = rect.size.width;
    rect.origin.y = center.y - rect.size.width * 0.5;
    
//    rect.origin.x += 1;
//    rect.origin.y += 1;
//    rect.size.width -= 2;
//    rect.size.height -= 2;
    
    float radius = rect.size.width * 0.5;
    
    for (int i = 0; i < 4; i++) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 2);
        
        
        
        //        CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] colorWithAlphaComponent:0.8].CGColor);
        //        CGContextSetFillColorWithColor(context, [[UIColor redColor] colorWithAlphaComponent:0.9].CGColor);
        //
        CGMutablePathRef path = CGPathCreateMutable();
        //        CGMutablePathRef path2 = CGPathCreateMutable();
        
        CGContextBeginPath(context);
        
        CGRect fillRect;
        
        switch (i) {
            case 0:
            {
                
                CGPathAddArc(path, NULL, center.x, center.y, rect.size.width * 0.5, M_PI_2 * 3, M_PI_2 * 2, 1);
                
                CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y + radius);
                CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y);
                CGPathAddLineToPoint(path, NULL, rect.origin.x + radius, rect.origin.y);
                
                
                
                CGPathMoveToPoint(path, NULL, rect.origin.x + radius, rect.origin.y);
                
                //                CGPathMoveToPoint(path, NULL, center.x, center.y);
                
                
                fillRect = CGRectMake(rect.origin.x, rect.origin.y, radius, radius);
                
            }
                break;
            case 1:
            {
                
                CGPathAddArc(path, NULL, center.x, center.y, rect.size.width * 0.5, M_PI_2 * 4, M_PI_2 * 3, 1);
                
                CGPathMoveToPoint(path, NULL, rect.origin.x + radius, rect.origin.y);
                CGPathAddLineToPoint(path, NULL, rect.origin.x + radius + radius, rect.origin.y);
                CGPathAddLineToPoint(path, NULL, rect.origin.x + radius + radius, rect.origin.y + radius);
                
                CGPathMoveToPoint(path, NULL, rect.origin.x + radius + radius, rect.origin.y + radius);
                
                //                CGPathMoveToPoint(path, NULL, center.x, center.y);
                
                
                fillRect = CGRectMake(rect.origin.x + radius, rect.origin.y, radius, radius);
                
            }
                break;
            case 2:
            {
                
                CGPathAddArc(path, NULL, center.x, center.y, rect.size.width * 0.5, M_PI_2 * 1, M_PI_2 * 2, 0);
                
                CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y + radius);
                CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y + radius + radius);
                CGPathAddLineToPoint(path, NULL, rect.origin.x + radius, rect.origin.y + radius + radius);
                
                CGPathMoveToPoint(path, NULL, rect.origin.x + radius, rect.origin.y + radius + radius);
                
                //                CGPathMoveToPoint(path, NULL, center.x, center.y);
                
                
                fillRect = CGRectMake(rect.origin.x, rect.origin.y + radius, radius, radius);
                
            }
                break;
            case 3:
            {
                
                CGPathAddArc(path, NULL, center.x, center.y, rect.size.width * 0.5, M_PI_2 * 0, M_PI_2 * 1, 0);
                
                CGPathMoveToPoint(path, NULL, rect.origin.x + radius, rect.origin.y + radius + radius);
                CGPathAddLineToPoint(path, NULL, rect.origin.x + radius + radius, rect.origin.y + radius + radius);
                CGPathAddLineToPoint(path, NULL, rect.origin.x + radius + radius, rect.origin.y + radius);
                
                CGPathMoveToPoint(path, NULL, rect.origin.x + radius + radius, rect.origin.y + radius);
                
                //                CGPathMoveToPoint(path, NULL, center.x, center.y);
                
                
                fillRect = CGRectMake(rect.origin.x + radius, rect.origin.y + radius, radius, radius);
                
            }
                break;
                
            default:
                break;
        }
        
        fillRect.size.width *= 0.5;
        fillRect.size.height *= 0.5;
        
        CGContextSetLineJoin(context, kCGLineJoinRound);
        
        CGPathCloseSubpath(path);
        
        //        CGPathAddPath(path, NULL, path2);
        CGContextAddPath(context, path);
        
        //        CGContextSetRGBFillColor(context, 1, 1, 0, 0.8);
        
        //        CGContextStrokePath(context);
        CGContextClosePath(context);
        //        cgcontextset
        
        [[[UIColor grayColor] colorWithAlphaComponent:0.6] setStroke];
        [[[UIColor grayColor] colorWithAlphaComponent:0.6] setFill];
        
        
        //        CGContextStrokePath(context);
        //        CGContextFillPath(context);
        CGContextDrawPath(context, kCGPathFill);
        
        CGContextAddArc(context, center.x, center.y, center.x - 1, 0, M_PI * 2, 1);
        
        CGContextClosePath(context);
        //        cgcontextset
        
        [[[UIColor whiteColor] colorWithAlphaComponent:0.8] setStroke];
        CGContextDrawPath(context, kCGPathStroke);
    
    }
    
    
    
    //
    
    //    CGContextRef context2 = UIGraphicsGetCurrentContext();
    //
    //    CGContextSetLineWidth(context2, 2);
    //    CGContextSetStrokeColorWithColor(context2, [[UIColor whiteColor] colorWithAlphaComponent:0.8].CGColor);
    //    CGContextSetFillColorWithColor(context2, [[UIColor whiteColor] colorWithAlphaComponent:0].CGColor);
    //    
    //    
    //    
    //    
    //    CGContextAddPath(context2, path2);
    //    CGContextStrokePath(context2);
    //    CGContextFillRect(context2, rect);
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
