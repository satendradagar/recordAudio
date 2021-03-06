//
//  StatusItemView.m
//  Hello Demo
//
//  Created by Satendra Dagar on 15/03/18.
//  Copyright © 2018 CB. All rights reserved.
//

#import "StatusItemView.h"
#define StatusItemViewPaddingWidth  6
#define StatusItemViewPaddingHeight 3

@implementation StatusItemView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        statusItem = nil;
        title = @"";
        isMenuVisible = NO;
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    // Draw status bar background, highlighted if menu is showing
    [statusItem drawStatusBarBackgroundInRect:[self bounds]
                                withHighlight:isMenuVisible];
    
    // Draw title string
    NSPoint origin = NSMakePoint(StatusItemViewPaddingWidth,
                                 StatusItemViewPaddingHeight);
    [title drawAtPoint:origin
        withAttributes:[self titleAttributes]];
    [super drawRect:dirtyRect];
    // Drawing code here.
}

- (void)mouseDown:(NSEvent *)event {
    [[self menu] setDelegate:self];
    [statusItem popUpStatusItemMenu:[self menu]];
    [self setNeedsDisplay:YES];
}

- (void)rightMouseDown:(NSEvent *)event {
    // Treat right-click just like left-click
    [self mouseDown:event];
}

- (void)menuWillOpen:(NSMenu *)menu {
    isMenuVisible = YES;
    [self setNeedsDisplay:YES];
}

- (void)menuDidClose:(NSMenu *)menu {
    isMenuVisible = NO;
    [menu setDelegate:nil];
    [self setNeedsDisplay:YES];
}

- (NSColor*)titleForegroundColor {
    if (isMenuVisible) {
        return [NSColor whiteColor];
    }
    else {
        return [NSColor blackColor];
    }
}

- (NSDictionary *)titleAttributes {
    // Use default menu bar font size
    NSFont *font = [NSFont menuBarFontOfSize:0];
    
    NSColor *foregroundColor = [self titleForegroundColor];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            font,            NSFontAttributeName,
            foregroundColor, NSForegroundColorAttributeName,
            nil];
}

- (NSRect)titleBoundingRect {
    return [title boundingRectWithSize:NSMakeSize(1e100, 1e100)
                               options:0
                            attributes:[self titleAttributes]];
}

@end
