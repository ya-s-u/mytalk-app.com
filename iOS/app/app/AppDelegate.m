//
//  AppDelegate.m
//  app
//
//  Created by MasanariKamoshita on 2014/06/25.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import "AppDelegate.h"


//#import "talk.h"
//#import "TalkTableViewController.h"

@implementation AppDelegate {
	NSMutableArray *talks;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // トークテーブルの初期設定
    /*
    talks = [NSMutableArray arrayWithCapacity:20];
	Talk *talk = [[Talk alloc] init];
	talk.name = @"おもしろトーク";
    talk.periodStart = 2014.1;
    talk.periodEnd = 2014.5;
	talk.shared = 1;
	talk.icon = 1;
    [talks addObject:talk];
	talk = [[Talk alloc] init];
	talk.name = @"楽しげトーク";
    talk.periodStart = 2011.5;
    talk.periodEnd = 2034.2;
	talk.shared = 1;
	talk.icon = 4;
    [talks addObject:talk];
    talk = [[Talk alloc] init];
    talk.name = @"怪しいトーク";
    talk.periodStart = 2031.3;
    talk.periodEnd = 2034.5;
	talk.shared = 1;
	talk.icon = 4;
	
    // TalkTableViewControllerへデータを渡す
    [talks addObject:talk];
	UITabBarController *tabBarController =
    (UITabBarController *)self.window.rootViewController;
	UINavigationController *navigationController =
    [[tabBarController viewControllers] objectAtIndex:0];
	TalkTableViewController *TalkTableViewController =
    [[navigationController viewControllers] objectAtIndex:0];
	TalkTableViewController.talks = talks;
     */
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
