//
//  AppDelegate.m
//  Livedown
//
//  Created by Dan Zimmerman on 3/9/14.
//  Copyright (c) 2014 Joan Heaton & Den Zimmerman. All rights reserved.
//

#import "AppDelegate.h"
#import "LDNodeManager.h"
#import "PreferencesController.h"

@implementation AppDelegate

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    [LDNodeManager sharedInstance];
    [PreferencesController sharedInstance];
}

- (void)applicationWillTerminate:(NSNotification *)notification {
    [[LDNodeManager sharedInstance] smashit];
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
}

@end
