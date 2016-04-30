//
//  BugsplatStartupManager.m
//  BugsplatMac
//
//  Created by Geoff Raeder on 2/8/16.
//  Copyright © 2016 Bugsplat. All rights reserved.
//

#import "BugsplatStartupManager.h"
#import <HockeySDK/HockeySDK.h>

NSString *const kBugsplatServerURL = @"https://bugsplatsoftware.com/";
NSString *const kHockeyIdentifierPlaceholder = @"b0cf675cb9334a3e96eda0764f95e38e";  // Just to satisfy Hockey since this is required

@implementation BugsplatStartupManager

+ (instancetype)sharedManager
{
    static BugsplatStartupManager *sharedInstance = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        sharedInstance = [BugsplatStartupManager alloc];
        sharedInstance = [sharedInstance init];
    });
    
    return sharedInstance;
}

- (void)start
{
    NSString *serverURL = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"BugsplatServerURL"] ?: kBugsplatServerURL;
    [[BITHockeyManager sharedHockeyManager] setServerURL:serverURL];
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:kHockeyIdentifierPlaceholder];
    [[BITHockeyManager sharedHockeyManager] startManager];
}

@end
