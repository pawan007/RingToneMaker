//
//  ViewController.m
//  RingToneManager
//
//  Created by Pawan Kumar on 02/06/16.
//  Copyright © 2016 Pawan Kumar. All rights reserved.
//

//https://itunes.apple.com/us/app/smartringtonemaker/id1161425556?ls=1&mt=8

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "BJRangeSliderWithProgress.h"
#import "FDWaveformView.h"
#import "Constant.h"
#import "SongInfo.h"
#import "IQAudioCropperViewController.h"
#import "IQ_FDWaveformView.h"
#import "NSString+IQTimeIntervalFormatter.h"
#import "IQCropSelectionBeginView.h"
#import "IQCropSelectionEndView.h"
#import "Utility.h"
#import "RecorderVC.h"
#import "GADMasterViewController.h"

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@interface ViewController ()<MPMediaPickerControllerDelegate, IQ_FDWaveformViewDelegate>
{
    NSURL *musichFilePath;
    BOOL _isPlaying;
    UIView *middleContainerView;
    IQ_FDWaveformView *waveformView;
    IQCropSelectionView *leftCropView;
    IQCropSelectionView *rightCropView;
    NSString *strSongTitle;
    GADMasterViewController *adViewSharedInstance;
    GADInterstitial *interstitial;
    //Changes by Rishi
}
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (weak, nonatomic) IBOutlet UILabel *selectedFilePath;
@property (weak, nonatomic) IBOutlet UILabel *infoView;
@property (weak, nonatomic) IBOutlet FDWaveformView *waveView;
@property(nonatomic,strong)NSMutableArray *FilesList;
@property (strong) NSURL *flippedAudioUrl;
@property (weak, nonatomic) IBOutlet UIButton *btnMusic;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIButton *btnBigTone;
@property (weak, nonatomic) IBOutlet UILabel *lblSelectMusic;
@property (weak, nonatomic) IBOutlet UILabel *lblStartTime;
@property (weak, nonatomic) IBOutlet UILabel *lblEndTime;
@property (weak, nonatomic) IBOutlet UILabel *lblSongName;

@property (weak, nonatomic) IBOutlet GADBannerView *adView;


@end

int maxValue=5;
int minValue=10;
BOOL isMaxValueChanged = false;
double distance = 0.2;


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureAudioSession];
    self.FilesList=[Utility GetAllFiles];
    CGRect frame = CGRectMake(0, 50, self.view.frame.size.width, 200);
    frame = CGRectInset(frame, 0, 0);
    if(middleContainerView)
        [middleContainerView removeFromSuperview];
    
    middleContainerView = [[UIView alloc] initWithFrame:frame];
    middleContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    _adView.backgroundColor = [UIColor clearColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveFullAdsNotification:)
                                                 name:kFullAdShowNotification
                                               object:nil];
    if(interstitial != nil) {
        interstitial = nil;
    }
    interstitial = [[GADInterstitial alloc] initWithAdUnitID:kGoogleInterstitialAd];
    //GADRequest *request = [[GADRequest alloc]init];
    //[interstitial loadRequest:request];
    adViewSharedInstance    = [GADMasterViewController singleton];
    [adViewSharedInstance resetAdView:self AndDisplayView:_adView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    if(_audioPlayer)
    {
        [self.btnPlay setImage:[UIImage imageNamed:@"PlayIconBig"] forState:UIControlStateNormal];
        [_audioPlayer stop];
    }
    self.FilesList=[Utility GetAllFiles];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFullAdShowNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) receiveFullAdsNotification:(NSNotification *) notification {
    if(interstitial.isReady) {
        [interstitial presentFromRootViewController:self];
    }
}

