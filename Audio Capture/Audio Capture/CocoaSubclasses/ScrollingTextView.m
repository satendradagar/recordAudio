//
//  ScrollingTextView.m
//  Hello Demo
//
//  Created by Satendra Dagar on 22/03/18.
//  Copyright © 2018 CB. All rights reserved.
//

#import "ScrollingTextView.h"

@implementation ScrollingTextView
{
    NSDictionary *attributes;
    BOOL isSmallText;
}

-(instancetype)init{
    self = [super init];
    if(self){
    }
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.alignment                = NSTextAlignmentCenter;
    
    attributes = [NSDictionary dictionaryWithObjects:
                  @[[NSFont systemFontOfSize:13.0], [NSColor whiteColor],paragraphStyle]
                                             forKeys:
                  @[NSFontAttributeName, NSForegroundColorAttributeName,NSParagraphStyleAttributeName]];
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.alignment                = NSTextAlignmentCenter;

    attributes = [NSDictionary dictionaryWithObjects:
                  @[[NSFont systemFontOfSize:13.0], [NSColor whiteColor],paragraphStyle]
                                             forKeys:
                  @[NSFontAttributeName, NSForegroundColorAttributeName,NSParagraphStyleAttributeName]];
    

}

-(void) setText:(NSString *)newText {
//    attributes = [NSDictionary dictionaryWithObjects:
//                  @[[NSFont systemFontOfSize:13.0], [NSColor whiteColor]]
//                                             forKeys:
//                  @[NSFontAttributeName, NSForegroundColorAttributeName]];
//
    stringWidth = [newText sizeWithAttributes:attributes].width;
    _text = [newText copy];
    point = NSZeroPoint;
    [scroller invalidate];
    scroller = nil;
    if (scroller == nil && _speed > 0 && _text != nil && stringWidth > self.frame.size.width) {
        isSmallText = NO;
        scroller = [NSTimer scheduledTimerWithTimeInterval:_speed target:self selector:@selector(moveText:) userInfo:nil repeats:YES];
    }
    else{
        isSmallText = YES;

    }
}

- (void) setSpeed:(NSTimeInterval)newSpeed {
    if (newSpeed != _speed) {
        _speed = newSpeed;
        
        [scroller invalidate];
        scroller = nil;
        if (_speed > 0 && _text != nil && stringWidth > self.frame.size.width) {
            scroller = [NSTimer scheduledTimerWithTimeInterval:_speed target:self selector:@selector(moveText:) userInfo:nil repeats:YES];
        }
    }
}

- (void) moveText:(NSTimer *)timer {
    point.x = point.x - 1.0f;
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    // Drawing code here.
    if (isSmallText) {
        [_text drawInRect:dirtyRect withAttributes:attributes];
    }
    else{
        if (point.x + stringWidth < 0) {
            point.x += dirtyRect.size.width;
        }
        
        if (point.x < 0) {
            NSPoint otherPoint = point;
            otherPoint.x += dirtyRect.size.width - 100;
            [_text drawAtPoint:otherPoint withAttributes:attributes];
        }
        else{
            [_text drawAtPoint:point withAttributes:attributes];
        }

    }
}

@end
