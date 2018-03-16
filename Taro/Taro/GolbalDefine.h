//
//  GolbalDefine.h
//  Taro
//
//  Created by wushuying on 2018/3/16.
//  Copyright © 2018年 wushuying. All rights reserved.
//

#ifndef GolbalDefine_h
#define GolbalDefine_h

/**
 App版本号

 @return 版本号
 */
#define APP_VERSION @"010000"
/**
 屏幕宽度
 
 @return 屏幕宽度
 */
#define Width [UIScreen mainScreen].bounds.size.width

/**
 屏幕高度
 
 @return 屏幕高度
 */
#define Height [UIScreen mainScreen].bounds.size.height

//定义rgb颜色 用法：UIColor *color=UIColorFromRGB(0x067AB5);
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBAndAlpha(rgbValue,alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]

//定义UI颜色
#define NaviBarColor UIColorFromRGB(0x4267B2) //导航栏颜色
#define NormalTextColor UIColorFromRGB(0x373737) //常见字体颜色
#define DescTextColor UIColorFromRGB(0x999999) //描述文字颜色
#define 

#endif /* GolbalDefine_h */
