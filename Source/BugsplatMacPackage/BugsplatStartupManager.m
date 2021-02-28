//
//  BugsplatStartupManager.m
//  BugsplatMac
//
//  Created by Geoff Raeder on 2/8/16.
//  Copyright © 2016 Bugsplat. All rights reserved.
//

#import "HockeySDK.h"
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
        _expirationTimeInterval = -1;
        
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
    [[[BITHockeyManager sharedHockeyManager] crashManager] setBannerImage:self.bannerImage];
}

- (void)setAskUserDetails:(BOOL)askUserDetails
{
    _askUserDetails = askUserDetails;
    [[[BITHockeyManager sharedHockeyManager] crashManager] setAskUserDetails:self.askUserDetails];
}

- (void)setPersistUserDetails:(BOOL)persistUserDetails
{
    _persistUserDetails = persistUserDetails;
    [[[BITHockeyManager sharedHockeyManager] crashManager] setPersistUserInfo:self.persistUserDetails];
}

- (void)setExpirationTimeInterval:(NSTimeInterval)expirationTimeInterval
{
    _expirationTimeInterval = expirationTimeInterval;
    [[[BITHockeyManager sharedHockeyManager] crashManager] setExpirationTimeInterval:self.expirationTimeInterval];
}

- (void)setAutoSubmitCrashReport:(BOOL)autoSubmitCrashReport
{
    _autoSubmitCrashReport = autoSubmitCrashReport;
    [[[BITHockeyManager sharedHockeyManager] crashManager] setAutoSubmitCrashReport:self.autoSubmitCrashReport];
}

- (void)setUserName:(NSString *)userName
{
    _userName = userName;
    [[[BITHockeyManager sharedHockeyManager] crashManager] setUserName:_userName];
}

- (void)setUserEmail:(NSString *)userEmail
{
    _userEmail = userEmail;
    [[[BITHockeyManager sharedHockeyManager] crashManager] setUserEmail:_userEmail];
}

- (void)setPresentModally:(BOOL)presentModally
{
    _presentModally = presentModally;
    [[[BITHockeyManager sharedHockeyManager] crashManager] setPresentModally:_presentModally];
}

- (void)setDelegate:(id<BugsplatStartupManagerDelegate>)delegate
{
    if (_delegate != delegate)
    {
        _delegate = delegate;
    }
    
    [[BITHockeyManager sharedHockeyManager] setDelegate:self];
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

- (NSString *)applicationKeyForCrashManager:(BITCrashManager *)crashManager signal:(NSString *)signal exceptionName:(NSString *)exceptionName exceptionReason:(NSString *)exceptionReason
{
    if ([_delegate respondsToSelector:@selector(applicationKeyForBugsplatStartupManager:signal:exceptionName:exceptionReason:)])
    {
        return [_delegate applicationKeyForBugsplatStartupManager:self signal:signal exceptionName:exceptionName exceptionReason:exceptionReason];
    }
    
    return nil;
}

- (NSArray<BITHockeyAttachment *> *)attachmentsForCrashManager:(BITCrashManager *)crashManager;
{
    if ([_delegate respondsToSelector:@selector(attachmentsForBugsplatStartupManager:)])
    {
        NSMutableArray *attachments = [[NSMutableArray alloc] init];
        
        NSArray *bugsplatAttachments = [_delegate attachmentsForBugsplatStartupManager:self];
        
        for (BugsplatAttachment *attachment in bugsplatAttachments)
        {
            BITHockeyAttachment *hockeyAttachment = [[BITHockeyAttachment alloc] initWithFilename:attachment.filename
                                                                             hockeyAttachmentData:attachment.attachmentData
                                                                                      contentType:attachment.contentType];
            
            [attachments addObject:hockeyAttachment];
        }       
        
        return [attachments copy];
    }
    else if ([_delegate respondsToSelector:@selector(attachmentForBugsplatStartupManager:)])
    {
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        
        BugsplatAttachment *attachment = [_delegate attachmentForBugsplatStartupManager:self];
        
#pragma clang diagnostic pop
        
        BITHockeyAttachment *hockeyAttachment = [[BITHockeyAttachment alloc] initWithFilename:attachment.filename
                                                                         hockeyAttachmentData:attachment.attachmentData
                                                                                  contentType:attachment.contentType];
        
        return @[hockeyAttachment];
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
