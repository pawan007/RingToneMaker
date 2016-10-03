//
//  SongInfo.h
//  RingToneManager
//
//  Created by Narender Kumar on 6/13/16.
//  Copyright (c) 2016 Pawan Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SongInfo : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *displayName;
//@property (nonatomic, strong) NSString *artist;
//@property (nonatomic, strong) NSString *album;
@property (nonatomic, strong) NSString *songUrl;
@property(assign)BOOL isPlaying;


@end
