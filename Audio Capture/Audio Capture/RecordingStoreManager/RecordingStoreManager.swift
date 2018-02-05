//
//  RecordingStoreManager.swift
//  Audio Capture
//
//  Created by Satendra Dagar on 28/12/17.
//  Copyright © 2017 CB. All rights reserved.
//

import Foundation
import Cocoa

class RecordingStoreManager: NSObject {

//    func nextAudioFilePath()  -> NSURL {
    //        let currentDate = NSDate()
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "dd-MM-yy HHmmss"
//    let fileName = "Recording on " + dateFormatter.string(from: currentDate as Date) + ".caf"
//
//    let filePaths = NSSearchPathForDirectoriesInDomains(.musicDirectory, .userDomainMask, true)
//    let firstPath = filePaths[0]
//    let recordingRootPath = firstPath+"Recordings"
//    do {
//    try FileManager.default.createDirectory(atPath: recordingRootPath, withIntermediateDirectories: true, attributes: nil)
//    } catch {
//    print(error)
//    }
//    let url = NSURL(fileURLWithPath: recordingPath)
//    return url
//        NSURL.init(fileURLWithPath: <#T##String#>, isDirectory: <#T##Bool#>)
//    }

    static func recordingsRootPath()  -> String {
        let filePaths = NSSearchPathForDirectoriesInDomains(.musicDirectory, .userDomainMask, true)
        let firstPath = filePaths[0]
        let recordingRootPath = firstPath+"/Recordings"
        return recordingRootPath
    }
    
   static func capturesRootPath() -> String  {
        let capturesPath = recordingsRootPath() + "/Captures"
        FileManager.checkAndCreateDirectoryIfNeeded(path: capturesPath)
        return capturesPath
    }
    
    static func syncRootPath() -> String  {
        let capturesPath = recordingsRootPath() + "/Sync"
        FileManager.checkAndCreateDirectoryIfNeeded(path: capturesPath)
        return capturesPath
    }
    
    
    static func syncRootFilePathFor(_ fileName:String) -> String  {
        let filePath = syncRootPath() + "/\(fileName))"
        return filePath
    }
    
    static func favouriteRootPath() -> String  {
        let capturesPath = recordingsRootPath() + "/Favourite"
        FileManager.checkAndCreateDirectoryIfNeeded(path: capturesPath)
        return capturesPath
    }

    static func capturedFiles() -> [String]{
        var paths = [String]();
        do {
            paths = try FileManager.default.contentsOfDirectory(atPath:capturesRootPath())
        } catch {
            print(error)
        }
        return paths
    }
    
    static func syncFiles() -> [String]{
        var paths = [String]();
        do {
            paths = try FileManager.default.contentsOfDirectory(atPath:syncRootPath())
        } catch {
            print(error)
        }
        return paths
    }
//
//    func favouriteRootPath()  -> NSURL {
//
//    }
}
