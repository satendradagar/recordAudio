//
//  RecordSyncFileManager.swift
//  Hello Demo
//
//  Created by Satendra Dagar on 06/02/18.
//  Copyright © 2018 CB. All rights reserved.
//

import Foundation

class RecordSyncFileManager: SyncFileManager {
    
    override func filesToList() -> [String]  {
        return RecordingStoreManager.capturedFiles()
    }
    
    override func checkAndSyncFiles() {
        let recfiles = filesToList()
        var filesToSync = [SyncFile]()
        
        for file in recfiles {
            if file == ".DS_Store"
            {
                continue
            }
            let syncFile = SyncFile.init(name: file)
            syncFile.isRecording = true
            filesToSync.append(syncFile)
            
        }

        for newFile in filesToSync {
            var isMatchFound = false
            for oldFile in files{
                if newFile.isEqual(oldFile){
                    isMatchFound = true
                    break
                }
            }
            if isMatchFound == false{
                self.files.append(newFile)
            }
        }
//        self.files = filesToSync
        syncIndex = -1
        performSyncWithServer()
    }

}
