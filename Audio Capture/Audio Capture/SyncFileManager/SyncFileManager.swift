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
    var isRecording = false
    var type = "capture"
    var timer: Timer?
    var iconState = false
    var animationCount = 0;
    
    init(name:String) {
        fileName = name
        if let dict = PreferencesStore.sharedInstance.syncFileForPath(path: fileName){
            uploadStatus = FileStatus.init(rawValue: dict[statusKey] as? String ?? FileStatus.notSynced.rawValue)!
        }
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let newObj = object as? SyncFile {
            if self.fileName == newObj.fileName {
                return true
            }
        }
        return false
    }
    
    func saveStatus()  {
        let dict = [statusKey:uploadStatus.rawValue, pathKey: fileName]
        PreferencesStore.sharedInstance.updateSyncFile(fileProperties: dict , forPath: fileName)
    }
    
    func checkAnduploadFileToServer(completion:@escaping ((_ filePath:String) -> Void)) {
        if uploadStatus != .uploaded && uploadStatus != .uploading{
            uploadStatus = .uploading
            print("status:\(uploadStatus),file:\(fileName)")
            var localPath = RecordingStoreManager.syncRootFilePathFor(fileName)
            if isRecording{
                localPath = RecordingStoreManager.recordingRootFilePathFor(fileName)
            }
            startTimer()
            FileUploader.uploadMediaAtPath(localPath,type: self.type, completion: { (path, status) in
                self.stopTimer()

                if (status == true){
                    self.uploadStatus = .uploaded
                    completion(self.fileName)
                }
                else if (status == false){
                    self.uploadStatus = .failed
//                    completion(self.fileName)
                }
                self.saveStatus()
            })
        }
        else{
            self.stopTimer()
            completion(self.fileName)
        }
    }
    
    func startTimer() {
        
        if timer == nil {
            animationCount = 0;
            timer = Timer.scheduledTimer(timeInterval: 1.0/16.0, target: self, selector: #selector(self.loop), userInfo: nil, repeats: true)
        }
    }
    
    func stopTimer() {

        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        (NSApp.delegate as? AppDelegate)?.setupMenuForNormal();

    }
    
    @objc func loop(timer:Timer) {
        //do something
        (NSApp.delegate as? AppDelegate)?.setupMenuImage(imageName: "status_blue\(animationCount)");

//        if iconState {
//            (NSApp.delegate as? AppDelegate)?.setupMenuImage(imageName: "status_blue");
//
//        }
//        else{
//            (NSApp.delegate as? AppDelegate)?.setupMenuImage(imageName: "status_white");
//        }
        animationCount = animationCount + 1
        animationCount = animationCount%16;
        
        iconState = !iconState
    }

    
}

class SyncFileManager: NSObject {
    
    var files = [SyncFile]()
    var syncIndex = 0
//    static let shared = SyncFileManager()

   override init() {
//        let files = RecordingStoreManager.syncFiles()
    }
    
    func filesToList() -> [String]  {
        return RecordingStoreManager.syncFiles()
    }
    
    func checkAndSyncFiles() {
        let recfiles = filesToList()
        var filesToSync = [SyncFile]()
        
        for file in recfiles {
            if file == ".DS_Store"
            {
                continue
            }
            let syncFile = SyncFile.init(name: file)
            syncFile.type = "sync"
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
    
    func performSyncWithServer() {
        
        syncIndex = syncIndex + 1
        if syncIndex < self.files.count {
        let file = self.files[syncIndex]
        file.checkAnduploadFileToServer(completion: { (filePath) in
            self.performSyncWithServer()
        })
        }

    }
    
    deinit {
        
    }
    
}
