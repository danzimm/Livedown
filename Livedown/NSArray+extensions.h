//
//  NSArray+extensions.h
//  Livedown
//
//  Created by Dan Zimmerman on 3/10/14.
//  Copyright (c) 2014 Joan Heaton & Den Zimmerman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (extensions)

- (NSArray *)map:(id (^)(id element, NSInteger index))cb;

@end
