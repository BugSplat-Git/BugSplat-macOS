#import <Foundation/Foundation.h>

@class BITHockeyAttachment;

/**
 * The `BITCrashManagerDelegate` formal protocol defines methods further configuring
 * the behaviour of `BITCrashManager`.
 */
@protocol BITCrashManagerDelegate <NSObject>

@optional

/**
 * Not used any longer!
 *
 * In previous SDK versions this invoked once the user interface asking for crash details and if the data should be send is dismissed
 *
 * @param crashManager The `BITCrashManager` instance invoking the method
 * @deprecated The default crash report UI is not shown modal any longer, so this delegate is not being used any more!
 */
- (void) showMainApplicationWindowForCrashManager:(BITCrashManager *)crashManager __attribute__((deprecated("The default crash report UI is not shown modal any longer, so this delegate is now called right away. We recommend to remove the implementation of this method.")));

///-----------------------------------------------------------------------------
/// @name Additional meta data
///-----------------------------------------------------------------------------

/** Return any log string based data the crash report being processed should contain
 *
 * @param crashManager The `BITCrashManager` instance invoking this delegate
 */
-(NSString *)applicationLogForCrashManager:(BITCrashManager *)crashManager;

/** Return any string based data the crash report being processed should contain
 *
 * @param crashManager The `BITCrashManager` instance invoking this delegate
 * @param signal The signal that caused the crash
 * @param exceptionName The exception name that caused the crash, if the crash was caused by an uncaught exception.
 * @param exceptionReason The exception reason that caused the crash, if the crash was caused by an uncaught exception.
 */
-(NSString *)applicationKeyForCrashManager:(BITCrashManager *)crashManager signal:(NSString *)signal exceptionName:(NSString *)exceptionName exceptionReason:(NSString *)exceptionReason;

/** Return a collection of BITHockeyAttachment objects providing an NSData object the crash report
 being processed should contain
 
 @param crashManager The `BITCrashManager` instance invoking this delegate
 @see applicationLogForCrashManager:
 */
-(NSArray<BITHockeyAttachment*> *)attachmentsForCrashManager:(BITCrashManager *)crashManager;

///-----------------------------------------------------------------------------
/// @name Alert
///-----------------------------------------------------------------------------

/**
 * Invoked before the user is asked to send a crash report, so you can do additional actions.
 *
 * E.g. to make sure not to ask the user for an app rating :)
 *
 * @param crashManager The `BITCrashManager` instance invoking this delegate
 */
-(void)crashManagerWillShowSubmitCrashReportAlert:(BITCrashManager *)crashManager;


/**
 * Invoked after the user did choose _NOT_ to send a crash in the alert
 *
 * @param crashManager The `BITCrashManager` instance invoking this delegate
 */
-(void)crashManagerWillCancelSendingCrashReport:(BITCrashManager *)crashManager;


///-----------------------------------------------------------------------------
/// @name Networking
///-----------------------------------------------------------------------------

/**
 * Invoked right before sending crash reports will start
 *
 * @param crashManager The `BITCrashManager` instance invoking this delegate
 */
- (void)crashManagerWillSendCrashReport:(BITCrashManager *)crashManager;

/**
 * Invoked after sending crash reports failed
 *
 * @param crashManager The `BITCrashManager` instance invoking this delegate
 * @param error The error returned from the NSURLSessionDataTask call or `kBITCrashErrorDomain`
 * with reason of type `BITCrashErrorReason`.
 */
- (void)crashManager:(BITCrashManager *)crashManager didFailWithError:(NSError *)error;

/**
 * Invoked after sending crash reports succeeded
 *
 * @param crashManager The `BITCrashManager` instance invoking this delegate
 */
- (void)crashManagerDidFinishSendingCrashReport:(BITCrashManager *)crashManager;

@end
