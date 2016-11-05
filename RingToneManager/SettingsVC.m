//
//  SettingsVC.m
//  RingToneManager
//
//  Created by Rishi Kumar on 17/09/16.
//  Copyright © 2016 Pawan Kumar. All rights reserved.
//

#import "SettingsVC.h"
#import "SettingVC.h"
#import "iRate/iRate.h"
#import "GADMasterViewController.h"
#import "Constant.h"

@interface SettingsVC () {
    GADMasterViewController *adViewSharedInstance;
    GADInterstitial *interstitial;
}

@property (weak, nonatomic) IBOutlet GADBannerView *adView;

@end

@implementation SettingsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveFullAdsNotification:)
                                                 name:kFullAdShowNotification
                                               object:nil];
    //if(interstitial != nil) {
     //   interstitial = nil;
    //}
    //interstitial = [[GADInterstitial alloc] initWithAdUnitID:kGoogleInterstitialAd];
    //GADRequest *request = [[GADRequest alloc]init];
    //[interstitial loadRequest:request];
    adViewSharedInstance    = [GADMasterViewController singleton];
    [adViewSharedInstance resetAdView:self AndDisplayView:_adView];
    CGRect frm = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-100, self.view.frame.size.width, 50);
    _adView.frame = frm;
    [self.navigationController.view addSubview:_adView];
}
- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFullAdShowNotification object:nil];
    [_adView removeFromSuperview];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGRect frm = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-100, self.view.frame.size.width, 50);
    _adView.frame = frm;
    [self.navigationController.view setNeedsLayout];
    [self.navigationController.view layoutIfNeeded];
    
    // Now modify bottomView's frame here
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) receiveFullAdsNotification:(NSNotification *) notification {
    if(interstitial.isReady) {
        [interstitial presentFromRootViewController:self];
    }
}

#pragma mark - Google BannerAd Custom delegate
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"Ad change in Setting Class");
    for(UIView *tempView in _adView.subviews) {
        [tempView removeFromSuperview];
    }
    [_adView addSubview:adView];
}



#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(indexPath.row==0)
        {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SettingVC *vc = [sb instantiateViewControllerWithIdentifier:@"SettingVC"];
            vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self.navigationController pushViewController:vc animated:true];
        }
        
        if(indexPath.row==1)
        {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SettingVC *vc = [sb instantiateViewControllerWithIdentifier:@"AboutCompany"];
            vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self.navigationController pushViewController:vc animated:true];
        }
    }
    else if(indexPath.section == 1)
    {
        if(indexPath.row==0)
        {
            [[iRate sharedInstance] openRatingsPageInAppStore];
        }
        
        if(indexPath.row==2)
        {
            if ([MFMailComposeViewController canSendMail])
            {
                MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
                mail.mailComposeDelegate = self;
                [mail setSubject:@"RingTone FeedBack to Admin"];
                [mail setToRecipients:@[@"admin@mobirizer.com"]];
                [self presentViewController:mail animated:YES completion:NULL];
            }
            else
            {
                NSLog(@"This device cannot send email");
            }
            
        }
        
        if(indexPath.row==1)
        {
            if ([MFMailComposeViewController canSendMail])
            {
                MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
                mail.mailComposeDelegate = self;
                [mail setSubject:@"Amazing Ringtone Maker App check this out on AppStore."];
                //[mail setToRecipients:@[@"admin@mobirizer.com"]];
                [mail setMessageBody:@"https://itunes.apple.com/us/app/smartringtonemaker/id1161425556?ls=1&mt=8" isHTML:true];
                [self presentViewController:mail animated:YES completion:NULL];
            }
            else
            {
                NSLog(@"This device cannot send email");
            }
            
        }
    }
    
    if(indexPath.row==3)
    {
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/developer/mobirizer/id1141913793"]];
    }
    // Then implement the delegate method
  
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error

{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end
