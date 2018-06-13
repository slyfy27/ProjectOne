//
//  CircleView.m
//  Taro
//
//  Created by wushuying on 2018/6/14.
//  Copyright © 2018年 wushuying. All rights reserved.
//

#import "CircleView.h"

@implementation CircleView

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //Draw the unfilled circle
    CGContextAddArc(ctx, self.frame.size.width/2, self.frame.size.height/2, self.frame.size.height/2, 0, M_PI * 2, 0);//0, M_PI *2, 0
    [[UIColor yellowColor] setFill];
    //    CGContextSetLineWidth(ctx, _lineWidth);
    CGContextSetLineCap(ctx, kCGLineCapButt);
    CGContextDrawPath(ctx, kCGPathStroke);
}

@end
