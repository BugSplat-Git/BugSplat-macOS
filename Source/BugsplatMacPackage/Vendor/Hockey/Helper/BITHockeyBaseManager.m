#import "HockeySDK.h"
#import "HockeySDKPrivate.h"

#import "BITHockeyHelper.h"

#import "BITHockeyBaseManager.h"
#import "BITHockeyBaseManagerPrivate.h"

#import <sys/sysctl.h>
#import <mach-o/ldsyms.h>

@interface BITHockeyBaseManager()

@property(nonatomic, strong) NSDateFormatter *rfc3339Formatter;

@end

@implementation BITHockeyBaseManager

- (id)init {
  if ((self = [super init])) {
    _appIdentifier = nil;
    _serverURL = kBITHockeySDKURL;
    _userID = nil;
    _userName = nil;
    _userEmail = nil;
      
    _persistUserInfo = NO;
    
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    _rfc3339Formatter = [[NSDateFormatter alloc] init];
    [_rfc3339Formatter setLocale:enUSPOSIXLocale];
    [_rfc3339Formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    [_rfc3339Formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
  }
  return self;
}

- (id)initWithAppIdentifier:(NSString *)appIdentifier {
  if ((self = [self init])) {
    _appIdentifier = appIdentifier;
  }
  return self;
}



#pragma mark - Private

- (void)reportError:(NSError *)error {
  BITHockeyLogError(@"ERROR: %@", [error localizedDescription]);
}

- (NSString *)encodedAppIdentifier {
  return (self.appIdentifier ? bit_URLEncodedString(self.appIdentifier) : bit_URLEncodedString([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"]));
}

- (NSString *)getDevicePlatform {
  size_t size;
  sysctlbyname("hw.machine", NULL, &size, NULL, 0);
  char *answer = (char*)malloc(size);
  sysctlbyname("hw.machine", answer, &size, NULL, 0);
  NSString *platform = @(answer);
  free(answer);
  return platform;
}


#pragma mark - Manager Control

- (void)startManager {
}


#pragma mark - Helpers

- (NSDate *)parseRFC3339Date:(NSString *)dateString {
  NSDate *date = nil;
  NSError *error = nil; 
  if (![self.rfc3339Formatter getObjectValue:&date forString:dateString range:nil error:&error]) {
    BITHockeyLogDebug(@"INFO: Invalid date '%@' string: %@", dateString, error);
  }
  
  return date;
}


@end
