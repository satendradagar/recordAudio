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

let volumeDefaultsKey = "soundVol"

class PlayerViewController: NSViewController {
  
//    @IBOutlet weak var progressBar: ProgressBar!
    @IBOutlet weak var playerSlider: SSSlider!
    @IBOutlet weak var playButton: NSButton!
    @IBOutlet weak var playerView: AVPlayerView!
    @IBOutlet weak var songTitle: NSTextField!
    @IBOutlet weak var artistTitle: NSTextField!

    @IBOutlet weak var backgroundImage: NSImageView!
    @IBOutlet weak var contentBackground: NSImageView!

    @IBOutlet weak var leftButton: NSButton!
    @IBOutlet weak var rightButton: NSButton!
    @IBOutlet weak var startTime: NSTextField!
    @IBOutlet weak var endTime: NSTextField!
    @IBOutlet weak var favouriteButton: NSButton!
    @IBOutlet weak var scrollingText:ScrollingTextView!
    @IBOutlet weak var soundButton: NSButton!
    @IBOutlet weak var soundView: NSView!
    var volumeController :VolumeController?
    
    var currentSongIndex = 0;
    var allSongs = [MusicItem]()
    var player = AVPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let mediaPAth = "http://ec2-35-177-218-234.eu-west-2.compute.amazonaws.com/uploads/95174.wav"
        currentSongIndex = 0
//        configureSongWith(songIndex: currentSongIndex)
        let vol = UserDefaults.standard.object(forKey:volumeDefaultsKey) as? Float
        if nil == vol {
            UserDefaults.standard.set(1.0, forKey: volumeDefaultsKey)
        }
        UserDefaults.standard.addObserver(self, forKeyPath: volumeDefaultsKey, options: .new, context: nil)
//        let marqueeView = ScrollingTextView.init(frame: NSRect.init(x: 0, y: 80, width: self.view.frame.size.width, height: 50.0))
        scrollingText.speed = 0.05
//        scrollingText.text = "http://ec2-35-177-218-234.eu-west-2.compute.amazonaws.com/uploads/95174.wav"
//        self.view.addSubview(marqueeView);

    }
    
    func configureWithSongs(songs:[MusicItem])  {
        
        currentSongIndex = 0
        allSongs = songs
        configureSongWith(songIndex: currentSongIndex)

    }
    
    @IBAction func didClickPlayNext(_ sender: NSButton) {
        currentSongIndex = currentSongIndex + 1
        configureSongWith(songIndex: currentSongIndex)

    }

    
    @IBAction func didClickPlayPrevious(_ sender: NSButton) {
        currentSongIndex = currentSongIndex - 1
        configureSongWith(songIndex: currentSongIndex)
    }

    @IBAction func didClickPlaySong(_ sender: NSButton) {
        if player.isPlaying == true {
            player.pause()
            playButton.image = #imageLiteral(resourceName: "Play-icon")
        } else {
            player.play()
            playButton.image = #imageLiteral(resourceName: "Pause-icon")
        }

//        configureSongWith(songIndex: currentSongIndex)
        
    }

    @IBAction func didClickMarkFavourite(_ sender: NSButton) {
        
        let song = allSongs[currentSongIndex]
        
        if let isfav = song.isFavourite{
            if isfav == true{
                return
            }
        }
        FavouriteListUpdater.markSongAsFavourite(songID: song.uploadID ?? "") { (dict, error) in
            self.favouriteButton.image = #imageLiteral(resourceName: "favSelected")

        }
    }

    @IBAction func sliderDidSlide(_ sender: SSSlider) {
        sender.isUserDragging = false
        self.player.seek(to: CMTime.init(seconds: self.playerSlider.doubleValue, preferredTimescale: 1)) { (isDone) in
            
        }
        print(sender.doubleValue)
    }
    
    func configureSongWith(songIndex: Int)  {
        player.pause()

        player = AVPlayer()
        
        setupPlayer()
        self.playButton.image = #imageLiteral(resourceName: "Pause-icon")

        self.startTime.stringValue = "--:--"
        self.endTime.stringValue = "--:--"
//        self.progressBar.progress = 0.0;
        self.playerSlider.doubleValue = 0.0
        leftButton.isEnabled = true
        rightButton.isEnabled = true

        if currentSongIndex >= allSongs.count - 1  {
            rightButton.isEnabled = false
        }
        if currentSongIndex <= 0 {
            leftButton.isEnabled = false
        }
        
        let song = allSongs[songIndex]
        
        let playerItem = song.playerItem()
        player.replaceCurrentItem(with: playerItem)
//        player = AVPlayer.init(url: song.audioUrl())
        player.play()
//        var rawFav = 0
        self.favouriteButton.image = #imageLiteral(resourceName: "favUnselected")

        self.favouriteButton.isEnabled = true
        if let isfav = song.isFavourite{
            if isfav == true{
//                rawFav = 1
                self.favouriteButton.image = #imageLiteral(resourceName: "favSelected")
            }
        }
        else{
        }
        
//        self.favouriteButton.state = NSControl.StateValue.init(rawFav)
//        self.songTitle.stringValue = song.title ?? (song.url ?? "Untitled")
        self.artistTitle.stringValue = song.artist ?? "No artist"
        scrollingText.text = song.title ?? (song.url ?? "Untitled")

        if let imgPath = song.avatar{
            Alamofire.request(imgPath).responseImage { response in
                debugPrint(response)
                
                print(response.request)
                print(response.response)
                debugPrint(response.result)
                
                if let image = response.result.value {
                    self.backgroundImage.image = image.crop(size: self.backgroundImage.bounds.size)
                    print("image downloaded: \(image)")
                    
                }
            }
        }

//        Alamofire.request(song.avatar!).responseImage { response in
//            debugPrint(response)
//
//            print(response.request)
//            print(response.response)
//            debugPrint(response.result)
//
//            if let image = response.result.value {
//                self.backgroundImage.image = image
//                print("image downloaded: \(image)")
//
//            }
//        }
        
    }
    
    func updateTime() {
        // Access current item
        if let currentItem = player.currentItem {
            // Get the current time in seconds
            let playhead = currentItem.currentTime().seconds
            let duration = currentItem.duration.seconds
            if false == self.playerSlider.isUserDragging{
                
                self.playerSlider.maxValue = duration
                self.playerSlider.doubleValue = playhead

            }
            if duration > 0.0{
//                self.progressBar.progress = CGFloat(playhead/duration)
                let durationLabel = formatTimeFor(seconds: duration)
                let playheadLabel = formatTimeFor(seconds: playhead)
                print("\(playheadLabel)-----\(durationLabel)")
                self.startTime.stringValue = playheadLabel
                self.endTime.stringValue = durationLabel
            }
            else
            {
                self.playerSlider.doubleValue = 0.0

//                self.progressBar.progress = 0.0;
            }
            // Format seconds for human readable string
        }
    }
    
    func setupPlayer()  {
        if let vol = UserDefaults.standard.object(forKey:volumeDefaultsKey) as? Float{
            player.volume = vol
        }
        let tm: CMTime = CMTimeMakeWithSeconds(0.1, Int32(Double(NSEC_PER_SEC)))
        player.addPeriodicTimeObserver(forInterval: tm, queue: DispatchQueue.main, using: {(_ time: CMTime) -> Void in
            let duration: Float64 = CMTimeGetSeconds((self.player.currentItem?.duration)!)
            let currentTime: Float64 = CMTimeGetSeconds(self.player.currentTime())
            let dmin: Float64 = duration / 60
            let dsec: Float64 = duration - (dmin * 60)
            let cmin: Float64 = currentTime / 60
            let csec: Float64 = currentTime - (cmin * 60)
//            if currentTime > 0.0 {
//                let time = String(format: "%02d:%02d/%02d:%02d", dmin, dsec, cmin, csec)
//                print(time)
//            }
            self.updateTime()
//            playProgress = currentTime / duration
//            self.needsDisplay = true
        })
        let selector = #selector(playerItemDidReachEnd(notification:))
        //wsnnn fix (https://github.com/gyetvan-andras/cocoa-waveform/issues/5#issuecomment-19802466)
        NotificationCenter.default.addObserver(self, selector:selector , name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)

    }
    
