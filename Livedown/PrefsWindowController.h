//
//  PrefsWindowController.h
//  Livedown
//
//  Created by Dan Zimmerman on 3/9/14.
//  Copyright (c) 2014 Joan Heaton & Den Zimmerman. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PrefsWindowController : NSWindowController<NSTextFieldDelegate>

@property (nonatomic, weak) IBOutlet NSToolbar *toolbar;
@property (nonatomic, weak) IBOutlet NSPopUpButton *cssFilePopup;
@property (nonatomic, weak) IBOutlet NSPopUpButton *fontPopup;
@property (nonatomic, weak) IBOutlet NSPopUpButton *pygmentCSSFilePopup;
@property (nonatomic, weak) IBOutlet NSTextField *portField;

@property (nonatomic, weak) IBOutlet NSColorWell *backgroundColorWell;
@property (nonatomic, weak) IBOutlet NSColorWell *textColorWell;
@property (nonatomic, weak) IBOutlet NSColorWell *selectionBackgroundColorWell;
@property (nonatomic, weak) IBOutlet NSColorWell *selectionTextColorWell;

- (IBAction)textColorChanged:(id)sender;
- (IBAction)backgroundColorChanged:(id)sender;
- (IBAction)textSelectionColorChanged:(id)sender;
- (IBAction)backgroundSelectionColorChanged:(id)sender;

@end

const NSString *prefscolorschangedhotdognotification;
const NSString *prefscsschangedhotdognotification;
