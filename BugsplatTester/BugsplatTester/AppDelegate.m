//
//  AppDelegate.m
//  BugsplatTester
//
//  Created by Geoff Raeder on 8/17/15.
//  Copyright (c) 2015 BugSplat. All rights reserved.
//

#import "AppDelegate.h"

@import BugsplatMac;

@interface AppDelegate () <BugsplatStartupManagerDelegate>

@property (weak) IBOutlet NSWindow *window;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [BugsplatStartupManager sharedManager].delegate = self;
    [BugsplatStartupManager sharedManager].autoSubmitCrashReport = YES;
    [BugsplatStartupManager sharedManager].userName = @"Geoff Raeder";
    [BugsplatStartupManager sharedManager].userEmail = @"geoff@bugsplat.com";
    [[BugsplatStartupManager sharedManager] start];
}

- (void)performCrash
{
    void (^nilBlock)(void) = nil;
    nilBlock();
}

- (IBAction)crash:(id)sender
{
    [self performCrash];
}

#pragma mark - BugsplatStartupManagerDelegate

- (NSString *)applicationLogForBugsplatStartupManager:(BugsplatStartupManager *)bugsplatStartupManager
{
    return NSStringFromSelector(_cmd);
}

- (void)bugsplatStartupManagerWillShowSubmitCrashReportAlert:(BugsplatStartupManager *)bugsplatStartupManager
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)bugsplatStartupManagerWillCancelSendingCrashReport:(BugsplatStartupManager *)bugsplatStartupManager
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)bugsplatStartupManagerWillSendCrashReport:(BugsplatStartupManager *)bugsplatStartupManager
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)bugsplatStartupManagerDidFinishSendingCrashReport:(BugsplatStartupManager *)bugsplatStartupManager
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)bugsplatStartupManager:(BugsplatStartupManager *)bugsplatStartupManager didFailWithError:(NSError *)error
{
    NSLog(@"%@, %@", NSStringFromSelector(_cmd), error);
}

- (BugsplatAttachment *)attachmentForBugsplatStartupManager:(BugsplatStartupManager *)bugsplatStartupManager {
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"generated" withExtension:@"json"];
    NSData *data = [NSData dataWithContentsOfURL:fileURL];
    
    BugsplatAttachment *attachment = [[BugsplatAttachment alloc] initWithFilename:@"generated.json"
                                                                   attachmentData:data
                                                                      contentType:@"application/json"];
    return attachment;
}

- (NSString *)applicationKeyForBugsplatStartupManager:(BugsplatStartupManager *)bugsplatStartupManager exceptionReason:(NSString *)exceptionReason
{
    return [NSString stringWithFormat:@"Application key: %@", exceptionReason];
}

@end
