//
//  SongCell.m
//  RingToneManager
//
//  Created by Narender Kumar on 6/13/16.
//  Copyright (c) 2016 Pawan Kumar. All rights reserved.
//

#import "SongCell.h"
#import "PCSEQVisualizer.h"
#import <AVFoundation/AVFoundation.h>

@interface SongCell () {
    int _index;
    SongInfo *_song;
    PCSEQVisualizer* eq;
    AVAudioPlayer *player;
    bool isPlaying;
}
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UILabel *lblDisplayName;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblArtist;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIView *barVisualizer;
@end


@implementation SongCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (SongCell *)cell {
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"SongCell" owner:self options:nil];
    SongCell *cell = (SongCell *) [nibs firstObject];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void) setData:(SongInfo *)song atIndx:(int)idx {
    _index = idx;
    _song = song;
    self.lblDisplayName.text = song.title;
    self.lblTitle.text = song.displayName;
   // self.lblArtist.text = song.artist;
    [self.playBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    
    if(eq)
    {
        [eq removeFromSuperview];
        eq = nil;
    }
    eq = [[PCSEQVisualizer alloc]initWithNumberOfBars:5 andView:_barVisualizer];
    eq.barColor = [UIColor redColor];
    [_barVisualizer addSubview:eq];
    //isPlaying=false;
    //eq.hidden = NO;
    UIImage * img = [UIImage imageNamed:@"stop"];
    if(song.isPlaying==false)
    {
        img = [UIImage imageNamed:@"play"];
        song.isPlaying=false;
        //[eq start];
        eq.hidden = YES;
    }
    else
    {
        img = [UIImage imageNamed:@"stop"];
        song.isPlaying=true;
        [eq start];

        eq.hidden = NO;
    }
    [self.playBtn setImage:img forState:UIControlStateNormal];

}

- (IBAction)playAction:(id)sender {

    if (_delegate && [_delegate respondsToSelector:@selector(didPlay:)])
        [_delegate didPlay:_song];
}
- (IBAction)shareAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectInfo:)])
        [_delegate didSelectInfo:_song];
}

@end
