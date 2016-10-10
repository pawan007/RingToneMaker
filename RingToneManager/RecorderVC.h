//
//  RecorderVC.h
//  RingToneManager
//
//  Created by Rishi Kumar on 15/09/16.
//  Copyright © 2016 Pawan Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

typedef enum
{
    eRecordableState= 0,
    eRecordingState,
    ePlayableState,
    ePlayingState,
}ePlayerStatusType;

@interface RecorderVC : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
    bool isStart;
    
}

@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIImageView *textImageView;
@property (weak, nonatomic) IBOutlet UIView *maskView;

-(IBAction)record:(id)sender;

@end
