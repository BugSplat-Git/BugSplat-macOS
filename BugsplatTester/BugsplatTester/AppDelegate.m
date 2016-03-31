//
//  AppDelegate.m
//  BugsplatTester
//
//  Created by Geoff Raeder on 8/17/15.
//  Copyright (c) 2015 BugSplat. All rights reserved.
//

#import "AppDelegate.h"

@import BugsplatMac;

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[BugsplatStartupManager sharedManager] startupWithAppIdentifier:@"b0cf675cb9334a3e96eda0764f95e38c"];
}

- (void)performCrash
{
    void (^nilBlock)() = nil;
    nilBlock();
}

- (IBAction)crash:(id)sender
{
    [self performCrash];
}

@end
