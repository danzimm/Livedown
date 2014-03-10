//
//  PrefsWindowController.m
//  Livedown
//
//  Created by Dan Zimmerman on 3/9/14.
//  Copyright (c) 2014 Joan Heaton & Den Zimmerman. All rights reserved.
//

#import "PrefsWindowController.h"
#import "PreferencesController.h"
#import "LDNodeManager.h"
#import "PreferencesController_private.h"

const NSString *prefscolorschangedhotdognotification = @"poopi";
const NSString *prefscsschangedhotdognotification = @"doopi";

@interface PrefsWindowController () {
    NSArray *staticFonts;
    NSArray *staticCSSs;
    NSArray *staticPygmentCSSs;
}

@end

@implementation PrefsWindowController

- (void)awakeFromNib {
    [super awakeFromNib];
    
    staticFonts = [[PreferencesController sharedInstance] staticFonts];
    staticCSSs = [[PreferencesController sharedInstance] staticCSSs];
    staticPygmentCSSs = [[PreferencesController sharedInstance] staticPygmentCSSs];
    
    [self loadFontMenu];
    [self loadCSSMenu];
    [self loadPygmentCSSMenu];
}

- (void)loadPygmentCSSMenu {
    NSString *prefPygmentCSS = [[PreferencesController sharedInstance] _pygmentCSSFilePath];
    NSMenu *pygmentCSSMenu = [[NSMenu alloc] init];
    int index = 0, __block i = 0;
    for (NSString *path in staticPygmentCSSs) {
        if ([prefPygmentCSS isEqualToString:path]) {
            index = i;
        }
        [pygmentCSSMenu addItemWithTitle:[path lastPathComponent] action:@selector(selectStaticPygmentCSS:) keyEquivalent:@""];
        i++;
    }
    [pygmentCSSMenu addItem:[NSMenuItem separatorItem]];
    i++;
    NSArray *pygmentCSSHist = [[PreferencesController sharedInstance] pygmentCSSHistory];
    for (NSString *pygmentCSS in pygmentCSSHist) {
        if ([pygmentCSS isEqualToString:prefPygmentCSS]) {
            index = i;
        }
        [pygmentCSSMenu addItemWithTitle:[pygmentCSS lastPathComponent] action:@selector(selectPygmentCSS:) keyEquivalent:@""];
        i++;
    }
    if (pygmentCSSHist.count)
        [pygmentCSSMenu addItem:[NSMenuItem separatorItem]];
    [pygmentCSSMenu addItemWithTitle:@"Choose File..." action:@selector(showPygmentCSSFilePicker) keyEquivalent:@""];
    self.pygmentCSSFilePopup.menu = pygmentCSSMenu;
    [self.pygmentCSSFilePopup selectItemAtIndex:index];
}

- (void)selectPygmentCSS:(NSMenuItem *)item {
    NSInteger index = [self.pygmentCSSFilePopup.menu indexOfItem:item] - staticPygmentCSSs.count - 1;
    @try {
        NSString *pygmentCSS = [[PreferencesController sharedInstance] pygmentCSSHistory][index];
        [[PreferencesController sharedInstance] setPygmentCSSFilePath:pygmentCSS];
    }
    @catch (NSException *exception) {
        NSLog(@"Could not find pygment-css %ld", index);
    }
    @finally {
        [self loadPygmentCSSMenu];
        [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)prefscsschangedhotdognotification object:nil];
    }
}

- (void)selectStaticPygmentCSS:(NSMenuItem *)item {
    NSInteger index = [self.pygmentCSSFilePopup.menu indexOfItem:item];
    @try {
        NSString *pygmentCSS = staticPygmentCSSs[index];
        [[PreferencesController sharedInstance] setPygmentCSSFilePath:pygmentCSS];
    }
    @catch (NSException *exception) {
        NSLog(@"Could not find pygment-css %ld", index);
    }
    @finally {
        [self loadPygmentCSSMenu];
        [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)prefscsschangedhotdognotification object:nil];
    }
}

