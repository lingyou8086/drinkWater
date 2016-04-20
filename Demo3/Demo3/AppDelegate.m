//
//  AppDelegate.m
//  Demo3
//
//  Created by hanya on 16/3/31.
//  Copyright © 2016年 hanya. All rights reserved.
//

#import "AppDelegate.h"
#import "FristPageViewController.h"
#import "LSMainViewController.h"
#import "FMDatabase.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {

    application.applicationIconBadgeNumber = 0;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
   
    
    //self.window.rootViewController = [[ViewController alloc] init];

    
    // 创建/读取本地数据库
    NSString *path            = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"datafmdb.sqlite"];
    FMDatabase *database      = [FMDatabase databaseWithPath:path];

    BOOL success              =  [database open];

    int num = 0;
    if (success) {
        NSLog(@"AppDelegate打开数据库成功!");

        NSString * sql           = @"SELECT setButtonState  FROM t_mainSeting ;";
        FMResultSet *result      = [database executeQuery:sql];
        while ([result next]) {
            
            num     = [result stringForColumnIndex:0].intValue;
        }
    }else{
        NSLog(@"AppDelegate打开数据库失败!");
    }

    if (num == 0) {

        self.window.rootViewController = [[FristPageViewController alloc] init];
    } else {
        
        // 点击过主页面的开始喝水
        self.window.rootViewController = [[LSMainViewController alloc] init];
    
    }



    [self.window makeKeyAndVisible];

    application.applicationIconBadgeNumber = 0;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