- (IBAction)searchMedia:(id)sender
{
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Choose your option"
                                          message:@""
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *mediaAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"Music Library", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   MPMediaPickerController *picker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
                                   [picker setDelegate:self];
                                   [picker setAllowsPickingMultipleItems: NO];
                                   [self presentViewController:picker animated:YES completion:NULL];
                               }];
    
    [alertController addAction:mediaAction];
    
    UIAlertAction *Recording = [UIAlertAction
                                  actionWithTitle:NSLocalizedString(@"Record Tone in your own voice", @"ownVoiceAction")
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction *action)
                                  {
                                      UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                      RecorderVC *vc = [sb instantiateViewControllerWithIdentifier:@"RecorderVC"];
                                      //vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                                      [self presentViewController:vc animated:YES completion:nil];
                                  }];
    
    [alertController addAction:Recording];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action) {
                                                         }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
   }


- (IBAction)makeRingTone:(id)sender
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Name Your Ringtone"
                                          message:@""
                                          preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = NSLocalizedString(@"Enter Name", musichFilePath.RingToneFileName);
         textField.text = strSongTitle;

     }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   UITextField *txtRingtone = alertController.textFields.firstObject;
                                   if(txtRingtone.text.length<=0)
                                   {
                                       [self presentViewController:alertController animated:YES completion:nil];
                                       return ;
                                   }
                                   [self saveRingtone:txtRingtone.text];
                               }];
    [alertController addAction:okAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action) {
                                                         }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Google BannerAd Custom delegate
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"Ad change in ViewController Class");
    for(UIView *tempView in _adView.subviews) {
        [tempView removeFromSuperview];
    }
    [_adView addSubview:adView];
}

-(void)saveRingtone:(NSString*)RingToneFileName
{
    // Path of your destination save audio file
    SongInfo *song = [SongInfo new];
    song.title = RingToneFileName;
    RingToneFileName=[RingToneFileName stringByAppendingFormat:@"%lu",(unsigned long)self.FilesList.count];
    RingToneFileName=[RingToneFileName stringByAppendingPathExtension:kToneExtention];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *libraryCachesDirectory = [paths objectAtIndex:0];
    NSDateFormatter *formatter;
    NSString        *dateString;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"ddMMyyyyHHmmss"];
    dateString = [formatter stringFromDate:[NSDate date]];
    
    NSString *requiredOutputPath = [libraryCachesDirectory stringByAppendingPathComponent:RingToneFileName];
   // requiredOutputPath=[ requiredOutputPath stringByAppendingPathExtension:kToneExtention];

    __block   NSURL *audioFileOutput = [NSURL fileURLWithPath:requiredOutputPath];
   // [[NSFileManager defaultManager] removeItemAtURL:audioFileOutput error:NULL];
    AVAsset *asset = [AVAsset assetWithURL:musichFilePath];
    AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:asset
                                                                            presetName:AVAssetExportPresetAppleM4A];
//    float startTrimTime = mySlider.leftValue;
//    float endTrimTime = mySlider.rightValue;
    
    float startTrimTime = leftCropView.cropTime;
    float endTrimTime = leftCropView.cropTime+20;
    
    CMTime startTime = CMTimeMake((int)(floor(startTrimTime * 100)), 100);
    CMTime stopTime = CMTimeMake((int)(ceil(endTrimTime * 100)), 100);
    CMTimeRange exportTimeRange = CMTimeRangeFromTimeToTime(startTime, stopTime);
    exportSession.outputURL = audioFileOutput;
    exportSession.outputFileType = AVFileTypeAppleM4A;
    exportSession.timeRange = exportTimeRange;
    [exportSession exportAsynchronouslyWithCompletionHandler:^
     {
         if (AVAssetExportSessionStatusCompleted == exportSession.status)
         {
             NSLog(@"Success!");
             NSLog(@" OUtput path is \n %@", requiredOutputPath);
            // musichFilePath=audioFileOutput;
             song.displayName = audioFileOutput.path;
             song.songUrl = requiredOutputPath;
             [self.FilesList addObject:song];
             [self SaveAllFilesArray];
            // [exportSession finalize];
         }
         else if (AVAssetExportSessionStatusFailed == exportSession.status)
         {
             NSLog(@"failed with error: %@", exportSession.error.localizedDescription);
         }
     }];
    
}


- (IBAction)btnGetallCall:(id)sender
{
    NSString *strFiles=[NSString stringWithFormat:@"%@",[self GetAllFiles]];
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Your Ringtone List"
                                          message:strFiles
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   
                               }];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}
