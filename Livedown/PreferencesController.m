//
//  PreferencesController.m
//  Livedown
//
//  Created by Dan Zimmerman on 3/9/14.
//  Copyright (c) 2014 Joan Heaton & Den Zimmerman. All rights reserved.
//

#import "PreferencesController.h"

@interface PreferencesController () {
    NSArray *_staticPygmentCSSs;
    NSArray *_staticCSSs;
    NSArray *_staticFonts;
}
@end

@implementation PreferencesController

+ (instancetype)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (void)registerDefaults {
    NSDictionary *dict = @{@"backgroundColor" : [NSArchiver archivedDataWithRootObject:[NSColor colorWithSRGBRed:1 green:1 blue:1 alpha:1]],
                           @"backgroundSelectionColor" : [NSArchiver archivedDataWithRootObject:[NSColor colorWithSRGBRed:209/255 green:209/255 blue:209/255 alpha:1]],
                           @"textSelectionColor" : [NSArchiver archivedDataWithRootObject:[NSColor colorWithWhite:0.4 alpha:1]],
                           @"textColor" : [NSArchiver archivedDataWithRootObject:[NSColor colorWithWhite:0.4 alpha:1]],
                           @"port" : @(12345),
                           @"cssFilePath" : @"{RESOURCES}/css/github.css",
                           @"pygmentCSSFilePath" : @"{RESOURCES}/pygments-css/github.css",
                           @"font" : [NSArchiver archivedDataWithRootObject:[NSFont fontWithName:@"PT Mono" size:20]],
                           @"fontHistory" : [NSArchiver archivedDataWithRootObject:@[]],
                           @"pygmentCSSHistory" : [NSArchiver archivedDataWithRootObject:@[]],
                           @"cssHistory" : [NSArchiver archivedDataWithRootObject:@[]]
                           };
    [[NSUserDefaults standardUserDefaults] registerDefaults:dict];
}

- (instancetype)init {
    if ((self = [super init]) != nil) {
        _staticPygmentCSSs = [[[[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"pygments-css"] error:nil] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSString *evaluatedObject, NSDictionary *bindings) {
            return [[evaluatedObject pathExtension] isEqualToString:@"css"];
        }]] map:^id(NSString *element, NSInteger index) {
            return [@"{RESOURCES}/pygments-css/" stringByAppendingString:element];
        }];
        _staticCSSs = [[[[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"css"] error:nil] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSString *evaluatedObject, NSDictionary *bindings) {
            return [[evaluatedObject pathExtension] isEqualToString:@"css"];
        }]] map:^id(NSString *element, NSInteger index) {
            return [@"{RESOURCES}/css/" stringByAppendingString:element];
        }];
        _staticFonts = @[[NSFont fontWithName:@"PT Mono" size:20], [NSFont fontWithName:@"Monaco" size:18], [NSFont fontWithName:@"Anonymous Pro" size:18]];
        [self registerDefaults];
    }
    return self;
}

- (void)setBackgroundColor:(NSColor *)backgroundColor {
    [[NSUserDefaults standardUserDefaults] setObject:[NSArchiver archivedDataWithRootObject:backgroundColor] forKey:@"backgroundColor"];
}

- (void)setTextSelectionColor:(NSColor *)textSelectionColor {
    [[NSUserDefaults standardUserDefaults] setObject:[NSArchiver archivedDataWithRootObject:textSelectionColor] forKey:@"textSelectionColor"];
}

- (void)setBackgroundSelectionColor:(NSColor *)backgroundSelectionColor {
    [[NSUserDefaults standardUserDefaults] setObject:[NSArchiver archivedDataWithRootObject:backgroundSelectionColor] forKey:@"backgroundSelectionColor"];
}


- (void)setTextColor:(NSColor *)textColor {
    [[NSUserDefaults standardUserDefaults] setObject:[NSArchiver archivedDataWithRootObject:textColor] forKey:@"textColor"];
}

- (void)setPort:(NSInteger)port {
    [[NSUserDefaults standardUserDefaults] setInteger:port forKey:@"port"];
}

- (void)setCssFilePath:(NSString *)cssFilePath {
    [self addCSSToHistory:cssFilePath];
    [[NSUserDefaults standardUserDefaults] setObject:cssFilePath forKey:@"cssFilePath"];
}

