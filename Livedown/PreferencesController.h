//
//  PreferencesController.h
//  Livedown
//
//  Created by Dan Zimmerman on 3/9/14.
//  Copyright (c) 2014 Joan Heaton & Den Zimmerman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PreferencesController : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic) NSColor *backgroundColor;
@property (nonatomic) NSColor *backgroundSelectionColor;
@property (nonatomic) NSColor *textSelectionColor;
@property (nonatomic) NSColor *textColor;
@property (nonatomic) NSInteger port;
@property (nonatomic) NSString *cssFilePath;
@property (nonatomic) NSString *pygmentCSSFilePath;
@property (nonatomic) NSFont *font;
@property (nonatomic, readonly) NSArray *fontHistory;
@property (nonatomic, readonly) NSArray *cssHistory;
@property (nonatomic, readonly) NSArray *pygmentCSSHistory;
@property (nonatomic, readonly) NSArray *staticFonts;
@property (nonatomic, readonly) NSArray *staticCSSs;
@property (nonatomic, readonly) NSArray *staticPygmentCSSs;

- (void)addFontToHistory:(NSFont *)font;
- (void)addCSSToHistory:(NSString *)css;
- (void)addPygmentCSSToHistory:(NSString *)pygmentCSS;

@property (nonatomic, assign) NSNumber *childPID;

@end
