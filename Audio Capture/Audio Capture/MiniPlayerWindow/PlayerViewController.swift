//
//  PlayerViewController.swift
//  Hello Demo
//
//  Created by Satendra Dagar on 26/01/18.
//  Copyright © 2018 CB. All rights reserved.
//

import Foundation
import AVFoundation
import AVKit
import Alamofire
import AlamofireImage

class PlayerViewController: NSViewController {

    @IBOutlet weak var playerView: AVPlayerView!
    @IBOutlet weak var songTitle: NSTextField!
    @IBOutlet weak var backgroundImage: NSImageView!
    @IBOutlet weak var leftButton: NSButton!
    @IBOutlet weak var rightButton: NSButton!    
    var currentSongIndex = 0;
    var allSongs = [MusicItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let mediaPAth = "http://ec2-35-177-218-234.eu-west-2.compute.amazonaws.com/uploads/95174.wav"
//        //        self.playerView
//        let url = URL(string: mediaPAth)
//        let audioPlayer = AVPlayer(url: url!)
//        playerView.player = audioPlayer
//
//        audioPlayer.play()

    }
    
    func configureWithSongs(songs:[MusicItem])  {

        allSongs = songs
        currentSongIndex = 0
        configureSongWith(song: currentSongIndex)
    }
    
    @IBAction func didClickPlayNext(_ sender: NSButton) {
        currentSongIndex = currentSongIndex + 1
        configureSongWith(song: currentSongIndex)

    }

    
    @IBAction func didClickPlayPrevious(_ sender: NSButton) {
        currentSongIndex = currentSongIndex - 1
        configureSongWith(song: currentSongIndex)

    }

    func configureSongWith(song: Int)  {
        leftButton.isEnabled = true
        rightButton.isEnabled = true

        if currentSongIndex >= allSongs.count - 1  {
            rightButton.isEnabled = false
        }
        if currentSongIndex <= 0 {
            leftButton.isEnabled = false
        }
        if let player = playerView.player {
            player.pause()
        }
        
        let song = allSongs[song]
        let url = URL(string: song.url!)
        let audioPlayer = AVPlayer(url: url!)
        playerView.player = audioPlayer
        audioPlayer.play()

        self.songTitle.stringValue = song.title!
        self.backgroundImage.image = nil

        Alamofire.request(song.avatar!).responseImage { response in
            debugPrint(response)
            
            print(response.request)
            print(response.response)
            debugPrint(response.result)
            
            if let image = response.result.value {
                self.backgroundImage.image = image
                print("image downloaded: \(image)")
                
            }
        }
        
    }
}

