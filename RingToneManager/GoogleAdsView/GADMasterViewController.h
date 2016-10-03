//
//  GADMasterViewController.h
//  SmartZip
//
//  Created by Narender Kumar on 8/15/16.
//  Copyright © 2016 Pawan Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
//@interface GADMasterViewController : UIViewController

@import GoogleMobileAds;


@interface GADMasterViewController : UIViewController <GADBannerViewDelegate,GADAdDelegate,GADCustomEventBanner> {
    GADBannerView *adBanner_;
    BOOL didCloseWebsiteView_;
    BOOL isLoaded_;
    id currentDelegate_;
}

+ (GADMasterViewController *)singleton;
// - (void)resetAdView:(UIViewController *)rootViewController;
- (void)resetAdView:(UIViewController *)rootViewController AndDisplayView:(UIView *)displayView;

@end
