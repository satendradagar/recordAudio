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

    @IBOutlet weak var label: NSTextField!
    
    var trackingArea: NSTrackingArea?
    var isMouseInside = false
    var highlightColor :NSColor?
    {
        didSet{
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib();
//        normalColor = NSColor.clear
        self.highlightColor = NSColor.init(red: 65.0/255, green: 149/255.0, blue: 250/255.0, alpha: 1.0)
//        self.wantsLayer = true
//        self.layer?.isOpaque = true
    }
    
    var normalColor :NSColor? = NSColor.clear{
        didSet{
//            layer?.backgroundColor = normalColor?.cgColor
//            layer?.borderColor = normalColor?.cgColor
            self.label.backgroundColor = normalColor
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
//        layer?.backgroundColor = highlightColor?.cgColor
//        layer?.borderColor = highlightColor?.cgColor
//        layer?.borderWidth = 1.0
//        layer?.cornerRadius = 2.0
        self.label.backgroundColor = highlightColor

    }
    
    override func mouseExited(with event: NSEvent) {
        isMouseInside = false
        print(#function)
//        layer?.backgroundColor = normalColor?.cgColor
//        layer?.borderColor = normalColor?.cgColor
//        layer?.borderWidth = 1.0
//        layer?.cornerRadius = 2.0
        self.label.backgroundColor = normalColor


    }
}
