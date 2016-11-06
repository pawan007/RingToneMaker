//
//  TonesVC.m
//  RingToneManager
//
//  Created by Narender Kumar on 6/11/16.
//  Copyright (c) 2016 Pawan Kumar. All rights reserved.
//

#import "TonesVC.h"
#import "SongInfo.h"
#import "SongCell.h"
#import <AVFoundation/AVFoundation.h>
#import "Constant.h"
#import "Utility.h"
#import "GADMasterViewController.h"

@interface TonesVC ()<UITableViewDelegate, UITableViewDataSource, SongCellDelegate, GADInterstitialDelegate> {
    __weak IBOutlet UITableView *_tableView;
    int _currentPlaySongIndx;
    AVAudioPlayer *player;
    GADMasterViewController *adViewSharedInstance;
}
@property(nonatomic,strong)NSMutableArray *songFilesList;
@property (weak, nonatomic) IBOutlet GADBannerView *adView;
@property(nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation TonesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentPlaySongIndx = -1;
    _adView.backgroundColor = [UIColor clearColor];
    
    if(self.interstitial != nil) {
        self.interstitial = nil;
    }
    self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:kGoogleInterstitialAd];
    self.interstitial.delegate = self;
    GADRequest *request = [[GADRequest alloc]init];
    [self.interstitial loadRequest:request];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) viewWillAppear:(BOOL)animated
{
    self.songFilesList=[Utility GetAllFiles];
    [_tableView reloadData];
    if(self.songFilesList.count>0)
    {
        self.btnNoFileStatus.hidden=true;
        _tableView.hidden=false;
    }
    else
    {
        self.btnNoFileStatus.hidden=false;
        _tableView.hidden=true;
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveFullAdsNotification:)
                                                 name:kFullAdShowNotification
                                               object:nil];
    adViewSharedInstance    = [GADMasterViewController singleton];
    [adViewSharedInstance resetAdView:self AndDisplayView:_adView];
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self performSelector:(@selector(showFullAds)) withObject:nil afterDelay:0.2];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFullAdShowNotification object:nil];
    
    [self SaveAllFilesArray];
    if(player)
    {
        [player stop];
        player = nil;
        
        for( SongInfo *song in self.songFilesList)
        {
            song.isPlaying=false;
        }
        [_tableView reloadData ];
    }
}

- (void) receiveFullAdsNotification:(NSNotification *) notification {
    // [self showFullAds];
}

#pragma mark - Display Full Page Google Ads
- (void)showFullAds {
    if([[NSUserDefaults standardUserDefaults] objectForKey:kFullUserDefault] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:kFullUserDefault];
    }
    else {
        NSInteger adCounter = [[[NSUserDefaults standardUserDefaults] objectForKey:kFullUserDefault] intValue];
        adCounter += 1;
        NSLog(@"Full ad counter = %d",adCounter);
        if(adCounter >= FULL_AD_COUNTER) {
            adCounter = 0;
            if(self.interstitial.isReady) {
                [self.interstitial presentFromRootViewController:self];
            }
        }
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:adCounter] forKey:kFullUserDefault];
        
    }
}

#pragma mark - UITableViewDelegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.songFilesList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ident = @"SongCell";
    SongCell *cell = (SongCell *)[_tableView dequeueReusableCellWithIdentifier:ident];
    if (cell == nil) cell = [SongCell cell];
    cell.delegate = self;
    SongInfo *song = [self.songFilesList objectAtIndex:indexPath.row];
    [cell setData:song atIndx:(int)indexPath.row];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        if(player)
            [player stop];
        SongInfo *song= [self.songFilesList objectAtIndex:indexPath.row];
        [self.songFilesList removeObjectAtIndex:indexPath.row];
        [tableView reloadData]; // tell table to refresh now
        NSError *error;
        //[[NSFileManager defaultManager] removeItemAtURL:[NSURL fileURLWithPath:song.songUrl] error:NULL];
        if(![[NSFileManager defaultManager] removeItemAtURL:[NSURL fileURLWithPath:song.songUrl] error:&error])
            NSLog(@"Error: %@", [error localizedDescription]);
        [Utility SaveAllFilesArray:self.songFilesList];
        
    }
}

// get play song
- (void)didPlay:(SongInfo *)song
{
    if(song.isPlaying==true)
    {
        song.isPlaying=false;
        if(player)
        {
            [player stop];
            player = nil;
        }
    }
    else
    {
        for( SongInfo *song in self.songFilesList)
        {  song.isPlaying=false; }
        song.isPlaying=true;
        [self playTone:song];
    }
    [_tableView reloadData ];
}

-(void)playTone:(SongInfo*)song
{
    if(player)
    {
        [player stop];
        player = nil;
    }
    NSURL *url = [NSURL fileURLWithPath:song.songUrl];
    NSError *error;
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if (error)
    {
        NSLog(@"Error in audioPlayer: %@",[error localizedDescription]);
    }
    player.numberOfLoops = -1;
    [player setVolume:1.0];
    [player play];
}

#pragma mark - Google BannerAd Custom delegate
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"Ad change in TonesVC Class");
    for(UIView *tempView in _adView.subviews) {
        [tempView removeFromSuperview];
    }
    [_adView addSubview:adView];
    adView.center = CGPointMake(CGRectGetMidX(_adView.frame), adView.center.y);
}


- (void)didSelectInfo:(SongInfo *)song
{
    NSURL *url = [NSURL fileURLWithPath:song.songUrl];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]
                                                        initWithActivityItems:@[@"Ringtone", url] applicationActivities:nil];
    //if iPhone
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self presentViewController:activityViewController animated:YES completion:nil];
    }
    //if iPad
    else {
        // Change Rect to position Popover
        UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
        [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    
    
    //NSLog(@"selected Display Name : %@",song.displayName);
}

-(void)SaveAllFilesArray
{
    [Utility SaveAllFilesArray:self.songFilesList];
}
- (IBAction)btnNoFilesClick:(id)sender {
    [self.tabBarController setSelectedIndex:0];
    
}



@end
