//
//  BugsplatStartupManager.m
//  BugsplatMac
//
//  Created by Geoff Raeder on 2/8/16.
//  Copyright © 2016 Bugsplat. All rights reserved.
//

#import <HockeySDK/HockeySDK.h>
#import "BugsplatStartupManager.h"

NSString *const kHockeyIdentifierPlaceholder = @"b0cf675cb9334a3e96eda0764f95e38e";  // Just to satisfy Hockey since this is required

@implementation BugsplatStartupManager

+ (instancetype)sharedManager
{
    static BugsplatStartupManager *sharedInstance = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[BugsplatStartupManager alloc] init];
    });
    
    return sharedInstance;
}

- (void)start
{
    NSString *serverURL = [self.hostBundle objectForInfoDictionaryKey:@"BugsplatServerURL"];
    
    NSAssert(serverURL != nil, @"No server url provided.  Please add this key/value to the your bundle's Info.plist");
    
    [[BITHockeyManager sharedHockeyManager] setServerURL:serverURL];
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:kHockeyIdentifierPlaceholder];
    [[BITHockeyManager sharedHockeyManager].crashManager setAutoSubmitCrashReport:self.autoSubmitCrashReport];
    [[BITHockeyManager sharedHockeyManager] startManager];
}

- (NSBundle *)hostBundle
{
    if (!_hostBundle)
    {
        _hostBundle = [NSBundle mainBundle];
    }
    
    return _hostBundle;
}

@end
