//
//  ScrollingTextView.h
//  Hello Demo
//
//  Created by Satendra Dagar on 22/03/18.
//  Copyright © 2018 CB. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ScrollingTextView : NSView
{
    NSTimer * scroller;
    NSPoint point;
    CGFloat stringWidth;
}

@property (nonatomic, copy) NSString * text;
@property (nonatomic) NSTimeInterval speed;

@end
