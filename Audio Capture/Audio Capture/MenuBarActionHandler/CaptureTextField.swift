//
//  CaptureTextField.swift
//  Audio Capture
//
//  Created by Satendra Dagar on 12/01/18.
//  Copyright © 2018 CB. All rights reserved.
//

import Foundation
import Cocoa


class CaptureTextField: NSTextField {
    
    var oldPath: String = ""
    
    convenience init(withFilePath path:String) {
        self.init(frame: NSRect(x: 0, y: 0, width: 220, height: 24.0))
        self.oldPath = path.fileName()
        self.stringValue = path.fileName()
    }
    
    override func controlTextDidEndEditing(_ obj: Notification) {
        if let sender = obj.object as? NSTextField {
//            resultLabel.stringValue = sender.stringValue
        }
    }
    override func textShouldBeginEditing(_ textObject: NSText) -> Bool {

        return true
    }
    override func textShouldEndEditing(_ textObject: NSText) -> Bool{
        
        let recordingPath = RecordingStoreManager.capturesRootPath()
        
        let oldPath = (recordingPath + "/" + self.oldPath).fileUrlWithExtension(fileExtension: captureExtension)
        let newPath = (recordingPath + "/" + self.stringValue).fileUrlWithExtension(fileExtension: captureExtension)

      return  NSUtilities.moveFile(pre: oldPath, move: newPath)
    }
    
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
       
        return true
    }
}