//wsnnn fix (https://github.com/gyetvan-andras/cocoa-waveform/issues/5#issuecomment-19802466)
    @objc func playerItemDidReachEnd(notification: Notification) {
        let p = notification.object as? AVPlayerItem
        p?.seek(to: kCMTimeZero, completionHandler: { (isSuccess) in
            
            self.playButton.image = #imageLiteral(resourceName: "Play-icon")

        })
//        p?.seek(to: kCMTimeZero)
        //set to 00:00
        player.pause()
    }

    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == volumeDefaultsKey {
            //Do something
            if let vol = UserDefaults.standard.object(forKey:volumeDefaultsKey) as? Float{
                print(vol)
                player.volume = vol
            }
        }
    }
    
    deinit {
        UserDefaults.standard.removeObserver(self, forKeyPath:volumeDefaultsKey)
    }
    
    @IBAction func didClickSound(_ sender: NSButton) {
        if nil == volumeController {
            
            volumeController = VolumeController.init(nibName: "VolumeController", bundle: Bundle.main, popOverDismissHandler: { (isClose,newVal) -> Bool in
                true
            })
            let view: NSView? = volumeController?.view

        }
        
        if (volumeController?.loginPopover.isShown)! {
            volumeController?.loginPopover.close()
        }
        else{
            volumeController?.loginPopover.show(relativeTo: sender.frame, of: self.view, preferredEdge: NSRectEdge.maxY)

        }
    }

}

extension MusicItem{
    
    func playerItem() -> AVPlayerItem? {
        
        let item = AVPlayerItem.init(url: audioUrl())
        return item;
    }
    
    func audioUrl() -> URL {
        
        if self.url!.hasPrefix("http") { // true
            
            if let mediaUrl = URL(string: self.url!){//Server file
                
                return mediaUrl;
            }
            else//Fallback
            {
                let mediaUrl = URL(fileURLWithPath: self.url!)//Local files
                return mediaUrl;
            }
        }
        else
        {
            let mediaUrl = URL(fileURLWithPath: self.url!)//Local files
            return mediaUrl;
        }
    }
}

func getHoursMinutesSecondsFrom(seconds: Double) -> (hours: Int, minutes: Int, seconds: Int) {
    let secs = Int(seconds)
    let hours = secs / 3600
    let minutes = (secs % 3600) / 60
    let seconds = (secs % 3600) % 60
    return (hours, minutes, seconds)
}

func formatTimeFor(seconds: Double) -> String {
    let result = getHoursMinutesSecondsFrom(seconds: seconds)
    let hoursString = "\(result.hours)"
    var minutesString = "\(result.minutes)"
    if minutesString.characters.count == 1 {
        minutesString = "0\(result.minutes)"
    }
    var secondsString = "\(result.seconds)"
    if secondsString.characters.count == 1 {
        secondsString = "0\(result.seconds)"
    }
    var time = "\(hoursString):"
    if result.hours >= 1 {
        time.append("\(minutesString):\(secondsString)")
    }
    else {
        time = "\(minutesString):\(secondsString)"
    }
    return time
}

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
