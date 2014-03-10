//
//  NSArray+extensions.m
//  Livedown
//
//  Created by Dan Zimmerman on 3/10/14.
//  Copyright (c) 2014 Joan Heaton & Den Zimmerman. All rights reserved.
//

#import "NSArray+extensions.h"

@implementation NSArray (extensions)

- (NSArray *)map:(id (^)(id element, NSInteger index))cb {
    NSMutableArray *retval = [NSMutableArray array];
    NSInteger i = 0;
    for (id elm in self) {
        [retval addObject:cb(elm, i)];
        i++;
    }
    return retval;
}

@end
