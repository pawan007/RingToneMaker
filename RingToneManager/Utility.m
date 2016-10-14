//
//  Utility.m
//  RingToneManager
//
//  Created by Rishi Kumar on 18/09/16.
//  Copyright © 2016 Pawan Kumar. All rights reserved.
//

#import "Utility.h"
#import "Constant.h"

@implementation Utility

+(void)SaveAllFilesArray :(NSMutableArray*)FilesList
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:FilesList];
    [[NSUserDefaults standardUserDefaults]setObject:data forKey:kKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(NSMutableArray*)GetAllFiles
{
    NSData *storedData = [[NSUserDefaults standardUserDefaults] objectForKey:kKey];
    NSMutableArray *arrSongList = [[NSArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:storedData]]mutableCopy];
    if(arrSongList!=nil)
    {
        return arrSongList;
    }
    else
    {
        return [NSMutableArray new];
    }
}
@end
