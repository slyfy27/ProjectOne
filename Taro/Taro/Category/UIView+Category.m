//
//  UIView+Category.m
//  Lover
//
//  Created by seemelk on 16/1/26.
//  Copyright © 2016年 Friendest. All rights reserved.
//

#import "UIView+Category.h"

@implementation UIView (Category)
- (void)setFrame_x:(CGFloat)frame_x
{
    CGRect frame = self.frame;
    frame.origin.x = frame_x;
    self.frame = frame;
}

- (CGFloat)frame_x
{
    return self.frame.origin.x;
}

- (void)setFrame_y:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)frame_y
{
    return self.frame.origin.y;
}

- (void)setFrame_width:(CGFloat)frame_width
{
    CGRect frame = self.frame;
    frame.size.width = frame_width;
    self.frame = frame;
}

- (CGFloat)frame_width
{
    return self.frame.size.width;
}

- (void)setFrame_height:(CGFloat)frame_height
{
    CGRect frame = self.frame;
    frame.size.height = frame_height;
    self.frame = frame;
}

- (CGFloat)frame_height
{
    return self.frame.size.height;
}

- (void)setFrame_size:(CGSize)frame_size
{
    CGRect frame = self.frame;
    frame.size = frame_size;
    self.frame = frame;
}

- (CGSize)frame_size
{
    return self.frame.size;
}

- (void)setFrame_origin:(CGPoint)frame_origin
{
    CGRect frame = self.frame;
    frame.origin = frame_origin;
    self.frame = frame;
}

- (CGPoint)frame_origin
{
    return self.frame.origin;
}

- (void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width
{
    [self removeAllBorderLayer];
    if (top) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        layer.name = @"top";
        [view.layer addSublayer:layer];
    }
    if (left) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        layer.name = @"left";
        [view.layer addSublayer:layer];
    }
    if (bottom) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, view.frame.size.height - width, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        layer.name = @"bottom";
        [view.layer addSublayer:layer];
    }
    if (right) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(view.frame.size.width - width, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        layer.name = @"right";
        [view.layer addSublayer:layer];
    }
}

- (void)removeAllBorderLayer{
    CALayer *leftlayer;
    CALayer *rightLayer;
    CALayer *topLayer;
    CALayer *bottomLayer;
    for (CALayer *layer in self.layer.sublayers) {
        if ([layer.name isEqualToString:@"top"]) {
            topLayer = layer;
        }
        else if([layer.name isEqualToString:@"left"]){
            leftlayer = layer;
        }
        else if([layer.name isEqualToString:@"right"]){
            rightLayer = layer;
        }
        else if([layer.name isEqualToString:@"bottom"]){
            bottomLayer = layer;
        }
    }
    [leftlayer removeFromSuperlayer];
    [rightLayer removeFromSuperlayer];
    [topLayer removeFromSuperlayer];
    [bottomLayer removeFromSuperlayer];
}

@end
