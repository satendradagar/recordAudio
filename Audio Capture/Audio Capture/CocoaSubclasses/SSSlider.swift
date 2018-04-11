//
//  SSSlider.swift
//  Hello Demo
//
//  Created by Satendra Singh on 17/02/18.
//  Copyright © 2018 CB. All rights reserved.
//

import Foundation
import Cocoa

class SSSliderCell: NSSliderCell {
    @IBInspectable var backgroundColor:NSColor?
    
//    override func draw(_ dirtyRect: NSRect) {
//
//        if (backgroundColor != nil) {
//
//            self.backgroundColor?.setFill();
//            __NSRectFill(dirtyRect);
//
//        }
//        super.draw(dirtyRect);
//    }

//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//
    override func drawBar(inside aRect: NSRect, flipped: Bool) {
        var rect = aRect
//        rect.size.height = CGFloat(5)
        let barRadius = CGFloat(2.5)
        let value = CGFloat((self.doubleValue - self.minValue) / (self.maxValue - self.minValue))
        let finalWidth = CGFloat(value * (self.controlView!.frame.size.height))
        var leftRect = rect
        leftRect.size.height = self.controlView!.frame.size.height - finalWidth - 8
        let bg = NSBezierPath(roundedRect: rect, xRadius: barRadius, yRadius: barRadius)
        NSColor.black.setFill()
        bg.fill()
        let active = NSBezierPath(roundedRect: leftRect, xRadius: barRadius, yRadius: barRadius)
        NSColor.gray.setFill()
        active.fill()
    }
//
}

class SSSlider: NSSlider { 
    
    var isUserDragging = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.clear.cgColor
    }
    override func mouseDown(with event: NSEvent) {
        print("mouseDown")
        isUserDragging = true
        super.mouseDown(with: event)
    }
    
    override func mouseUp(with event: NSEvent) {
        print("mouseUp")
        super.mouseUp(with: event)

        isUserDragging = false

    }
//    - (void)mouseDown:(NSEvent *)theEvent
//    {
//    NSLog("@mouse down");
//    [super mouseDown: theEvent];
//    }
//
//    - (void) mouseUp: (NSEvent *)theEvent
//    {
//    NSLog("@mouse up");
//    [super mouseUp: theEvent];
//    }

}
