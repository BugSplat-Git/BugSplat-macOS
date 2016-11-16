//
//  BugsplatStartupManager.h
//  BugsplatMac
//
//  Created by Geoff Raeder on 2/8/16.
//  Copyright © 2016 Bugsplat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HockeySDK/HockeySDK.h>

@interface BugsplatStartupManager : NSObject

/*!
 *  BugsplatStartupManager singleton initializer/accessor
 *
 *  @return shared instance of BugsplatStartupManager
 */
+ (instancetype)sharedManager;

/*!
 *  Configures and starts crash reporting service
 */
- (void)start;

/*!
 *  Returns reference to backing Hockey instance
 */

@property (readonly, nonatomic) BITHockeyManager *hockeyManager;

@end
