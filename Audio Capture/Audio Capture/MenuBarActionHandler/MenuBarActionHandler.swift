//
//  MenuBarActionHandler.swift
//  Audio Capture
//
//  Created by Satendra Dagar on 28/12/17.
//  Copyright © 2017 CB. All rights reserved.
//

import Foundation
import Cocoa

class MenuBarActionHandler: NSMenu {
    
    @IBOutlet weak var recordAudio: NSMenuItem!
    
    @IBOutlet weak var playNext: NSMenuItem!
    
    @IBOutlet weak var myCaptures: NSMenuItem!
    
    @IBOutlet weak var favourites: NSMenuItem!
    
    @IBOutlet weak var sync: NSMenuItem!
    
    var recordingController = AVAudioRecordingController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.updateFileRelatedMenu()
    }
    @IBAction func didClickRecordAudio(_ sender: NSMenuItem) {
        
        if (recordingController.isRecording()){
            recordingController.recorder?.stop()
            recordAudio.title = "Record Audio"

        }
        else{
            recordingController.createRecorder()
            recordingController.recorder?.record()
            recordAudio.title = "Stop Recording"
            self.updateFileRelatedMenu()
        }
    }
    
    @IBAction func didClickPlayNext(_ sender: NSMenuItem) {
        
    }

    
    @IBAction func didClickQuitApp(_ sender: NSMenuItem) {
        NSApp.terminate(sender)
    }
    
    func updateFileRelatedMenu() {
        myCaptures.submenu?.removeAllItems();
        for path in RecordingStoreManager.capturedFiles() {
            myCaptures.submenu?.addItem(withTitle: path, action: nil, keyEquivalent: "")
        }
    }
}