- (void)showPygmentCSSFilePicker {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.allowedFileTypes = @[@"css"];
    if ([openPanel runModal] == NSFileHandlingPanelOKButton) {
        [[PreferencesController sharedInstance] setPygmentCSSFilePath:[[openPanel URL] path]];
        [self loadPygmentCSSMenu];
        [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)prefscsschangedhotdognotification object:nil];
    }
}

- (void)loadCSSMenu {
    NSString *prefCSS = [[PreferencesController sharedInstance] _cssFilePath];
    NSMenu *cssMenu = [[NSMenu alloc] init];
    int index = 0, __block i = 0;
    for (NSString *path in staticCSSs) {
        if ([prefCSS isEqualToString:path]) {
            index = i;
        }
        [cssMenu addItemWithTitle:[path lastPathComponent] action:@selector(selectStaticCSS:) keyEquivalent:@""];
        i++;
    }
    [cssMenu addItem:[NSMenuItem separatorItem]];
    i++;
    NSArray *cssHist = [[PreferencesController sharedInstance] cssHistory];
    for (NSString *css in cssHist) {
        if ([css isEqualToString:prefCSS]) {
            index = i;
        }
        [cssMenu addItemWithTitle:[css lastPathComponent] action:@selector(selectCSS:) keyEquivalent:@""];
        i++;
    }
    if (cssHist.count)
        [cssMenu addItem:[NSMenuItem separatorItem]];
    [cssMenu addItemWithTitle:@"Choose File..." action:@selector(showCSSFilePicker) keyEquivalent:@""];
    self.cssFilePopup.menu = cssMenu;
    [self.cssFilePopup selectItemAtIndex:index];
}

- (void)selectCSS:(NSMenuItem *)item {
    NSInteger index = [self.cssFilePopup.menu indexOfItem:item] - staticCSSs.count - 1;
    @try {
        NSString *css = [[PreferencesController sharedInstance] cssHistory][index];
        [[PreferencesController sharedInstance] setCssFilePath:css];
    }
    @catch (NSException *exception) {
        NSLog(@"Could not find css %ld", index);
    }
    @finally {
        [self loadCSSMenu];
        [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)prefscsschangedhotdognotification object:nil];
    }
}

- (void)selectStaticCSS:(NSMenuItem *)item {
    NSInteger index = [self.cssFilePopup.menu indexOfItem:item];
    @try {
        NSString *css = staticCSSs[index];
        [[PreferencesController sharedInstance] setCssFilePath:css];
    }
    @catch (NSException *exception) {
        NSLog(@"Could not find css %ld", index);
    }
    @finally {
        [self loadCSSMenu];
        [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)prefscsschangedhotdognotification object:nil];
    }
}

- (void)showCSSFilePicker {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.allowedFileTypes = @[@"css"];
    if ([openPanel runModal] == NSFileHandlingPanelOKButton) {
        [[PreferencesController sharedInstance] setCssFilePath:[[openPanel URL] path]];
        [self loadCSSMenu];
        [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)prefscsschangedhotdognotification object:nil];
    }
}

- (void)loadFontMenu {
    NSFont *preffont = [[PreferencesController sharedInstance] font];
    NSMenu *fontMenu = [[NSMenu alloc] init];
    int index = 0, __block i = 0;
    for (NSFont *font in staticFonts) {
        if ([preffont isEqual:font]) {
            index = i;
        }
        [fontMenu addItemWithTitle:[NSString stringWithFormat:@"%@ %d", font.displayName, (int)font.pointSize] action:@selector(selectStaticFont:) keyEquivalent:@""];
        i++;
    }
    [fontMenu addItem:[NSMenuItem separatorItem]];
    i++;
    NSArray *fontHist = [[PreferencesController sharedInstance] fontHistory];
    for (NSFont *font in fontHist) {
        if ([font isEqual:preffont]) {
            index = i;
        }
        [fontMenu addItemWithTitle:[NSString stringWithFormat:@"%@ %d", font.displayName, (int)font.pointSize] action:@selector(selectFont:) keyEquivalent:@""];
        i++;
    }
    if (fontHist.count)
        [fontMenu addItem:[NSMenuItem separatorItem]];
    [fontMenu addItemWithTitle:@"Choose Font..." action:@selector(showFontPicker) keyEquivalent:@""];
    
    self.fontPopup.menu = fontMenu;
    [self.fontPopup selectItemAtIndex:index];
}

