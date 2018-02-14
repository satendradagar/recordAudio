//
//  ViewController.swift
//  OSX Mini Audio Player
//
//  Created by Satendra Dagar on 07/02/18.
//  Copyright © 2018 CB. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let playerController = PlayerViewController.instance()
        let musicItem1 = MusicItem(with: ["music_url" : "/Users/satendrasingh/Desktop/Desktop/Songs/Punjabi/02. NAAM.mp3"])
        let musicItem2 = MusicItem(with: ["music_url" : "/Users/satendrasingh/Desktop/Desktop/Songs/Punjabi/02 TOUCH WOOD.mp3"])
        let musicItem3 = MusicItem(with: ["music_url" : "/Users/satendrasingh/Desktop/Desktop/Songs/Punjabi/01_O VEKHO.mp3"])
        let musicItem4 = MusicItem(with: ["music_url" : "/Users/satendrasingh/Desktop/Desktop/Songs/SONG/01.mp3","avatar" : "http://myanmareiti.org/sites/default/files/sample_0.jpg"])
        let musicItem5 = MusicItem(with: ["music_url" : "https://s3.amazonaws.com/kargopolov/kukushka.mp3"])
        let musicItem6 = MusicItem(with: ["music_url" : "http://ec2-35-177-218-234.eu-west-2.compute.amazonaws.com/uploads/95174.wav"])



        playerController.configureWithSongs(songs: [musicItem1!,musicItem2!,musicItem3!,musicItem4!,musicItem5!,musicItem6!])
        self.addSSChildViewController(child: playerController)
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

