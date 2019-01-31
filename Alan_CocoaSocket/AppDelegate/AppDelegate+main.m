//
//  AppDelegate+main.m
//  CocoaAsyncSocket_TCP
//
//  Created by Alan on 2018/5/12.
//  Copyright © 2018年 Alan. All rights reserved.
//

#import "AppDelegate+main.h"
#import "ChatTabbarController.h"

@implementation AppDelegate (main)

- (void)initMainController
{
    self.window = [[UIWindow alloc]initWithFrame:SCREEN_BOUNDS];
    ChatTabbarController *tabbarVc = [[ChatTabbarController alloc]init];
    self.window.rootViewController = tabbarVc;
    [self.window makeKeyAndVisible];
}



@end
