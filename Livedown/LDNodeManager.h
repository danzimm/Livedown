//
//  LDNodeManager.h
//  Livedown
//
//  Created by Dan Zimmerman on 3/9/14.
//  Copyright (c) 2014 Joan Heaton & Den Zimmerman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LDNodeManager : NSObject

@property (nonatomic) NSInteger port;

+ (instancetype)sharedInstance;
- (NSURLRequest *)requestText:(NSString *)text;

- (void)smashit;

@end
