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

- (void)startupWithAppIdentifier:(NSString *)appIdentifier
{
    NSString *serverURL = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"BugsplatServerURL"] ?: kBugsplatServerURL;
    [[BITHockeyManager sharedHockeyManager] setServerURL:serverURL];
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:appIdentifier];
    [[BITHockeyManager sharedHockeyManager] startManager];
}

@end
