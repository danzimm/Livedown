//
//  LDWindowController.m
//  Livedown
//
//  Created by Dan Zimmerman on 3/9/14.
//  Copyright (c) 2014 Joan Heaton & Den Zimmerman. All rights reserved.
//

#import "LDWindowController.h"
#import "LDNodeManager.h"
#import "Document.h"
#import "PrefsWindowController.h"
#import "PreferencesController.h"

@interface LDWindowController () {
    NSOperationQueue *loadingQueue;
    NSNumber *scrollOffset;
    int count;
}

@property (nonatomic, copy) NSString *css;
@property (nonatomic, copy) NSString *pygmentCss;

@end

@implementation LDWindowController

- (id)init {
    if ((self = [super initWithWindowNibName:@"Document"]) != nil) {
//        self.css = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"github" ofType:@"css"] encoding:NSUTF8StringEncoding error:nil];
//        self.pygmentCss = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"github-pygments" ofType:@"css"] encoding:NSUTF8StringEncoding error:nil];
        loadingQueue = [NSOperationQueue new];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colorsUpdated) name:(NSString *)prefscolorschangedhotdognotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cssUpdated) name:(NSString *)prefscsschangedhotdognotification object:nil];
        scrollOffset = @(0);
        count = 0;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)cssUpdated {
    self.css = [NSString stringWithContentsOfFile:[[PreferencesController sharedInstance] cssFilePath] encoding:NSUTF8StringEncoding error:nil];
    self.pygmentCss = [NSString stringWithContentsOfFile:[[PreferencesController sharedInstance] pygmentCSSFilePath] encoding:NSUTF8StringEncoding error:nil];
    
    [self loadForString:self.editorView.string];
}

- (void)colorsUpdated {
    self.editorView.font = [[PreferencesController sharedInstance] font];
    self.editorView.textColor = [[PreferencesController sharedInstance] textColor];
    self.editorView.backgroundColor = [[PreferencesController sharedInstance] backgroundColor];
    self.editorView.selectedTextAttributes = @{ NSForegroundColorAttributeName: [[PreferencesController sharedInstance] textSelectionColor],
                                                NSBackgroundColorAttributeName: [[PreferencesController sharedInstance] backgroundSelectionColor] };
    self.editorView.insertionPointColor = [[PreferencesController sharedInstance] textColor];
    self.editorView.textContainerInset = NSMakeSize(20, 20);
    
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {
    [sender.windowScriptObject evaluateWebScript:[NSString stringWithFormat:@"window.scroll(0, %d)", scrollOffset.intValue]];
}

- (void)webView:(WebView *)webView decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id < WebPolicyDecisionListener >)listener {
    if ([(NSNumber *)actionInformation[WebActionNavigationTypeKey] intValue] != WebNavigationTypeOther) {
        [listener ignore];
    } else {
        [listener use];
    }
}

- (void)loadWindow {
    [super loadWindow];
    
    [self colorsUpdated];
    [self cssUpdated];
    [self.webview.mainFrame loadHTMLString:@"" baseURL:nil];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    self.editorView.string = ((Document *)self.document).text ? : @"";
    [self loadForString:self.editorView.string];
}

- (void)loadForString:(NSString *)text {
    count++;
    if (count > 100)
        return;
    [loadingQueue cancelAllOperations];
    if (text.length) {
        id __weak _me = self;
        [NSURLConnection sendAsynchronousRequest:[[LDNodeManager sharedInstance] requestText:text] queue:loadingQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (connectionError) {
                usleep(1000000 * 0.5);
                [_me loadForString:text];
                return;
            }
            count = 0;
            NSString *resp = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSString *a = [NSString stringWithFormat:@"<style>%@;\n%@</style>%@", self.css, self.pygmentCss, resp];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                scrollOffset = [self.webview.windowScriptObject evaluateWebScript:@"window.scrollY"];
                [self.webview.mainFrame loadHTMLString:a baseURL:nil];
            });
        }];
    } else {
        [self.webview.mainFrame loadHTMLString:@"" baseURL:nil];
    }

}

- (BOOL)textView:(NSTextView *)textView shouldChangeTextInRange:(NSRange)affectedCharRange replacementString:(NSString *)replacementString {
    NSString *resolved = [textView.string stringByReplacingCharactersInRange:affectedCharRange withString:replacementString];
    
    ((Document *)self.document).text = resolved;
    
    [self loadForString:resolved];
        
    return YES;
}

@end
