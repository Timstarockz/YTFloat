//
//  YTWindowController.m
//  YTFloat
//
//  Created by Tim Desir on 6/28/14.
//  Copyright (c) 2014 Tim D. All rights reserved.
//

#import "YTWindowController.h"


@interface YTWindowController ()

@end

@implementation YTWindowController


- (id)initWithWindow:(NSWindow *)window {
    self = [super initWithWindow:window];
    if (self) {
        NSLog(@"initWithWindow");
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playVideo:) name:@"PlayAVideo" object:nil];
    }
    
    return self;
}


static BOOL hasVideo = NO;
static BOOL hiddenVid = NO;

- (void)playVideo:(NSNotification *)noti {
    hiddenVid = NO;
    
    [NSApp unhide:self];
    [self.window makeKeyAndOrderFront:self];
    
    NSString *url = [noti object];
    
    [playerWebView setLayerUsesCoreImageFilters:YES];
    [[playerWebView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:28]];
    
    if (!hasVideo) {
        [self fadeInWindow:self.window];
        NSRect screen = [[NSScreen mainScreen] frame];
        [self.window setFrame:NSMakeRect(screen.size.width-self.window.frame.size.width-13,13,
                                         self.window.frame.size.width,
                                         self.window.frame.size.height) display:YES animate:YES];
        hasVideo = YES;
    }
    
    NSLog(@"%@",url);
}

- (IBAction)hideVideo:(id)sender {
    if (!hiddenVid) {
        
        NSRect screen = [[NSScreen mainScreen] frame];
        [self.window setFrame:NSMakeRect(screen.size.width-30, 13, self.window.frame.size.width, self.window.frame.size.height) display:YES animate:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.window setAlphaValue:0.3];
            hiddenVid = YES;
        });
    } else {
        
        hiddenVid = NO;
        NSRect screen = [[NSScreen mainScreen] frame];
        [self.window setFrame:NSMakeRect(screen.size.width-self.window.frame.size.width-13,13, self.window.frame.size.width, self.window.frame.size.height) display:YES animate:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.window setAlphaValue:1.0];
        });
    }
}

- (IBAction)closeVideo:(id)sender {
    NSRect screen = [[NSScreen mainScreen] frame];
    [self.window setFrame:NSMakeRect(screen.size.width, 13, self.window.frame.size.width, self.window.frame.size.height) display:YES animate:YES];
    
    [self fadeOutWindow:self.window];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        hasVideo = NO;
        [[playerWebView mainFrame] loadHTMLString:@"" baseURL:nil];
        [NSApp hide:self];
    });
}


//// ---------------------------------------------
// still testing these
- (void)fadeOutWindow:(NSWindow*)window {
	float alpha = 1.0;
	[window setAlphaValue:alpha];
	[window makeKeyAndOrderFront:self];
	for (int x = 0; x < 10; x++) {
		alpha -= 0.1;
		[window setAlphaValue:alpha];
		[NSThread sleepForTimeInterval:0.020];
	}
}

- (void)fadeInWindow:(NSWindow*)window {
	float alpha = 0.0;
	[window setAlphaValue:alpha];
	[window makeKeyAndOrderFront:self];
	for (int x = 0; x < 10; x++) {
		alpha += 0.1;
		[window setAlphaValue:alpha];
		[NSThread sleepForTimeInterval:0.020];
	}
}

#ifndef NSEventTypeSwipe
#define NSEventTypeSwipe 31
#endif

- (void)didSwipeWindowWithEvent:(NSNotification *)noti {
	NSEvent *event = [noti object];
	if ([event deltaX] > 0.5)
	{ //back
		//[webView goBack];
        NSLog(@"Previous");
	}
	else if ([event deltaX] < -0.5)
	{ //forward
		//[webView goForward];
        NSLog(@"Next");
	}
	else if ([event deltaY] > 0.5)
	{
        // up
        
        NSLog(@"");
	}
	else if ([event deltaY] < -0.5)
	{
		// down
	}
}

//// ---------------------------------------------

@end
