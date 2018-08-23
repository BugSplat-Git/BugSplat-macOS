//
//  BugsplatStartupManagerDelegate.h
//  BugsplatMac
//
//  Created by Geoff Raeder on 3/26/17.
//  Copyright © 2017 Bugsplat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BugsplatAttachment;

@protocol BugsplatStartupManagerDelegate <NSObject>

@optional

/** Return any log string based data the crash report being processed should contain
 *
 * @param bugsplatStartupManager The `BugsplatStartupManager` instance invoking this delegate
 */
- (NSString *)applicationLogForBugsplatStartupManager:(BugsplatStartupManager *)bugsplatStartupManager;

/** Return any string based data the crash report being processed should contain
 *
 * @param bugsplatStartupManager The `BugsplatStartupManager` instance invoking this delegate
 * @param signal The system crash signal
 * @param exceptionName The exception name.  Only provided if crash is the result of an uncaught exception
 * @param exceptionReason The exception reason.  Only provided if crash is the result of an uncaught exception
 */
- (NSString *)applicationKeyForBugsplatStartupManager:(BugsplatStartupManager *)bugsplatStartupManager signal:(NSString *)signal exceptionName:(NSString *)exceptionName exceptionReason:(NSString *)exceptionReason;

/**
 * Invoked before the user is asked to send a crash report, so you can do additional actions.
 *
 * @param bugsplatStartupManager The `BugsplatStartupManager` instance invoking this delegate
 */
- (void)bugsplatStartupManagerWillShowSubmitCrashReportAlert:(BugsplatStartupManager *)bugsplatStartupManager;

/**
 * Invoked after the user did choose _NOT_ to send a crash in the alert
 *
 * @param bugsplatStartupManager The `BugsplatStartupManager` instance invoking this delegate
 */
- (void)bugsplatStartupManagerWillCancelSendingCrashReport:(BugsplatStartupManager *)bugsplatStartupManager;

/**
 * Invoked right before sending crash reports will start
 *
 * @param bugsplatStartupManager The `BugsplatStartupManager` instance invoking this delegate
 */
- (void)bugsplatStartupManagerWillSendCrashReport:(BugsplatStartupManager *)bugsplatStartupManager;

/**
 * Invoked after sending crash reports succeeded
 *
 * @param bugsplatStartupManager The `BugsplatStartupManager` instance invoking this delegate
 */
- (void)bugsplatStartupManagerDidFinishSendingCrashReport:(BugsplatStartupManager *)bugsplatStartupManager;

/**
 * Invoked after sending crash reports failed
 *
 * @param bugsplatStartupManager The `BugsplatStartupManager` instance invoking this delegate
 * @param error The error returned.
 */
- (void)bugsplatStartupManager:(BugsplatStartupManager *)bugsplatStartupManager didFailWithError:(nullable NSError *)error;

/** Return a BugsplatAttachment object providing an NSData object the crash report
 being processed should contain
  
 Example implementation:
 
 - (BugsplatAttachment *)attachmentForCrashManager:(BugsplatStartupManager *)bugsplatStartupManager {
    NSData *data = [NSData dataWithContentsOfURL:@"mydatafile"];
 
    BugsplatAttachment *attachment = [[BugsplatAttachment alloc] initWithFilename:@"myfile.data"
                                                                   attachmentData:data
                                                                      contentType:@"application/octet-stream"];
    return attachment;
 }
 
 @param bugsplatStartupManager The `BugsplatStartupManager` instance invoking this delegate
*/
- (BugsplatAttachment *)attachmentForBugsplatStartupManager:(BugsplatStartupManager *)bugsplatStartupManager;

@end

NS_ASSUME_NONNULL_END
