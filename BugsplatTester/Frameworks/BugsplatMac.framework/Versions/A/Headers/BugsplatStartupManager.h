//
//  BugsplatStartupManager.h
//  BugsplatMac
//
//  Created by Geoff Raeder on 2/8/16.
//  Copyright © 2016 Bugsplat. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BugsplatStartupManagerDelegate;

@interface BugsplatStartupManager : NSObject

/*!
 *  BugsplatStartupManager singleton initializer/accessor
 *
 *  @return shared instance of BugsplatStartupManager
 */
+ (nonnull instancetype)sharedManager;

/*!
 *  Configures and starts crash reporting service
 */
- (void)start;

/*!
 *  Bundle containing BugsplatMac.framework.  Default is main bundle.
 */
@property (nonatomic, strong, nullable) NSBundle *hostBundle;

/*!
 *  Provide custom banner image for crash reporter.
 *  Can set directly in code or provide an image named bugsplat-logo in main bundle. Can be in asset catalog.
 */
@property (nonatomic, strong, nullable) NSImage *bannerImage;

/*!
 *  Submit crash reports without asking the user
 *
 *  _YES_: The crash report will be submitted without asking the user
 *  _NO_: The user will be asked if the crash report can be submitted (default)
 *
 *  Default: _NO_
 */
@property (nonatomic, assign, getter=isAutoSubmitCrashReport) BOOL autoSubmitCrashReport;

/**
 *  Defines if the crash report UI should ask for name and email
 *
 *  Default: _YES_
 */
@property (nonatomic, assign) BOOL askUserDetails;

/**
 *  Defines if user's name and email entered in the crash report UI should be saved to the keychain.
 *
 *  Default: _NO_
 */
@property (nonatomic, assign) BOOL persistUserDetails;

/**
 *  Defines if crash reports should be considered "expired" after a certain amount of time (in seconds).
 *  If expired crash dialogue is not displayed but reports are still uploaded.
 *
 *  Default: -1 // No expiration
 */
@property (nonatomic, assign) NSTimeInterval expirationTimeInterval;

/**
 *  Represents user's full name
 */
@property (nonatomic, copy, nullable) NSString *userName;

/**
 *  Represents user's email address
 */
@property (nonatomic, copy, nullable) NSString *userEmail;

/**
 * Option to present crash reporter dialogue modally
 *
 * *Default*:  NO
 */
@property (nonatomic, assign) BOOL presentModally;

/**
 * Set the delegate
 *
 * Defines the class that implements the optional protocol `BugsplatStartupManagerDelegate`.
 *
 * @see BugsplatStartupManagerDelegate
 */
@property (weak, nonatomic, nullable) id<BugsplatStartupManagerDelegate> delegate;

@end
