//
//  YTWindowController.h
//  YTFloat
//
//  Created by Tim Desir on 6/28/14.
//  Copyright (c) 2014 Tim D. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface YTWindowController : NSWindowController 
{
    IBOutlet WebView *playerWebView;
}
- (IBAction)hideVideo:(id)sender;
- (IBAction)closeVideo:(id)sender;

@end
