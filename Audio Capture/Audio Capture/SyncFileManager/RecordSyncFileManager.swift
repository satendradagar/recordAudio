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

}
