//
//  SongInfo.m
//  RingToneManager
//
//  Created by Narender Kumar on 6/13/16.
//  Copyright (c) 2016 Pawan Kumar. All rights reserved.
//

#import "SongInfo.h"

@implementation SongInfo

-(id)init {
    
    if (self = [super init]) {
        self.title = @"not able";
        self.displayName = @"not able";
       // self.artist = @"not able";
       // self.album = @"not able";
        self.songUrl = @"not able";
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.displayName forKey:@"displayName"];
    [coder encodeObject:self.songUrl forKey:@"songUrl"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    if (self != nil)
    {
        self.title = [coder decodeObjectForKey:@"title"];
        self.displayName = [coder decodeObjectForKey:@"displayName"];
        self.songUrl = [coder decodeObjectForKey:@"songUrl"];
    }
    return self;
}

@end
