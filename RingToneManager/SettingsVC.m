//
//  SettingsVC.m
//  RingToneManager
//
//  Created by Rishi Kumar on 17/09/16.
//  Copyright © 2016 Pawan Kumar. All rights reserved.
//

#import "SettingsVC.h"
#import "SettingVC.h"

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

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(indexPath.row==0)
        {
//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Are you sure delete all ringtones?" preferredStyle:UIAlertControllerStyleAlert];
//            
//            [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
//            
//            [alertController addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//                
////                if (![[NSFileManager defaultManager] removeItemAtURL:self.recordedAudioUrl error:&error])
////                    NSLog(@"Error: %@", [error localizedDescription]);
//
//            }]];
//            
//            [self presentViewController:alertController animated:YES completion:nil];
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SettingVC *vc = [sb instantiateViewControllerWithIdentifier:@"SettingVC"];
            vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self.navigationController pushViewController:vc animated:true];

        }
    }
    else if(indexPath.section == 1)
    {
        if(indexPath.row==1)
        {
            NSURL *url=[NSURL new];
            UIActivityViewController *activityViewController = [[UIActivityViewController alloc]
                                                                initWithActivityItems:@[@"Ringtone", url] applicationActivities:nil];
            [self presentViewController:activityViewController animated:YES completion:nil];

        }
    }
    
    
    else if(indexPath.section == 1)
    {
        if(indexPath.row==3)
        {
            NSURL *url=[NSURL new];
            UIActivityViewController *activityViewController = [[UIActivityViewController alloc]
                                                                initWithActivityItems:@[@"Ringtone", url] applicationActivities:nil];
            [self presentViewController:activityViewController animated:YES completion:nil];
            
        }
    }
    
   }


@end
