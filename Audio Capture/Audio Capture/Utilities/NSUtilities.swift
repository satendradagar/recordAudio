//
//  NSUtilities.swift
//  AdvancedCalendar
//
//  Created by Satendra Dagar on 16/12/17.
//  Copyright © 2017 Satendra Singh. All rights reserved.
//

import Foundation
import Cocoa

let captureExtension = "wav"

class NSUtilities: NSObject {

   static func dialogOKCancel(question: String, text: String) -> Bool {
        let alert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = NSAlert.Style.warning
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        return alert.runModal() == NSApplication.ModalResponse.alertFirstButtonReturn
    }
    static func dialogOK(question: String, text: String) -> Bool {
        let alert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = NSAlert.Style.warning
        alert.addButton(withTitle: "OK")
        return alert.runModal() == NSApplication.ModalResponse.alertFirstButtonReturn
    }
    
    static func moveFile(pre: URL, move: URL) -> Bool {
        do {

            try FileManager.default.moveItem(at: pre , to: move)
            return true
        } catch {
                print("\(error)")
            
            return false
        }
    }

}

extension String {
    
    func fileName() -> String {
        
        let filename: NSString = self as NSString
        let pathPrefix = filename.deletingPathExtension
        return pathPrefix
    }
    
    func fileExtension() -> String {
        
        let filename: NSString = self as NSString
        let pathExtention = filename.pathExtension
        return pathExtention
    }
    
    
    func fileUrlWithExtension(fileExtension ext:String) -> URL {
        
        if let fileNameWithoutExtension = NSURL(fileURLWithPath: self).appendingPathExtension(ext) {
            return fileNameWithoutExtension
        } else {
            return NSURL.fileURL(withPath: "/")
        }
    }
}