-(void)SaveAllFilesArray
{
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.FilesList];
//    [[NSUserDefaults standardUserDefaults]setObject:data forKey:kKey];
//    [[NSUserDefaults standardUserDefaults]synchronize];
    [Utility SaveAllFilesArray:self.FilesList];
}

-(NSArray*)GetAllFiles
{
    self.FilesList=[[NSUserDefaults standardUserDefaults]objectForKey:kKey];
    return self.FilesList;
}
- (IBAction)playmusic:(UIButton*)sender
{
    if(_audioPlayer.isPlaying)
    {
        [_audioPlayer stop];
       
        [sender setImage:[UIImage imageNamed:@"PlayIconBig"] forState:UIControlStateNormal];

        //[sender setTitle:@"Play" forState:UIControlStateNormal];
    }
    
    else
    {
        _audioPlayer.currentTime=leftCropView.cropTime;
        [sender setImage:[UIImage imageNamed:@"PauseIconBig"] forState:UIControlStateNormal];
        [_audioPlayer play];
    }

}


#pragma mark - Media Picker Delegate

/*
 * This method is called when the user chooses something from the media picker screen. It dismisses the media picker screen
 * and plays the selected song.
 */
- (void)mediaPicker:(MPMediaPickerController *) mediaPicker didPickMediaItems:(MPMediaItemCollection *) collection {
    
    // remove the media picker screen
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    // grab the first selection (media picker is capable of returning more than one selected item,
    // but this app only deals with one song at a time)
    MPMediaItem *item = [[collection items] objectAtIndex:0];
    NSString *title = [item valueForProperty:MPMediaItemPropertyTitle];
    strSongTitle=title;
    self.lblSongName.text=title;
    // get a URL reference to the selected item
    NSURL *url = [item valueForProperty:MPMediaItemPropertyAssetURL];
    musichFilePath=url;
   // [self.maskView setHidden:false];
    
   // [self saveRingtone:url.path];
    [self designWaveView];

}

/*
 * This method is called when the user cancels out of the media picker. It just dismisses the media picker screen.
 */
- (void)mediaPickerDidCancel:(MPMediaPickerController *) mediaPicker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)configureAudioSession {
    NSError *error;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    
    if (error) {
        NSLog(@"Error setting category: %@", [error description]);
    }
}

- (IBAction)btnReverseTap:(id)sender {
    //[self stopRecording];
}


-(void) designWaveView
{
    
   // NSURL *audioURL = [[NSBundle mainBundle] URLForResource:@"la" withExtension:@"mp3"];
    {
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musichFilePath error:nil];
        //_audioPlayer.delegate = self;
        _audioPlayer.meteringEnabled = YES;
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(stopAndSaveRecording) withObject:self afterDelay:40];

    }
    
    
    CGRect frame = CGRectMake(0, 74, self.view.frame.size.width, 200);
    frame = CGRectInset(frame, 0, 0);
    if(middleContainerView)
       [middleContainerView removeFromSuperview];
    
    middleContainerView = [[UIView alloc] initWithFrame:frame];
    middleContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
   // middleContainerView.center = self.view.center;
    [self.view addSubview:middleContainerView];
    {
        waveformView = [[IQ_FDWaveformView alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(middleContainerView.frame), 160)];
        waveformView.delegate = self;
        waveformView.center = CGPointMake(CGRectGetMidX(middleContainerView.bounds), CGRectGetMidY(middleContainerView.bounds));
        waveformView.audioURL = musichFilePath;
        waveformView.wavesColor = [UIColor greenColor];
        waveformView.progressColor =  [UIColor blueColor];
        waveformView.cropColor = [UIColor blueColor];
        waveformView.doesAllowScroll = NO;
        waveformView.doesAllowScrubbing = YES;
        waveformView.doesAllowStretch = NO;
        waveformView.backgroundColor=[UIColor blackColor];
        waveformView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [middleContainerView addSubview:waveformView];
       // [self.maskView setHidden:true];
    }
    
    {
        CGFloat margin = 30;
        
        leftCropView = [[IQCropSelectionBeginView alloc] initWithFrame:CGRectMake(CGRectGetMinX(waveformView.frame)-22, CGRectGetMinY(waveformView.frame)-margin, 45, CGRectGetHeight(waveformView.frame)+margin*2)];
        leftCropView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        rightCropView = [[IQCropSelectionEndView alloc] initWithFrame:CGRectMake(55, CGRectGetMinY(waveformView.frame)-margin, 45, CGRectGetHeight(waveformView.frame)+margin*2)];
        rightCropView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        leftCropView.cropTime = 0;
        
       // rightCropView.cropTime = _audioPlayer.duration;
        rightCropView.cropTime = 55;
        [middleContainerView addSubview:leftCropView];
        [middleContainerView addSubview:rightCropView];
        NSString *time=[NSString timeStringForTimeInterval:rightCropView.cropTime];
        NSString *str=[NSString stringWithFormat:@"%@>" ,time];
        self.lblEndTime.text=str;
        UIPanGestureRecognizer *leftCropPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(leftCropPanRecognizer:)];
        UIPanGestureRecognizer *rightCropPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rightCropPanRecognizer:)];
        [leftCropView addGestureRecognizer:leftCropPanRecognizer];
        [rightCropView addGestureRecognizer:rightCropPanRecognizer];
    }
}



