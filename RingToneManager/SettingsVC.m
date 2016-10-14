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

@interface SettingsVC ()

@end

@implementation SettingsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
        if(indexPath.row==1)
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
    }
    
    if(indexPath.row==2)
    {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:
                                                @"itms-apps://yourAppLinkHere"]];
    }
    // Then implement the delegate method
  
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error

{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end
