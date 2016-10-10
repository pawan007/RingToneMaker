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

@interface TonesVC ()<UITableViewDelegate, UITableViewDataSource, SongCellDelegate> {
    __weak IBOutlet UITableView *_tableView;
    int _currentPlaySongIndx;
    AVAudioPlayer *player;
}
@property(nonatomic,strong)NSMutableArray *songFilesList;
@end

@implementation TonesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _currentPlaySongIndx = -1;
   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) viewWillAppear:(BOOL)animated
{
   // [self GetAllFiles];
    self.songFilesList=[Utility GetAllFiles];
    [_tableView reloadData];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self SaveAllFilesArray];
    if(player)
    {
        [player stop];
         player = nil;
        
        for( SongInfo *song in self.songFilesList)
        {  song.isPlaying=false; }
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

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    //SongCell * cell = (SongCell* )[_tableView cellForRowAtIndexPath:indexPath];
//}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        SongInfo *song= [self.songFilesList objectAtIndex:indexPath.row];
        [self.songFilesList removeObjectAtIndex:indexPath.row];
        [tableView reloadData]; // tell table to refresh now
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtURL:[NSURL fileURLWithPath:song.songUrl] error:NULL];
        if(![[NSFileManager defaultManager] removeItemAtURL:[NSURL fileURLWithPath:song.songUrl] error:&error])
            NSLog(@"Error: %@", [error localizedDescription]);
       // [self SaveAllFilesArray];
        [Utility SaveAllFilesArray:self.songFilesList];
    }
}

// get play song
- (void)didPlay:(SongInfo *)song
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_currentPlaySongIndx inSection:0];
   // SongCell *cell = (SongCell* )[_tableView cellForRowAtIndexPath:indexPath];
   // [cell setData:song atIndx:(int)indexPath.row];
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
   // NSData * data = [NSData dataWithContentsOfFile: url.path];
    NSError *error;
    //player =  [[AVAudioPlayer alloc] initWithData: data error: & error];
     player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if (error)
    {
        NSLog(@"Error in audioPlayer: %@",[error localizedDescription]);
    }
    player.numberOfLoops = -1;
    [player setVolume:1.0];
    [player play];
}


- (void)didSelectInfo:(SongInfo *)song
{
   // NSData *pdfData = [NSData dataWithContentsOfFile:song.songUrl];
    NSURL *url = [NSURL fileURLWithPath:song.songUrl];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]
                                                        initWithActivityItems:@[@"Ringtone", url] applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
    //NSLog(@"selected Display Name : %@",song.displayName);
}

//-(void)GetAllFiles
//{
//    NSData *storedData = [[NSUserDefaults standardUserDefaults] objectForKey:kKey];
//    self.songFilesList = [[NSArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:storedData]]mutableCopy];
//    self.lblNoFileStatus.hidden=true;
//}

-(void)SaveAllFilesArray
{
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arrSongList];
//    [[NSUserDefaults standardUserDefaults]setObject:data forKey:kKey];
//    [[NSUserDefaults standardUserDefaults]synchronize];
    [Utility SaveAllFilesArray:self.songFilesList];
}



@end
