//
//  AppDelegate.m
//  Taro
//
//  Created by wushuying on 2018/3/16.
//  Copyright © 2018年 wushuying. All rights reserved.
//

#import "AppDelegate.h"
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <FacebookConnector/FacebookConnector.h>
#import <TwitterKit/TWTRKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[TWTRTwitter sharedInstance] startWithConsumerKey:@"1gFzSPd3YbI9y1aAxGSyycAId" consumerSecret:@"luJOmJAkgWhJS17Z7ff51Ll2j0pF7LttovwFpVBkwg3Mj4bR0Y"];
    [ShareSDK registerActivePlatforms:@[@(SSDKPlatformTypeFacebook),@(SSDKPlatformTypeYouTube),@(SSDKPlatformTypeTwitter),@(SSDKPlatformTypeInstagram)] onImport:^(SSDKPlatformType platformType) {
        
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        switch (platformType) {
            case SSDKPlatformTypeYouTube:
                [appInfo SSDKSetupYouTubeByClientId:@"323232334081-5s9qqvqrlvvvho4vn94h47046ufhj7qb.apps.googleusercontent.com" clientSecret:@"" redirectUri:@"http://localhost"];
                break;
            case SSDKPlatformTypeFacebook:
                        [appInfo SSDKSetupFacebookByApiKey:@"149883025847374" appSecret:@"b533d9806f4fb7a511042afbdaccc047" displayName:@"TTTracking" authType:SSDKAuthTypeBoth];
                break;
            case SSDKPlatformTypeTwitter:
                [appInfo SSDKSetupTwitterByConsumerKey:@"1gFzSPd3YbI9y1aAxGSyycAId" consumerSecret:@"luJOmJAkgWhJS17Z7ff51Ll2j0pF7LttovwFpVBkwg3Mj4bR0Y" redirectUri:@"https://www.taro.ai"];
                break;
            case SSDKPlatformTypeInstagram:
                [appInfo SSDKSetupInstagramByClientID:@"4d5c80181a3e42ca869ddb139d475557" clientSecret:@"563774ed72f34f33805df62587496ac4" redirectUri:@"http://www.taro.com"];
                break;
            default:
                break;
        }
    }];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    return [[Twitter sharedInstance] application:app openURL:url options:options];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
