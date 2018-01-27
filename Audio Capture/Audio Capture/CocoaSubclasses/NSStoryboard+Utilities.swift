//
//  NSStoryboard+Utilities.swift
//  AJPlayerMac
//
//  Created by Satendra Singh on 31/10/17.
//  Copyright © 2017 geovision. All rights reserved.
//

import Foundation
import Cocoa

public  extension NSStoryboard {
    
    func initialViewController<ControllerType: Any>() -> ControllerType {
        return self.instantiateInitialController() as! ControllerType
    }
}

