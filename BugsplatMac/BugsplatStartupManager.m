//
//  BugsplatStartupManager.m
//  BugsplatMac
//
//  Created by Geoff Raeder on 2/8/16.
//  Copyright © 2016 Bugsplat. All rights reserved.
//

#import <HockeySDK/HockeySDK.h>
#import "BugsplatStartupManager.h"
#import "BugsplatStartupManagerDelegate.h"
#import "BugsplatAttachment.h"


NSString *const kHockeyIdentifierPlaceholder = @"b0cf675cb9334a3e96eda0764f95e38e";  // Just to satisfy Hockey since this is required

@interface BugsplatStartupManager() <BITHockeyManagerDelegate>

@end

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

- (instancetype)init
{
	if (self = [super init])
	{
		_autoSubmitCrashReport = NO;
		_askUserDetails = YES;
        
        [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:kHockeyIdentifierPlaceholder];
        
        NSImage *bannerImage = [NSImage imageNamed:@"bugsplat-logo"];
        
        if (bannerImage)
        {
            self.bannerImage = bannerImage;
        }
	}
    
	return self;
}

- (void)start
{
    NSLog(@"Initializing Bugsplat");
    NSString *serverURL = [self.hostBundle objectForInfoDictionaryKey:@"BugsplatServerURL"];
    
    NSAssert(serverURL != nil, @"No server url provided.  Please add this key/value to the your bundle's Info.plist");
    
    [[BITHockeyManager sharedHockeyManager] setServerURL:serverURL];
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

- (void)setBannerImage:(NSImage *)bannerImage
{
    _bannerImage = bannerImage;
    [[BITHockeyManager sharedHockeyManager].crashManager setBannerImage:self.bannerImage];
}

- (void)setAskUserDetails:(BOOL)askUserDetails
{
    _askUserDetails = askUserDetails;
    [[BITHockeyManager sharedHockeyManager].crashManager setAskUserDetails:self.askUserDetails];
}

- (void)setAutoSubmitCrashReport:(BOOL)autoSubmitCrashReport
{
    _autoSubmitCrashReport = autoSubmitCrashReport;
    [[BITHockeyManager sharedHockeyManager].crashManager setAutoSubmitCrashReport:self.autoSubmitCrashReport];
}

- (void)setDelegate:(id<BugsplatStartupManagerDelegate>)delegate
{
    if (_delegate != delegate)
    {
        _delegate = delegate;
    }
    
    [BITHockeyManager sharedHockeyManager].delegate = self;
}

#pragma mark - BITHockeyManagerDelegate

- (NSString *)applicationLogForCrashManager:(BITCrashManager *)crashManager
{
    if ([_delegate respondsToSelector:@selector(applicationLogForBugsplatStartupManager:)])
    {
        return [_delegate applicationLogForBugsplatStartupManager:self];
    }
    
    return nil;
}

- (BITHockeyAttachment *)attachmentForCrashManager:(BITCrashManager *)crashManager;
{
    if ([_delegate respondsToSelector:@selector(attachmentForBugsplatStartupManager:)])
    {
        BugsplatAttachment *bugsplatAttachment = [_delegate attachmentForBugsplatStartupManager:self];
        BITHockeyAttachment *hockeyAttachment = [[BITHockeyAttachment alloc] initWithFilename:bugsplatAttachment.filename
                                                                         hockeyAttachmentData:bugsplatAttachment.attachmentData
                                                                                  contentType:bugsplatAttachment.contentType];
        
        return hockeyAttachment;
    }
    
    return nil;
}

- (void)crashManagerWillShowSubmitCrashReportAlert:(BITCrashManager *)crashManager
{
    if ([_delegate respondsToSelector:@selector(bugsplatStartupManagerWillShowSubmitCrashReportAlert:)])
    {
        [_delegate bugsplatStartupManagerWillShowSubmitCrashReportAlert:self];
    }
}

- (void)crashManagerWillCancelSendingCrashReport:(BITCrashManager *)crashManager
{
    if ([_delegate respondsToSelector:@selector(bugsplatStartupManagerWillCancelSendingCrashReport:)])
    {
        [_delegate bugsplatStartupManagerWillCancelSendingCrashReport:self];
    }
}

- (void)crashManagerWillSendCrashReport:(BITCrashManager *)crashManager
{
    if ([_delegate respondsToSelector:@selector(bugsplatStartupManagerWillSendCrashReport:)])
    {
        [_delegate bugsplatStartupManagerWillSendCrashReport:self];
    }
}

- (void)crashManager:(BITCrashManager *)crashManager didFailWithError:(NSError *)error
{
    if ([_delegate respondsToSelector:@selector(bugsplatStartupManager:didFailWithError:)])
    {
        [_delegate bugsplatStartupManager:self didFailWithError:error];
    }
}

- (void)crashManagerDidFinishSendingCrashReport:(BITCrashManager *)crashManager
{
    if ([_delegate respondsToSelector:@selector(bugsplatStartupManagerDidFinishSendingCrashReport:)])
    {
        [_delegate bugsplatStartupManagerDidFinishSendingCrashReport:self];
    }
}

@end
