//
//  DoubleClickButton.swift
//  AdvancedCalendar
//
//  Created by Satendra Singh on 02/07/1939 Saka.
//  Copyright © 1939 Saka Artem Hruzd. All rights reserved.
//

import Foundation
import Cocoa

class DoubleActionButton: NSButton {

   open var doubleAction: Selector?

    override func mouseDown(with event: NSEvent) {
        
        if (event.clickCount == 2) {
//            performDoubleClickClick(self)
            if target != nil && doubleAction != nil && (target?.responds(to: doubleAction))!{
                target?.perform(doubleAction, with: self)
                
            }
        }
        else{
            super.mouseDown(with: event)
        }


    }
    
//    open func performDoubleClickClick(_ sender: Any?)
//    {
////        if target != nil && doubleAction != nil && (target?.responds(to: doubleAction))!{
////            target?.perform(doubleAction)
////        }
//
//    }

}
