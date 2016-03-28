//
//  BugsplatStartupManager.h
//  BugsplatMac
//
//  Created by Geoff Raeder on 2/8/16.
//  Copyright © 2016 Bugsplat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BugsplatStartupManager : NSObject

/*!
 *  BugsplatStartupManager singleton initializer/accessor
 *
 *  @return shared instance of BugsplatStartupManager
 */
+ (instancetype)sharedManager;

/*!
 *  Configures and starts crash reporting service
 *
 *  @param appIdentifier Bugsplat application identifier
 */
- (void)startupWithAppIdentifier:(NSString *)appIdentifier;

@end
