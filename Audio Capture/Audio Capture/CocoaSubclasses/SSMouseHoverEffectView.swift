//
//  SSMouseHoverEffectView.swift
//  ThinPrint
//
//  Created by Satendra Singh on 08/03/18.
//  Copyright © 2018 TP. All rights reserved.
//

import Foundation
import Cocoa

class SSMouseHoverEffectView: NSView {

    var trackingArea: NSTrackingArea?
    var isMouseInside = false
    var highlightColor :NSColor?
    {
        didSet{
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib();
        self.normalColor = NSColor.clear
        self.highlightColor = NSColor.selectedMenuItemColor
        self.wantsLayer = true
    }
    
    var normalColor :NSColor?{
        didSet{
            layer?.backgroundColor = normalColor?.cgColor
            layer?.borderColor = normalColor?.cgColor
        }
    }

    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        ensureTrackingArea()
        if let tracking = trackingArea {
            if !trackingAreas.contains(tracking) {
                addTrackingArea(tracking)
            }
        }
    }
    
    func ensureTrackingArea() {
        if trackingArea == nil {
            trackingArea = NSTrackingArea(rect: NSZeroRect, options: [.inVisibleRect, .activeAlways, .mouseEnteredAndExited], owner: self, userInfo: nil)
        }
    }
    
    override func mouseEntered(with event: NSEvent) {
        isMouseInside = true
        print(#function)
        layer?.backgroundColor = highlightColor?.cgColor
        layer?.borderColor = highlightColor?.cgColor
//        layer?.borderWidth = 1.0
//        layer?.cornerRadius = 2.0
    }
    
    override func mouseExited(with event: NSEvent) {
        isMouseInside = false
        print(#function)
        layer?.backgroundColor = normalColor?.cgColor
        layer?.borderColor = normalColor?.cgColor
//        layer?.borderWidth = 1.0
//        layer?.cornerRadius = 2.0

    }
}
