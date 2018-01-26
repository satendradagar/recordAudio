//
//  SyncFileManager.swift
//  Hello Demo
//
//  Created by Satendra Dagar on 16/01/18.
//  Copyright © 2018 CB. All rights reserved.
//

import Foundation

let statusKey = "F_Status"
let pathKey = "F_Path"

enum FileStatus:String {
    case notSynced
    case uploading
    case uploaded
    case failed
}

class SyncFile: NSObject {
    var fileName: String!
    var uploadStatus = FileStatus.notSynced

    init(name:String) {
        fileName = name
        if let dict = PreferencesStore.sharedInstance.syncFileForPath(path: fileName){
            uploadStatus = FileStatus.init(rawValue: dict[statusKey] as? String ?? FileStatus.notSynced.rawValue)!
        }
    }
    
    func saveStatus()  {
        let dict = [statusKey:uploadStatus.rawValue, pathKey: fileName]
        PreferencesStore.sharedInstance.updateSyncFile(fileProperties: dict , forPath: fileName)
    }
    
    func checkAnduploadFileToServer(completion:((_ filePath:String) -> Void)) {
        
    }
    
}

class SyncFileManager: NSObject {
    
    var files = [SyncFile]()
    
    static let shared = SyncFileManager()
    
   override init() {
//        let files = RecordingStoreManager.syncFiles()
    }
    
    func checkAndSyncFiles() {
        let files = RecordingStoreManager.syncFiles()
        var filesToSync = [SyncFile]()
        
        for file in files {
            let syncFile = SyncFile.init(name: file)
            filesToSync.append(syncFile)
        }
        self.files = filesToSync
    }
    
    deinit {
        
    }
}