- (void)addCSSToHistory:(NSString *)css {
    if ([self.staticCSSs containsObject:css]) {
        return;
    }
    NSArray *cssHist = self.cssHistory;
    if ([cssHist containsObject:css]) {
        return;
    }
    NSMutableArray *csss = cssHist.mutableCopy;
    if (csss.count >= 3) {
        [csss removeObjectAtIndex:0];
    }
    [csss addObject:css];
    [[NSUserDefaults standardUserDefaults] setObject:[NSArchiver archivedDataWithRootObject:csss] forKey:@"cssHistory"];
}

- (void)setPygmentCSSFilePath:(NSString *)pygmentCSSFilePath {
    [self addPygmentCSSToHistory:pygmentCSSFilePath];
    [[NSUserDefaults standardUserDefaults] setObject:pygmentCSSFilePath forKey:@"pygmentCSSFilePath"];
}

- (void)addPygmentCSSToHistory:(NSString *)pygmentCSS {
    if ([self.staticPygmentCSSs containsObject:pygmentCSS]) {
        return;
    }
    NSArray *pygmentCSSHist = self.pygmentCSSHistory;
    if ([pygmentCSSHist containsObject:pygmentCSS]) {
        return;
    }
    NSMutableArray *pygmentCSSs = pygmentCSSHist.mutableCopy;
    if (pygmentCSSs.count >= 3) {
        [pygmentCSSs removeObjectAtIndex:0];
    }
    [pygmentCSSs addObject:pygmentCSS];
    [[NSUserDefaults standardUserDefaults] setObject:[NSArchiver archivedDataWithRootObject:pygmentCSSs] forKey:@"pygmentCSSHistory"];
}

- (void)setFont:(NSFont *)font {
    [self addFontToHistory:font];
    [[NSUserDefaults standardUserDefaults] setObject:[NSArchiver archivedDataWithRootObject:font] forKey:@"font"];
}

- (void)addFontToHistory:(NSFont *)font {
    if ([self.staticFonts containsObject:font]) {
        return;
    }
    NSArray *fontHist = self.fontHistory;
    if ([fontHist containsObject:font]) {
        return;
    }
    NSMutableArray *fonts = fontHist.mutableCopy;
    if (fonts.count >= 3) {
        [fonts removeObjectAtIndex:0];
    }
    [fonts addObject:font];
    [[NSUserDefaults standardUserDefaults] setObject:[NSArchiver archivedDataWithRootObject:fonts] forKey:@"fontHistory"];
}

- (NSColor *)backgroundColor {
    return (NSColor *)[NSUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"backgroundColor"]];
}

- (NSColor *)textSelectionColor {
    return (NSColor *)[NSUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"textSelectionColor"]];
}

- (NSColor *)backgroundSelectionColor {
    return (NSColor *)[NSUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"backgroundSelectionColor"]];
}

- (NSColor *)textColor {
    return (NSColor *)[NSUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"textColor"]];
}

- (NSInteger)port {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"port"];
}

- (NSString *)_cssFilePath {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"cssFilePath"];
}

- (NSString *)cssFilePath {
    return [[self _cssFilePath] stringByReplacingOccurrencesOfString:@"{RESOURCES}" withString:[[NSBundle mainBundle] resourcePath]];
}

- (NSArray *)cssHistory {
    NSArray *arr = [NSUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"cssHistory"]];
    return arr ?: @[];
}

- (NSString *)_pygmentCSSFilePath {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"pygmentCSSFilePath"];
}

- (NSString *)pygmentCSSFilePath {
    return [[self _pygmentCSSFilePath] stringByReplacingOccurrencesOfString:@"{RESOURCES}" withString:[[NSBundle mainBundle] resourcePath]];
}

- (NSArray *)pygmentCSSHistory {
    NSArray *arr = [NSUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"pygmentCSSHistory"]];
    return arr ?: @[];
}

- (NSFont *)font {
    NSFont *f = [NSUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"font"]];
    return f ?: [NSFont fontWithName:@"PT Mono" size:20];
}

- (NSArray *)fontHistory {
    NSArray *arr = [NSUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"fontHistory"]];
    return arr ?: @[];
}

- (void)setChildPID:(NSNumber *)childPID {
    [[NSUserDefaults standardUserDefaults] setObject:childPID forKey:@"ChildPID"];
}

- (NSNumber *)childPID {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"ChildPID"];
}

- (NSArray *)staticFonts {
    return _staticFonts;
}

- (NSArray *)staticCSSs {
    return _staticCSSs;
}

- (NSArray *)staticPygmentCSSs {
    return _staticPygmentCSSs;
}

@end
