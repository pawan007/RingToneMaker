//
//  KBViewController.m
//  iReversePlay
//
//  Created by Kiran on 2/2/13.
//  Copyright (c) 2013 Kiran. All rights reserved.
//

#import "RecorderVC.h"
#import "Utility.h"
#import "SongInfo.h"
#import "Constant.h"
#import "MBCircularProgressBarView.h"
int MAX_VALUE=20;
@interface RecorderVC ()

- (void)prepareToRecord;
- (void)startRecording;
- (void)stopRecording;
- (BOOL)startAudioSession;
- (void)startPlaying;
- (void)stopPlaying;
- (void)startPulseEffectOnButton;
- (void)stopPulseEffectOnButton;

@property (strong) AVAudioSession *session;
@property (strong) AVAudioRecorder *recorder;
@property (strong) AVAudioPlayer *player;
@property (strong) NSURL *recordedAudioUrl;
@property (strong) NSURL *flippedAudioUrl;
@property (assign) ePlayerStatusType currentState;
@property (strong, nonatomic) IBOutlet MBCircularProgressBarView *progressBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnDone;
@property (strong) NSMutableArray *savedFilesArray;
@end

#pragma mark -

@implementation RecorderVC

@synthesize session;
@synthesize recorder;
@synthesize player;
@synthesize recordedAudioUrl;
@synthesize flippedAudioUrl;
@synthesize currentState;

#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.currentState = eRecordableState;
    if ([self startAudioSession])
    {
        [self prepareToRecord];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    if(!self.savedFilesArray)
    self.savedFilesArray=[Utility GetAllFiles];
}

#pragma mark -
#pragma mark Action methods
#pragma mark -

- (IBAction)btnStartStopClick:(id)sender
{
}

- (IBAction)btnCancelClick:(id)sender
{
    if(self.recorder)
       [self.recorder stop];
    if(self.player)
        [self.player stop];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnDoneClick:(id)sender
{
    if(self.recorder)
        [self.recorder stop];
   // [self stopAndSaveRecording];
    [self dismissViewControllerAnimated:YES completion:nil];
   // [self performSelectorInBackground:@selector(stopAndSaveRecording) withObject:nil];

}

- (void)stopAndSaveRecording
{
    //TODO
    if(self.recorder)
        [self.recorder stop];
    self.currentState = ePlayableState;
    [self.maskView setHidden:NO];
    [self performSelectorInBackground:@selector(stopRecording) withObject:nil];
    [self.recordButton setImage:[UIImage imageNamed:@"bt_Play.png"] forState:UIControlStateNormal];
    [self stopPulseEffectOnButton];
    //[self saveClick:nil];
    
}


-(IBAction)record:(id)sender
{
    
    //[self performSelectorInBackground:@selector(stopAndSaveRecording) withObject:nil];
   
    switch (self.currentState)
    {
        case eRecordableState:
        {
//            self.currentState = eRecordingState;
            [self startRecording];
//            [sender setImage:[UIImage imageNamed:@"bt_Stop.png"] forState:UIControlStateNormal];
//            [self startPulseEffectOnButton];
            
            
            
        }
        break;
            
        case eRecordingState:
        {
//            self.currentState = ePlayableState;
//            [self.maskView setHidden:NO];
//            [self performSelectorInBackground:@selector(stopRecording) withObject:nil];
      //      [sender setImage:[UIImage imageNamed:@"bt_Play.png"] forState:UIControlStateNormal];
//            [self stopPulseEffectOnButton];
        }
        break;
            
      
            break;
            
        case ePlayableState:
        {
            self.currentState = ePlayingState;
            [self startPlaying];
            self.textImageView.image = [UIImage imageNamed:@"txt_Playback.png"];
            [sender setImage:[UIImage imageNamed:@"bt_Stop.png"] forState:UIControlStateNormal];
            [self startPulseEffectOnButton];
        }
        break;
            
        case ePlayingState:
        {
            self.currentState = ePlayableState;
            [self stopPlaying];
            [sender setImage:[UIImage imageNamed:@"bt_Play.png"] forState:UIControlStateNormal];
            self.textImageView.image = [UIImage imageNamed:@"txt_ReadMe.png"];
            [self stopPulseEffectOnButton];
        }
        break;
            
        default:
            break;
    }
}


#pragma mark -
#pragma mark AVAudioPlayerDelegate methods
#pragma mark -

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"audioPlayerDidFinishPlaying");
    [self.recordButton setImage:[UIImage imageNamed:@"bt_Play.png"] forState:UIControlStateNormal];
   // self.textImageView.image = [UIImage imageNamed:@"txt_ReadMe.png"];
   // self.currentState = eRecordableState;
    [self stopPulseEffectOnButton];
    NSError *error;
   // if(![[NSFileManager defaultManager] removeItemAtURL:self.flippedAudioUrl error:&error])
      //  NSLog(@"Error: %@", [error localizedDescription]);
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    NSLog(@"audioRecorderDidFinishRecording");
    NSLog(@"File saved to %@", [[self.recordedAudioUrl path] lastPathComponent]);
}

