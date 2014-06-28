//
//  YTAppDelegate.m
//  YTFloat
//
//  Created by Tim Desir on 6/27/14.
//  Copyright (c) 2014 Tim D. All rights reserved.
//

#import "YTAppDelegate.h"

@implementation YTAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    [[NSAppleEventManager sharedAppleEventManager] setEventHandler:self andSelector:@selector(handleURLEvent:withReplyEvent:) forEventClass:kInternetEventClass andEventID:kAEGetURL];
    
    [ytWebView setLayerUsesCoreImageFilters:YES];
    
    [_window setLevel:kCGDockWindowLevel];
    
    [_window becomeKeyWindow];
    [_window becomeFirstResponder];
}

- (void)handleURLEvent:(NSAppleEventDescriptor*)event withReplyEvent:(NSAppleEventDescriptor*)replyEvent
{
    NSString* url = [[event paramDescriptorForKeyword:keyDirectObject] stringValue];
    //NSLog(@"%@", url);
    
    url = [url stringByReplacingOccurrencesOfString:@"ytfloat://" withString:@""];
    NSURL *fullRL = [NSURL URLWithString:url];
    NSLog(@"%@",fullRL.query);
    
    NSLog(@"%@",fullRL.host);
    if ([fullRL.host isEqualToString:@"www.youtube.com"])
    {
        NSLog(@"YouTube Link");
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        for (NSString *param in [fullRL.query componentsSeparatedByString:@"&"]) {
            NSArray *elts = [param componentsSeparatedByString:@"="];
            if([elts count] < 2) continue;
            [params setObject:[elts objectAtIndex:1] forKey:[elts objectAtIndex:0]];
        }
        
        NSString *finalURLString = [NSString stringWithFormat:@"https://www.youtube.com/v/%@?hl=en_US&amp;version=3",[params objectForKey:@"v"]];
        
        NSLog(@"%@",params);
        
        [[ytWebView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:finalURLString] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:28]];
    }
    if ([fullRL.host isEqualToString:@"www.twitch.tv"])
    {
        NSLog(@"Twitch Link");
        
        NSString *twURL = [NSString stringWithFormat:@"%@/popout",url];
        [[ytWebView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:twURL] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:28]];
    }
}

#ifndef NSEventTypeSwipe
#define NSEventTypeSwipe 31
#endif

- (void)didSwipeWindowWithEvent:(NSNotification *)noti;
{
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
		// TODO(pinkerton): figure out page-up, http://crbug.com/16305
        
        NSLog(@"");
	}
	else if ([event deltaY] < -0.5)
	{
		// TODO(pinkerton): figure out page-down, http://crbug.com/16305
	}
}

/*

- (void)swipeWithEvent:(NSEvent *)event
{
	if ([event type] == NSEventTypeSwipe) {
		CGFloat deltaX = [event deltaX];
		if (deltaX < 0) {
            NSLog(@"Next");
			//[_controller clickedNext:nil];
		} else if (deltaX > 0) {
            NSLog(@"Back");
			//[_controller clickedPrevious:nil];
		}
	}
}
 */

@end