-(void)leftCropPanRecognizer:(UIPanGestureRecognizer*)panRecognizer
{
    static CGPoint beginPoint;
    static CGPoint beginCenter;
    
    if (panRecognizer.state == UIGestureRecognizerStateBegan)
    {
        beginPoint = [panRecognizer translationInView:middleContainerView];
        beginCenter = leftCropView.center;
    }
    else if (panRecognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint newPoint = [panRecognizer translationInView:middleContainerView];
        //Left Margin
        CGFloat pointX = MAX(CGRectGetMinX(waveformView.frame), beginCenter.x+(newPoint.x-beginPoint.x));
        //Right Margin from right cropper
        pointX = MIN(CGRectGetMinX(rightCropView.frame), pointX);
        
        leftCropView.center = CGPointMake(pointX, beginCenter.y);
        {
            leftCropView.cropTime = (leftCropView.center.x/waveformView.frame.size.width)*_audioPlayer.duration;
            _audioPlayer.currentTime = leftCropView.cropTime;
            waveformView.progressSamples = waveformView.totalSamples*(_audioPlayer.currentTime/_audioPlayer.duration);
            waveformView.cropStartSamples = waveformView.totalSamples*(leftCropView.cropTime/_audioPlayer.duration);
            
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            [self performSelector:@selector(stopAndSaveRecording) withObject:self afterDelay:30  ];
        }
        
        NSString *time=[NSString timeStringForTimeInterval:leftCropView.cropTime];
        NSString *str=[NSString stringWithFormat:@"<%@" ,time];
        self.lblStartTime.text=str;
        
        if(rightCropView.cropTime-leftCropView.cropTime>55)
        {
            CGFloat pointX = MAX(CGRectGetMaxX(waveformView.frame), beginCenter.x+(newPoint.x-beginPoint.x));
            //Left Margin from left cropper
            pointX = MIN(CGRectGetMaxX(leftCropView.frame), pointX);
            rightCropView.center = CGPointMake(pointX+55, beginCenter.y);
            //leftCropView.center = CGPointMake(pointX, beginCenter.y);
            {
               rightCropView.cropTime = (rightCropView.center.x/waveformView.frame.size.width)*_audioPlayer.duration;
               waveformView.cropEndSamples = waveformView.totalSamples*(rightCropView.cropTime/_audioPlayer.duration);
                NSString *time=[NSString timeStringForTimeInterval:rightCropView.cropTime];
                NSString *str=[NSString stringWithFormat:@"%@>" ,time];
                self.lblEndTime.text=str;
            }
        }

    }
    else if (panRecognizer.state == UIGestureRecognizerStateEnded|| panRecognizer.state == UIGestureRecognizerStateFailed)
    {
        beginPoint = CGPointZero;
        beginCenter = CGPointZero;
        
        if (leftCropView.cropTime == 0 && rightCropView.cropTime == _audioPlayer.duration)
        {
            //_cropButton.enabled = NO;
        }
        else
        {
            //_cropButton.enabled = YES;
        }
    }
}
-(void)rightCropPanRecognizer:(UIPanGestureRecognizer*)panRecognizer
{
    static CGPoint beginPoint;
    static CGPoint beginCenter;

    if (panRecognizer.state == UIGestureRecognizerStateBegan)
    {
        beginPoint = [panRecognizer translationInView:middleContainerView];
        beginCenter = rightCropView.center;
    }

    else if (panRecognizer.state == UIGestureRecognizerStateChanged)
    {

        CGPoint newPoint = [panRecognizer translationInView:middleContainerView];
        //Right Margin
        CGFloat pointX = MIN(CGRectGetMaxX(waveformView.frame), beginCenter.x+(newPoint.x-beginPoint.x));
        //Left Margin from left cropper
        pointX = MAX(CGRectGetMaxX(leftCropView.frame), pointX);
        //NSLog(@"%fx=====",pointX);
        NSLog(@"%fx=====",pointX);
        rightCropView.center = CGPointMake(pointX, beginCenter.y);
        //leftCropView.center = CGPointMake(pointX, beginCenter.y);
        {
            rightCropView.cropTime = (rightCropView.center.x/waveformView.frame.size.width)*_audioPlayer.duration;
            waveformView.cropEndSamples = waveformView.totalSamples*(rightCropView.cropTime/_audioPlayer.duration);
        }
        NSString *time=[NSString timeStringForTimeInterval:rightCropView.cropTime];
        NSString *str=[NSString stringWithFormat:@"%@>" ,time];
        self.lblEndTime.text=str;
        if(rightCropView.cropTime-leftCropView.cropTime>55)
        {
            CGFloat pointX = MAX(CGRectGetMinX(waveformView.frame), beginCenter.x+(newPoint.x-beginPoint.x));
            //Right Margin from right cropper
            pointX = MIN(CGRectGetMinX(rightCropView.frame), pointX);
            leftCropView.center = CGPointMake(pointX-55, beginCenter.y);
            leftCropView.cropTime = (leftCropView.center.x/waveformView.frame.size.width)*_audioPlayer.duration;
            _audioPlayer.currentTime = leftCropView.cropTime;
            waveformView.progressSamples = waveformView.totalSamples*(_audioPlayer.currentTime/_audioPlayer.duration);
            waveformView.cropStartSamples = waveformView.totalSamples*(leftCropView.cropTime/_audioPlayer.duration);
            NSString *time=[NSString timeStringForTimeInterval:leftCropView.cropTime];
            NSString *str=[NSString stringWithFormat:@"<%@" ,time];
            self.lblStartTime.text=str;
            
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            [self performSelector:@selector(stopAndSaveRecording) withObject:self afterDelay:40];

        }
    }
    else if (panRecognizer.state == UIGestureRecognizerStateEnded|| panRecognizer.state == UIGestureRecognizerStateFailed)
    {
        beginPoint = CGPointZero;
        beginCenter = CGPointZero;
        
        if (leftCropView.cropTime == 0 && rightCropView.cropTime == _audioPlayer.duration)
        {
            //_cropButton.enabled = NO;
        }
        else
        {
            //_cropButton.enabled = YES;
        }
    }
}


- (void)stopAndSaveRecording
{
  if(_audioPlayer)
  {
     [_audioPlayer stop];
      [self.btnPlay setImage:[UIImage imageNamed:@"PlayIconBig"] forState:UIControlStateNormal];
  }
}

- (void)waveformViewDidRender:(IQ_FDWaveformView *)waveformViews;
{
     [self.maskView setHidden:true];
    self.btnPlay.hidden=false;
    self.btnSave.hidden=false;
    self.btnMusic.hidden=false;
    self.btnBigTone.hidden=true;
    self.lblSelectMusic.hidden=true;
    //waveformView.cropEndSamples = waveformView.totalSamples*(rightCropView.cropTime/_audioPlayer.duration);
}


@end