#pragma mark -
#pragma mark Private methods
#pragma mark -

- (void) stopRecording
{
    [self.recorder stop];
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [self.maskView setHidden:YES];
        self.maskView.hidden=true;
    });
}

- (void)startRecording
{
    [self prepareToRecord];
    }

-(void)prepareToRecord
{
 
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted)
     {
         if (granted) {
             NSLog(@"Permission granted");
         }
         else {
             NSLog(@"Permission denied");
             UIAlertController *alertControllerp = [UIAlertController
                                                    alertControllerWithTitle:@"Please allow Microphone access from settings"
                                                    message:@""
                                                    preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction *settingsAction = [UIAlertAction
                                              actionWithTitle:NSLocalizedString(@"Settings", @"Settings")
                                              style:UIAlertActionStyleDefault
                                              
                                              handler:^(UIAlertAction *action)
                                              {
                                                  [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:UIApplicationOpenSettingsURLString]];

                                              }
                                              ];
             
             [alertControllerp addAction:settingsAction];
             UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                                    style:UIAlertActionStyleCancel
                                                                  handler:^(UIAlertAction *action) {
                                                                  }];
             [alertControllerp addAction:cancelAction];
             [self presentViewController:alertControllerp animated:YES completion:nil];
             
             return;
         }
     }];

    
    
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Name Your Recording"
                                          message:@""
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         //textField.placeholder = NSLocalizedString(@"Enter Name", musichFilePath.path);
         textField.text = [NSString stringWithFormat:@"Recording %lu", (unsigned long)self.savedFilesArray.count];
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
                                   
                                   
                                   
                                   self.currentState = eRecordingState;
                                   [self startPulseEffectOnButton];

                                   if (!isStart)
                                   {
                                       [self performSelector:@selector(stopAndSaveRecording) withObject:self afterDelay:MAX_VALUE];
                                      // self.progressBar.unitString =@" Sec";
                                       [self.progressBar setMaxValue:MAX_VALUE];
                                       //        [self.btnStartStop setTitle:@"Stop" forState:UIControlStateNormal];
                                       self.progressBar.countdown = true;
                                       [self.progressBar setValue:MAX_VALUE
                                              animateWithDuration:MAX_VALUE];
                                   }
                                   isStart=!isStart;

                                                                      NSError *error;
                                   
                                   NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                                                             [NSNumber numberWithInt:kAudioFormatMPEG4AAC], AVFormatIDKey,
                                                             [NSNumber numberWithInt:AVAudioQualityMedium], AVEncoderAudioQualityKey,
                                                             [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                                                             [NSNumber numberWithFloat:8000.0], AVSampleRateKey,
                                                             nil];
                                   // File URL
                                   NSString *recordPath= [DOCUMENTS_FOLDER stringByAppendingPathComponent:txtRingtone.text];
                                   NSDateFormatter *formatter;
                                   NSString        *dateString;
                                   formatter = [[NSDateFormatter alloc] init];
                                   [formatter setDateFormat:@"mmss"];
                                   dateString = [formatter stringFromDate:[NSDate date]];
                                   recordPath= [recordPath stringByAppendingString:dateString];
                                   recordPath=[ recordPath stringByAppendingPathExtension:@"m4r"];
                                  
                                   self.recordedAudioUrl = [[NSURL alloc ] initFileURLWithPath:recordPath];
                                   NSString *flippedPath= [DOCUMENTS_FOLDER stringByAppendingPathComponent:@"result"];
                                   //flippedPath= [flippedPath stringByAppendingPathExtension:@".m4a"];
                                   self.flippedAudioUrl = [[NSURL alloc ] initFileURLWithPath:flippedPath];
                                   // Create recorder
                                   self.recorder = [[AVAudioRecorder alloc] initWithURL:self.recordedAudioUrl settings:settings error:&error];
                                   if (!self.recorder)
                                   {
                                       NSLog(@"Error: %@", [error localizedDescription]);
                                   }
                                   
                                   // Initialize degate, metering, etc.
                                   self.recorder.delegate = self;
                                   if (![self.recorder prepareToRecord])
                                   {
                                       NSLog(@"Error: Prepare to record failed");
                                   }
                                   
                                   SongInfo *song = [SongInfo new];
                                   song.title = txtRingtone.text;
                                   song.displayName = txtRingtone.text;
                                   song.songUrl = self.recordedAudioUrl.path;
                                   [self.savedFilesArray addObject:song];
                                   [Utility SaveAllFilesArray:self.savedFilesArray];
                                   
                                   if (![self.recorder record])
                                   {
                                       NSLog(@"Error: Record failed");
                                   }

                               }];
    
    [alertController addAction:okAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action) {
                                                         }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
   }


