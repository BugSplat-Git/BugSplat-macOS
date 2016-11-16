//
//  BugsplatStartupManager.m
//  BugsplatMac
//
//  Created by Geoff Raeder on 2/8/16.
//  Copyright © 2016 Bugsplat. All rights reserved.
//

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
    NSString *serverURL = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"BugsplatServerURL"];
    
    NSAssert(serverURL != nil, @"No value provided for BugsplatServerURL.  Please add this key/value to the main bundle's Info.plist");
    
    [[BITHockeyManager sharedHockeyManager] setServerURL:serverURL];
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:kHockeyIdentifierPlaceholder];
    [[BITHockeyManager sharedHockeyManager] startManager];
}

- (BITHockeyManager *)hockeyManager
{
    return [BITHockeyManager sharedHockeyManager];
}

@end
