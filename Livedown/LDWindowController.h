//
//  LDWindowController.h
//  Livedown
//
//  Created by Dan Zimmerman on 3/9/14.
//  Copyright (c) 2014 Joan Heaton & Den Zimmerman. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface LDWindowController : NSWindowController <NSTextViewDelegate>

@property (nonatomic, weak) IBOutlet WebView *webview;
@property (nonatomic) IBOutlet NSTextView *editorView;

@end
