//
//  AppDelegate.m
//  RingToneManager
//
//  Created by Pawan Kumar on 02/06/16.
//  Copyright © 2016 Pawan Kumar. All rights reserved.
//

#import "AppDelegate.h"
#import "iRate.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self irateSetup];
        return YES;
}



-(void)irateSetup
{
    [iRate sharedInstance].applicationBundleID=@"com.mobirizer.ringtonemaker";
    [iRate sharedInstance].appStoreID = 1141913794;
    [iRate sharedInstance].ratingsURL =[NSURL URLWithString:@"https://itunes.apple.com/us/app/smartringtonemaker/id1161425556?ls=1&mt=8"];
    [iRate sharedInstance].onlyPromptIfLatestVersion = false;
    [iRate sharedInstance].previewMode = false;
    [iRate sharedInstance]. daysUntilPrompt = 1;
    [iRate sharedInstance].usesUntilPrompt = 2;
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

