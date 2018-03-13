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
        let recordingRootPath = firstPath+"/Hello Demo"
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
        let filePath = syncRootPath() + "/\(fileName)"
        return filePath
    }
    
    static func recordingRootFilePathFor(_ fileName:String) -> String  {
        let filePath = capturesRootPath() + "/\(fileName)"
        return filePath
    }

    static func favouriteRootPath() -> String  {
        let capturesPath = recordingsRootPath() + "/Favourite"
        FileManager.checkAndCreateDirectoryIfNeeded(path: capturesPath)
        return capturesPath
    }

    static func capturedFiles() -> [String]{
        var paths = [String]();
        let directory = NSURL.fileURL(withPath: capturesRootPath())
        if let urlArray = try? FileManager.default.contentsOfDirectory(at: directory,
                                                                       includingPropertiesForKeys: [.contentModificationDateKey],
                                                                       options:.skipsHiddenFiles) {
            
            paths = urlArray.map { url in
                (url.lastPathComponent, (try? url.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? Date.distantPast)
                }
                .sorted(by: { $0.1 > $1.1 }) // sort descending modification dates
                .map { $0.0 } // extract file names
            
        } else {
            print("Content could not be loaded");
        }
        return paths

//        do {
//            paths = try FileManager.default.contentsOfDirectory(atPath:capturesRootPath())
//        } catch {
//            print(error)
//        }
//        return paths
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
    
    static func getRecordingMusicItem()  -> [MusicItem]?{
        
        let list = RecordingStoreManager.capturedFiles()
        var items = [MusicItem]()
        for item in list{
            if item == ".DS_Store"
            {
                continue
            }
            let filepath = RecordingStoreManager.recordingRootFilePathFor(item)
            if let fav = FavouriteItem(with: ["music_url":filepath]){
                items.append(fav)
            }
        }
        return items;
    }

}
