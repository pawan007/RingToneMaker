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

@interface TonesVC ()<UITableViewDelegate, UITableViewDataSource, SongCellDelegate> {
    __weak IBOutlet UITableView *_tableView;
    int _currentPlaySongIndx;
    AVAudioPlayer *player;
    GADMasterViewController *adViewSharedInstance;

}
@property(nonatomic,strong)NSMutableArray *songFilesList;
@property (weak, nonatomic) IBOutlet UIView *adView;


@end

@implementation TonesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentPlaySongIndx = -1;
    _adView.backgroundColor = [UIColor clearColor];
    adViewSharedInstance    = [GADMasterViewController singleton];
    [adViewSharedInstance resetAdView:self AndDisplayView:_adView];
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
}
-(void)viewWillDisappear:(BOOL)animated
{
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
    for(UIView *tempView in _adView.subviews) {
        [tempView removeFromSuperview];
    }
    [_adView addSubview:adView];
}


- (void)didSelectInfo:(SongInfo *)song
{
    NSURL *url = [NSURL fileURLWithPath:song.songUrl];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]
                                                        initWithActivityItems:@[@"Ringtone", url] applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
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
