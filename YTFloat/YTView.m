//
//  YTView.m
//  YTFloat
//
//  Created by Tim Desir on 6/29/14.
//  Copyright (c) 2014 Tim D. All rights reserved.
//

#import "YTView.h"

@implementation YTView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    [[NSColor blackColor] setFill];
    
    NSRectFill(dirtyRect);
}

@end
