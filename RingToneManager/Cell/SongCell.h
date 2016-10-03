//
//  SongCell.h
//  RingToneManager
//
//  Created by Narender Kumar on 6/13/16.
//  Copyright (c) 2016 Pawan Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SongInfo.h"

@protocol SongCellDelegate <NSObject>
@optional
- (void)didSelectIdx:(int)indx;
- (void)didSelectInfo:(SongInfo *)song;
- (void)didPlay:(SongInfo *)song;

@end

// nikku kumari
// 30 date till 11 baje...

@interface SongCell : UITableViewCell

@property (nonatomic, assign) id <SongCellDelegate> delegate;

+ (SongCell *)cell;
- (void) setData:(SongInfo *)song atIndx:(int)idx;

@end