- (void)selectFont:(NSMenuItem *)item {
    NSInteger index = [self.fontPopup.menu indexOfItem:item] - staticFonts.count - 1;
    @try {
        NSFont *font = [[PreferencesController sharedInstance] fontHistory][index];
        [[PreferencesController sharedInstance] setFont:font];
    }
    @catch (NSException *exception) {
        NSLog(@"Could not find font");
    }
    @finally {
        [self loadFontMenu];
        [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)prefscolorschangedhotdognotification object:nil];
    }
}

- (void)selectStaticFont:(NSMenuItem *)item {
    NSInteger index = [self.fontPopup.menu indexOfItem:item];
    @try {
        NSFont *font = staticFonts[index];
        [[PreferencesController sharedInstance] setFont:font];
    }
    @catch (NSException *exception) {
        NSLog(@"Could not find font");
    }
    @finally {
        [self loadFontMenu];
        [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)prefscolorschangedhotdognotification object:nil];
    }
}

- (void)showFontPicker {
    NSFontManager *fontManager = [NSFontManager sharedFontManager];
    [fontManager setDelegate:self];
    [fontManager setTarget:self];
    [fontManager orderFrontFontPanel:self];
    [self loadFontMenu];
}

- (void)changeFont:(id)sender {
    NSFont *f = [sender convertFont:[[PreferencesController sharedInstance] font]];
    if (!f) {
        NSLog(@"NIL FONT");
        return;
    }
    [[PreferencesController sharedInstance] setFont:f];
    [self loadFontMenu];
    [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)prefscolorschangedhotdognotification object:nil];
}

- (void)showWindow:(id)sender {
    [super showWindow:sender];
    [self.toolbar setSelectedItemIdentifier:@"generalTab"];
    self.portField.stringValue = @([[PreferencesController sharedInstance] port]).stringValue;
    self.backgroundColorWell.color = [[PreferencesController sharedInstance] backgroundColor];
    self.textColorWell.color = [[PreferencesController sharedInstance] textColor];
    self.selectionTextColorWell.color = [[PreferencesController sharedInstance] textSelectionColor];
    self.selectionBackgroundColorWell.color = [[PreferencesController sharedInstance] backgroundSelectionColor];
}

- (IBAction)textColorChanged:(NSColorWell *)sender {
    [[PreferencesController sharedInstance] setTextColor:sender.color];
    [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)prefscolorschangedhotdognotification object:nil];
}

- (IBAction)backgroundColorChanged:(NSColorWell *)sender {
    [[PreferencesController sharedInstance] setBackgroundColor:sender.color];
    [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)prefscolorschangedhotdognotification object:nil];
}

- (IBAction)textSelectionColorChanged:(NSColorWell *)sender {
    [[PreferencesController sharedInstance] setTextSelectionColor:sender.color];
    [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)prefscolorschangedhotdognotification object:nil];
}

- (IBAction)backgroundSelectionColorChanged:(NSColorWell *)sender {
    [[PreferencesController sharedInstance] setBackgroundSelectionColor:sender.color];
    [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)prefscolorschangedhotdognotification object:nil];
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor {
    if (control.intValue == 0) {
        control.intValue = 12345;
    }
    [[PreferencesController sharedInstance] setPort:control.integerValue];
    [[LDNodeManager sharedInstance] setPort:[[PreferencesController sharedInstance] port]];
    return YES;
}

@end
