//
//  FDWaveformView.h
//  FDWaveformView
//
//  Created by Andrea Mazzini on 07/04/16.
//  Copyright © 2016 William Entriken. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for FDWaveformView.
FOUNDATION_EXPORT double FDWaveformViewVersionNumber;

//! Project version string for FDWaveformView.
FOUNDATION_EXPORT const unsigned char FDWaveformViewVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <FDWaveformView/PublicHeader.h>
 //#import <FDWaveformView/FDWaveformView.h>


#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@protocol FDWaveformViewDelegate;

@interface FDWaveformView : UIView
@property (nonatomic, weak) id<FDWaveformViewDelegate> delegate;
@property (nonatomic, strong) NSURL *audioURL;
@property (nonatomic, assign, readonly) long int totalSamples;
@property (nonatomic, assign) long int progressSamples;
@property (nonatomic, assign) long int zoomStartSamples;
@property (nonatomic, assign) long int zoomEndSamples;
@property (nonatomic) BOOL doesAllowScrubbing;
@property (nonatomic) BOOL doesAllowStretch;
@property (nonatomic) BOOL doesAllowScroll;
@property (nonatomic, copy) UIColor *wavesColor;
@property (nonatomic, copy) UIColor *progressColor;
@end

@protocol FDWaveformViewDelegate <NSObject>
@optional
- (void)waveformViewWillRender:(FDWaveformView *)waveformView;
- (void)waveformViewDidRender:(FDWaveformView *)waveformView;
- (void)waveformViewWillLoad:(FDWaveformView *)waveformView;
- (void)waveformViewDidLoad:(FDWaveformView *)waveformView;
- (void)waveformDidBeginPanning:(FDWaveformView *)waveformView;
- (void)waveformDidEndPanning:(FDWaveformView *)waveformView;
@end
