//
//  LDNodeManager.m
//  Livedown
//
//  Created by Dan Zimmerman on 3/9/14.
//  Copyright (c) 2014 Joan Heaton & Den Zimmerman. All rights reserved.
//

#import "LDNodeManager.h"
#import "PreferencesController.h"

@interface LDNodeManager () {
    NSTask *_serverTask;
}

@end

@implementation LDNodeManager

+ (instancetype)sharedInstance {
    static LDNodeManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[LDNodeManager alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    if ((self = [super init]) != nil) {
        
        self.port = [[PreferencesController sharedInstance] port];
        
    }
    return self;
}

- (void)setPort:(NSInteger)port {
    
    _port = port;
    
    [_serverTask terminate];
    
    NSNumber *nPID = [[PreferencesController sharedInstance] childPID];
    if(nPID) {
        NSLog(@"TRYNA KILL THEES HOES %d", nPID.intValue);
        kill(nPID.intValue, SIGKILL);
    }
    
    _serverTask = [[NSTask alloc] init];
    [_serverTask setCurrentDirectoryPath:[[NSBundle mainBundle] resourcePath]];
    NSString *a = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"nodefs/bin/node"];
    [_serverTask setLaunchPath:a];
    [_serverTask setArguments:@[@"./nodefs/server/server.js", @(self.port).stringValue]];
    [_serverTask launch];
    
    [[PreferencesController sharedInstance] setChildPID:@(_serverTask.processIdentifier)];

}

- (NSURLRequest *)requestText:(NSString *)text {
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:%ld", self.port]]];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:[[NSString stringWithFormat:@"data=%@",text] dataUsingEncoding:NSUTF8StringEncoding]];
    return req;
}

- (void)smashit {
    [_serverTask terminate];
}

@end
