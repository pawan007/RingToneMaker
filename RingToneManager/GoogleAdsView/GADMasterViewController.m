//
//  GADMasterViewController.m
//  SmartZip
//
//  Created by Narender Kumar on 8/15/16.
//  Copyright © 2016 Pawan Kumar. All rights reserved.
//

#import "GADMasterViewController.h"
#import <GoogleMobileAds/GADAdSize.h>

#import "Constant.h"

//        adBanner_.adUnitID = @"ca-app-pub-7753603434154239/4797926502";


@class GADBannerView;

@interface GADMasterViewController ()

@end

@implementation GADMasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



+(GADMasterViewController *)singleton {
    static dispatch_once_t pred;
    static GADMasterViewController *shared;
    // Will only be run once, the first time this is called
    dispatch_once(&pred, ^{
        shared = [[GADMasterViewController alloc] init];
    });
    return shared;
}

-(id)init {
    if (self = [super init]) {
        adBanner_ = [[GADBannerView alloc]
                     initWithFrame:CGRectMake(0.0,
                                              0.0,
                                              GAD_SIZE_320x50.width,
                                              GAD_SIZE_320x50.height)];
        isLoaded_ = NO;
    }
    return self;
}

-(void)resetAdView:(UIViewController *)rootViewController AndDisplayView:(UIView *)displayView {
    // Always keep track of currentDelegate for notification forwarding
    if(currentDelegate_)
        currentDelegate_ = nil;
    currentDelegate_ = rootViewController;
    
    // Ad already requested, simply add it into the view
    if (isLoaded_) {
        for(UIView *temp in [displayView subviews]) {
            [temp removeFromSuperview];
        }
        if(adBanner_.rootViewController == nil) {
            adBanner_.rootViewController = rootViewController;
        }
        [displayView addSubview:adBanner_];
    } else {
        
        adBanner_.delegate = self;
        adBanner_.rootViewController = rootViewController;
        //adBanner_.adUnitID = @"ca-app-pub-7753603434154239/4797926502";
        adBanner_.adUnitID = kGoogleBannerAdId;
        
        GADRequest *request = [GADRequest request];
        [adBanner_ loadRequest:request];
        [rootViewController.view addSubview:adBanner_];
        isLoaded_ = YES;
    }
}

- (void)adViewDidReceiveAd:(GADBannerView *)view {
    if ([currentDelegate_ respondsToSelector:@selector(adViewDidReceiveAd:)]) {
        [currentDelegate_ adViewDidReceiveAd:view];
        
        CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
        animation.fromValue = @(0);
        animation.toValue = @(2 * M_PI);
        animation.repeatCount = 1;//INFINITY;
        animation.duration = 0.5;
        [view.layer addAnimation:animation forKey:@"rotation"];
    }
}

/*
 /// Tells the delegate an ad request loaded an ad.
 - (void)adViewDidReceiveAd:(GADBannerView *)adView {
 //void SendDelegateMessage(NSInvocation *): delegate (webView:didFinishLoadForFrame:)
 adView.alpha = 0;
 [UIView animateWithDuration:1.0 animations:^{
 adView.alpha = 1;
 }];
 }
 */

/// Tells the delegate an ad request failed.
- (void)adView:(GADBannerView *)adView didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"adView:didFailToReceiveAdWithError: %@", [error localizedDescription]);
}

/// Tells the delegate that a full screen view will be presented in response
/// to the user clicking on an ad.
- (void)adViewWillPresentScreen:(GADBannerView *)adView {
    NSLog(@"adViewWillPresentScreen");
}

/// Tells the delegate that the full screen view will be dismissed.
- (void)adViewWillDismissScreen:(GADBannerView *)adView {
    NSLog(@"adViewWillDismissScreen");
}

/// Tells the delegate that the full screen view has been dismissed.
- (void)adViewDidDismissScreen:(GADBannerView *)adView {
    NSLog(@"adViewDidDismissScreen");
}

/// Tells the delegate that a user click will open another app (such as
/// the App Store), backgrounding the current app.
- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
    NSLog(@"adViewWillLeaveApplication");
}

@end