-(void)startPlaying
{
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recordedAudioUrl error:nil];
    player.delegate = self;

       // [self.progressBar setMaxValue:0];
       //  self.progressBar.countdown = true;
      //  [self.progressBar setValue:MAX_VALUE animateWithDuration:MAX_VALUE];

    if(![self.player play])
    {
        NSLog(@"Error: Play failed");
    }
}




-(void)stopPlaying
{
    [self.player stop];
}


- (BOOL) startAudioSession
{
    NSLog(@"startAudioSession");
    // Prepare the audio session
    NSError *error;
    self.session = [AVAudioSession sharedInstance];
    
    if (![self.session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error])
    {
        NSLog(@"Error: %@", [error localizedDescription]);
        return NO;
    }
    
    if (![self.session setActive:YES error:&error])
    {
        NSLog(@"Error: %@", [error localizedDescription]);
        return NO;
    }
    UInt32 ASRoute = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty ( kAudioSessionProperty_OverrideAudioRoute,
                             sizeof (ASRoute),
                             &ASRoute
                             );
    return self.session.inputAvailable;//make sure ;)
}


-(void)startPulseEffectOnButton
{
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    theAnimation.duration=0.8;
    theAnimation.repeatCount=HUGE_VALF;
    theAnimation.autoreverses=YES;
    theAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
    theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
    theAnimation.toValue=[NSNumber numberWithFloat:0.3];
    [self.recordButton.layer addAnimation:theAnimation forKey:@"animateOpacity"];
}
- (IBAction)saveClick:(id)sender
{
    if(self.recorder)
        [self.recorder stop];
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Name Your audio"
                                          message:@""
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         //textField.placeholder = NSLocalizedString(@"Enter Name", musichFilePath.path);
         textField.text = [NSString stringWithFormat:@"Audio %lu", (unsigned long)self.savedFilesArray.count];
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
                                   SongInfo *song = [SongInfo new];
                                   song.title = txtRingtone.text;
                                   song.displayName = txtRingtone.text;
                                   song.songUrl = self.recordedAudioUrl.path;
                                   [self.savedFilesArray addObject:song];
                                   [Utility SaveAllFilesArray:self.savedFilesArray];
                               }];
    
    [alertController addAction:okAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action) {
                                                         }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


-(void)stopPulseEffectOnButton
{
    [self.recordButton.layer removeAnimationForKey:  @"animateOpacity"];
}



@end
