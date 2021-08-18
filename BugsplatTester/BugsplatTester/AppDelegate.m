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

- (instancetype)init
{
    self = [super init];
    return self;
}

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification
{

}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[BugsplatStartupManager sharedManager] setDelegate:self];
    [[BugsplatStartupManager sharedManager] setPersistUserDetails:YES];
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

- (NSArray<BugsplatAttachment *> *)attachmentsForBugsplatStartupManager:(BugsplatStartupManager *)bugsplatStartupManager
{
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"generated" withExtension:@"json"];
    NSData *data = [NSData dataWithContentsOfURL:fileURL];
    
    NSMutableArray *attachments = [[NSMutableArray alloc] init];
    
    for (NSUInteger i = 0; i < 4; i++)
    {
        BugsplatAttachment *attachment = [[BugsplatAttachment alloc] initWithFilename:[NSString stringWithFormat:@"generated%@.json", @(i)]
                                                                       attachmentData:data
                                                                          contentType:@"application/json"];
        
        [attachments addObject:attachment];
    }
    
    
    return attachments;
}

- (NSString *)applicationKeyForBugsplatStartupManager:(BugsplatStartupManager *)bugsplatStartupManager signal:(NSString *)signal exceptionName:(NSString *)exceptionName exceptionReason:(NSString *)exceptionReason;
{
    return [NSString stringWithFormat:@"Application key: %@, %@, %@", signal, exceptionName, exceptionReason];
}

@end
