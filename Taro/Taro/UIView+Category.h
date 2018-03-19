//
//  UIView+Category.h
//  Lover
//
//  Created by seemelk on 16/1/26.
//  Copyright © 2016年 Friendest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Category)
@property (assign, nonatomic) CGFloat frame_x;
@property (assign, nonatomic) CGFloat frame_y;
@property (assign, nonatomic) CGFloat frame_width;
@property (assign, nonatomic) CGFloat frame_height;
@property (assign, nonatomic) CGSize  frame_size;
@property (assign, nonatomic) CGPoint frame_origin;

- (void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width;
- (void)removeAllBorderLayer;

@end
