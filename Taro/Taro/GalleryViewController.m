//
//  GalleryViewController.m
//  Taro
//
//  Created by wushuying on 2018/3/25.
//  Copyright © 2018年 wushuying. All rights reserved.
//

#import "GalleryViewController.h"

@interface GalleryViewController ()

@end

@implementation GalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRightNavigationBarButton:@selector(edit) title:@"EDIT" image:nil];
    [self setTitle:@"Gallery"];
}

- (void)edit{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
