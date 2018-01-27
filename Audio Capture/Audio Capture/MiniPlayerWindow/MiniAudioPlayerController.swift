//
//  MiniAudioPlayerController.swift
//  Hello Demo
//
//  Created by Satendra Dagar on 26/01/18.
//  Copyright © 2018 CB. All rights reserved.
//

import Foundation
import Cocoa

class MiniAudioPlayerController: NSWindowController {
    
    @IBOutlet weak var playerController: PlayerViewController!

//    var playerController:PlayerViewController
//    @IBOutlet weak var playerView: AVPlayerView!

    override func awakeFromNib() {
        super.awakeFromNib()
        if let controller = self.contentViewController as? PlayerViewController{
            playerController = controller
        }
//        let mediaPAth = "http://ec2-35-177-218-234.eu-west-2.compute.amazonaws.com/uploads/25352.wav"
////        self.playerView
//        let url = URL(string: mediaPAth)
//        let audioPlayer = AVPlayer(url: url!)
//        audioPlayer.play()
//        playerView.player = audioPlayer
//        
    }
   
    override func close() {
        
        super.close()
        
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(windowWillClose(_:)), name: NSWindow.willCloseNotification, object: nil)
    }
    
    @objc func windowWillClose(_ notification: Notification) {
        playerController.playerView.player?.pause()
    }

}
