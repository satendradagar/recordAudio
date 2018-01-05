//
//  CreateDirecotry.swift
//  Audio Capture
//
//  Created by Satendra Dagar on 02/01/18.
//  Copyright © 2018 CB. All rights reserved.
//

import Foundation

extension FileManager{
    
   static func checkAndCreateDirectoryIfNeeded(path:String) {
        var isDir : ObjCBool = false
        let fm = FileManager.default
        
        if fm.fileExists(atPath: path, isDirectory:&isDir) {
            print(isDir.boolValue ? "File exists" : "Directory exists")
        } else {
            
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
            print("File does not exist")
        }
        
    }
}
