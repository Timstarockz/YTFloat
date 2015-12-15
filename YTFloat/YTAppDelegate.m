//
//  YTAppDelegate.m
//  YTFloat
//
//  Created by Tim Desir on 6/27/14.
//  Copyright (c) 2014 Tim D. All rights reserved.
//

#import "YTAppDelegate.h"

@implementation YTAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSLog(@"applicationDidFinishLaunching");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RevealWindow" object:nil];
    [[NSAppleEventManager sharedAppleEventManager] setEventHandler:self andSelector:@selector(handleURLEvent:withReplyEvent:) forEventClass:kInternetEventClass andEventID:kAEGetURL];
        
    [_window setAlphaValue:0.0];
    
    NSRect screen = [[NSScreen mainScreen] frame];
    [self.window setFrame:NSMakeRect(screen.size.width, 13, self.window.frame.size.width, self.window.frame.size.height) display:NO animate:NO];
    [_window setLevel:kCGDockWindowLevel];
    [_window setBackgroundColor:NSColor.windowBackgroundColor];//[NSColor colorWithDeviceRed:0.188 green:0.514 blue:0.984 alpha:1.000]];
}

- (void)handleURLEvent:(NSAppleEventDescriptor*)event withReplyEvent:(NSAppleEventDescriptor*)replyEvent {
    NSString* url = [[event paramDescriptorForKeyword:keyDirectObject] stringValue];
    url = [url stringByReplacingOccurrencesOfString:@"ytfloat://" withString:@""];
    NSURL *fullRL = [NSURL URLWithString:url];
    
    NSLog(@"%@",fullRL.query);
    NSLog(@"%@",fullRL.host);
    
    
    /// YouTube Link Parsing
    if ([fullRL.host isEqualToString:@"www.youtube.com"]) {
        NSLog(@"YouTube Link");
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        for (NSString *param in [fullRL.query componentsSeparatedByString:@"&"]) {
            NSArray *elts = [param componentsSeparatedByString:@"="];
            if([elts count] < 2) continue;
            [params setObject:[elts objectAtIndex:1] forKey:[elts objectAtIndex:0]];
        }
        
        NSString *finalURLString = [NSString stringWithFormat:@"https://www.youtube.com/v/%@?hl=en_US&amp;version=3&amp;autoplay=1&amp;color=white&amp;theme=light&amp;fs=0&amp;rel=0",[params objectForKey:@"v"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayAVideo" object:finalURLString];
    }
    
    /// Twitch Link Parsing
    if ([fullRL.host isEqualToString:@"www.twitch.tv"]) {
        NSLog(@"Twitch Link");
        
        NSString *twURL = [NSString stringWithFormat:@"%@/popout",url];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayAVideo" object:twURL];
    }
}


- (void)applicationDidBecomeActive:(NSNotification *)notification {
   
}

- (void)applicationDidResignActive:(NSNotification *)notification {
   
}

@end
