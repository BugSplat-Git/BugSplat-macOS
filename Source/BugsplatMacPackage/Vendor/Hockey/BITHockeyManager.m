#import "HockeySDK.h"
#import "HockeySDKPrivate.h"

#import "BITHockeyBaseManagerPrivate.h"
#import "BITCrashManagerPrivate.h"
#import "BITHockeyHelper.h"
#import "BITHockeyAppClient.h"

NSString *const kBITHockeySDKURL = @"https://sdk.hockeyapp.net/";

@interface BITHockeyManager ()

@property (nonatomic, copy) NSString *appIdentifier;
@property (nonatomic) BOOL validAppIdentifier;
@property (nonatomic) BOOL startManagerIsInvoked;
@property (nonatomic, strong) BITHockeyAppClient *hockeyAppClient;

// Redeclare BITHockeyManager properties with readwrite attribute.
@property (nonatomic, strong, readwrite) BITCrashManager *crashManager;

@end


@implementation BITHockeyManager

#pragma mark - Public Class Methods

+ (BITHockeyManager *)sharedHockeyManager {
  static BITHockeyManager *sharedInstance = nil;
  static dispatch_once_t pred;
  
  dispatch_once(&pred, ^{
    sharedInstance = [BITHockeyManager alloc];
    sharedInstance = [sharedInstance init];
  });
  
  return sharedInstance;
}

- (id) init {
  if ((self = [super init])) {
    _serverURL = nil;
    _delegate = nil;
    self.hockeyAppClient = nil;
    
    self.startManagerIsInvoked = NO;
  }
  return self;
}

- (void)dealloc {
  self.appIdentifier = nil;
  
}


#pragma mark - Private Class Methods

- (BOOL)isSetUpOnMainThread {
  if (!NSThread.isMainThread) {
    NSAssert(NSThread.isMainThread, @"ERROR: This SDK has to be setup on the main thread!");
    
    return NO;
  }
  
  return YES;
}

- (BOOL)checkValidityOfAppIdentifier:(NSString *)identifier {
  BOOL result = NO;
  
  if (identifier) {
    NSCharacterSet *hexSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789abcdef"];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:identifier];
    result = ([identifier length] == 32) && ([hexSet isSupersetOfSet:inStringSet]);
  }
  
  return result;
}

#pragma mark - Public Instance Methods (Configuration)

- (void)configureWithIdentifier:(NSString *)appIdentifier {
  self.appIdentifier = [appIdentifier copy];
  
  [self initializeModules];
}

- (void)configureWithIdentifier:(NSString *)appIdentifier delegate:(id <BITHockeyManagerDelegate>)delegate {
  self.appIdentifier = [appIdentifier copy];
  
  self.delegate = delegate;
  
  [self initializeModules];
}


- (void)configureWithIdentifier:(NSString *)appIdentifier companyName:(NSString *) __unused companyName delegate:(id <BITHockeyManagerDelegate>)delegate {
  self.appIdentifier = [appIdentifier copy];
  
  self.delegate = delegate;
  
  [self initializeModules];
}

- (void)startManager {
  if (!self.validAppIdentifier || ![self isSetUpOnMainThread]) {
    return;
  }
  
  // Fix bug where Application Support directory was encluded from backup
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
  bit_fixBackupAttributeForURL(appSupportURL);
  
  BITHockeyLogDebug(@"INFO: Starting HockeyManager");
  self.startManagerIsInvoked = YES;
  
  // start CrashManager
  if (![self isCrashManagerDisabled]) {
    BITHockeyLogDebug(@"INFO: Start CrashManager");
    [self.crashManager startManager];
  }
}

- (void)setServerURL:(NSString *)aServerURL {
  // ensure url ends with a trailing slash
  if (![aServerURL hasSuffix:@"/"]) {
    aServerURL = [NSString stringWithFormat:@"%@/", aServerURL];
  }
  
  if (_serverURL != aServerURL) {
    _serverURL = [aServerURL copy];
    
    if (self.hockeyAppClient) {
      self.hockeyAppClient.baseURL = [NSURL URLWithString:_serverURL ?: kBITHockeySDKURL];
    }
  }
}

- (void)setDelegate:(id<BITHockeyManagerDelegate>)delegate {
  if (_delegate != delegate) {
    _delegate = delegate;
    
    if (self.crashManager) {
      self.crashManager.delegate = delegate;
    }
  }
}

- (void)setDebugLogEnabled:(BOOL)debugLogEnabled {
  _debugLogEnabled = debugLogEnabled;
  if (debugLogEnabled) {
    self.logLevel = BITLogLevelDebug;
  } else {
    self.logLevel = BITLogLevelWarning;
  }
}

- (BITLogLevel)logLevel {
  return BITHockeyLogger.currentLogLevel;
}

- (void)setLogLevel:(BITLogLevel)logLevel {
  BITHockeyLogger.currentLogLevel = logLevel;
}

- (void)setLogHandler:(BITLogHandler)logHandler {
  [BITHockeyLogger setLogHandler:logHandler];
}

- (void)setUserID:(NSString *)userID {
  if (self.crashManager.persistUserInfo) {
    if (!userID) {
      bit_removeKeyFromKeychain(kBITDefaultUserID);
    } else {
      bit_addStringValueToKeychain(userID, kBITDefaultUserID);
    }
  }
}

- (void)setUserName:(NSString *)userName {
  if (self.crashManager.persistUserInfo) {
    if (!userName) {
      bit_removeKeyFromKeychain(kBITDefaultUserName);
    } else {
      bit_addStringValueToKeychain(userName, kBITDefaultUserName);
    }
  }
}

- (void)setUserEmail:(NSString *)userEmail {
  if (self.crashManager.persistUserInfo) {
    if (!userEmail) {
      bit_removeKeyFromKeychain(kBITDefaultUserEmail);
    } else {
      bit_addStringValueToKeychain(userEmail, kBITDefaultUserEmail);
    }
  }  
}

#pragma mark - Private Instance Methods

- (BITHockeyAppClient *)hockeyAppClient {
  if (!_hockeyAppClient) {
    _hockeyAppClient = [[BITHockeyAppClient alloc] initWithBaseURL:[NSURL URLWithString:self.serverURL ?: kBITHockeySDKURL]];
  }
  
  return _hockeyAppClient;
}

- (void)initializeModules {
  self.validAppIdentifier = [self checkValidityOfAppIdentifier:self.appIdentifier];
  
  if (![self isSetUpOnMainThread]) return;
  
  self.startManagerIsInvoked = NO;
  
  BITHockeyLogDebug(@"INFO: Setup CrashManager");
  self.crashManager = [[BITCrashManager alloc] initWithAppIdentifier:self.appIdentifier
                                                 hockeyAppClient:[self hockeyAppClient]];
  self.crashManager.delegate = self.delegate;
  
  if ([self isCrashManagerDisabled])
    self.crashManager.crashManagerActivated = NO;
}

@end
