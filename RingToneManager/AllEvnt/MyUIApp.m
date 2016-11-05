//
//  MyUIApp.m
//  Buddies Locater
//
//  Created by Narender Kumar on 2/3/16.
//  Copyright (c) 2016 Narender Kumar. All rights reserved.
// UITableViewLabel, UITabBarButton

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "MyUIApp.h"
#import "Constant.h"

@implementation MyUIApp

- (void)sendEvent:(UIEvent*)event {
    [super sendEvent:event];
    NSSet* allTouches = [event allTouches];
    UITouch* touch = [allTouches anyObject];
    const char* className = class_getName([[touch view] class]);
    NSString *cString = NSStringFromClass([[touch view] superclass]);
    /*
    NSLog(@"yourObject is a: %s, %@", className, cString);
    if([[touch view] isKindOfClass:[UIButton class]] || [cString isEqualToString:@"UIControl"] || [cString isEqualToString:@"UILabel"]) {
        if([[NSUserDefaults standardUserDefaults] objectForKey:kFullUserDefault] == nil) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:kFullUserDefault];
        }
        else {
            NSInteger adCounter = [[[NSUserDefaults standardUserDefaults] objectForKey:kFullUserDefault] intValue];
            adCounter += 1;
            NSLog(@"Full ad counter = %d",adCounter);
            if(adCounter >= FULL_AD_COUNTER) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kFullAdShowNotification object:nil];
                adCounter = 0;
            }
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:adCounter] forKey:kFullUserDefault];

        }
    }
     */
}


@end
