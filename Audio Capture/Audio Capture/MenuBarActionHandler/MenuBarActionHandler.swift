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

    @IBOutlet weak var inboxMenu: NSMenuItem!

    @IBOutlet weak var favourites: NSMenuItem!
    
    @IBOutlet weak var sync: NSMenuItem!
    
    @IBOutlet weak var loginLogout: NSMenuItem!

    var recordingController = AVAudioRecordingController()
    var syncFilesManager = SyncFileManager()
    var syncRecordingManager = RecordSyncFileManager()

    var loginController: MusicLoginController?
    var favouriteList: [FavouriteItem]?
    var inboxList: [MusicItem]?
    var playerController = MiniAudioPlayerController.instance()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
        self.updateFileRelatedMenu()
        FavouriteListUpdater.updateFavouriteItemList()
        InboxListUpdater.updateInboxItemList()
        reloadFavouriteWithStore()
        reloadInboxWithStore()
        reloadLoginWithStore()
    }
    
    func reloadFavouriteWithStore()  {
        
        self.favouriteList = FavouriteListUpdater.getUpdatedFavouriteItems()
        
//        favourites.submenu?.removeAllItems();
        
//        if let list = self.favouriteList {
//
//            for item in list {
//                favourites.submenu?.addItem(withTitle: item.title ?? ""  , action: nil, keyEquivalent: "")
//            }
//        }
    }
    
    func reloadInboxWithStore()  {
        
        self.inboxList = InboxListUpdater.getUpdatedInboxItems()
        
//        inboxMenu.submenu?.removeAllItems();
//
//        if let list = self.inboxList {
//
//            for item in list {
//                inboxMenu.submenu?.addItem(withTitle: item.title ?? ""  , action: nil, keyEquivalent: "")
//            }
//        }
    }


    func reloadLoginWithStore()  {
        //Setup login
        if PreferencesStore.sharedInstance.user.isLogin {
            loginLogout.title = "Logout(\(PreferencesStore.sharedInstance.user.firstName ?? ""))"
        }
        else{
            loginLogout.title = "Login"
        }
    }
    
    @IBAction func didClickRecordAudio(_ sender: NSMenuItem) {

        if (recordingController.isRecording()){
            (NSApp.delegate as? AppDelegate)?.setupMenuForNormal();
            recordingController.recorder?.stop()
            recordAudio.title = "Capture Audio"

        }
        else{
            (NSApp.delegate as? AppDelegate)?.setupMenuForRecording();
            recordingController.createRecorder()
            recordingController.recorder?.record()
            recordAudio.title = "Stop Recording"
            self.updateFileRelatedMenu()
        }
    }
    
    @IBAction func didClickPlayNext(_ sender: NSMenuItem) {
        playerController.window?.makeKeyAndOrderFront(sender)
       
        switch sender.tag {
        case 1:
            if let songs = inboxList {
                playerController.playerController.configureWithSongs(songs: songs)
            }
            
        case 2:
            if let songs = favouriteList {
                playerController.playerController.configureWithSongs(songs: songs)
            }
            
        case 3:
            
            if let songs = RecordingStoreManager.getRecordingMusicItem() {
                playerController.playerController.configureWithSongs(songs: songs)
            }
            
        default:
            print("Default")
        }
    }

    @IBAction func showLoginPopupDidClicked(_ sender: Any) {
        if false == PreferencesStore.sharedInstance.user.isLogin {
            
            loginController = MusicLoginController.init(nibName: "MusicLoginController", bundle: Bundle.main, popOverDismissHandler: { () -> Bool in
                
                (NSApp.delegate as? AppDelegate)?.setupMenuWithMainMenu()
                self.loginController?.loginPopover.performClose(nil)
                self.reloadFavouriteWithStore()
                self.reloadInboxWithStore()
                self.reloadLoginWithStore()

                return true
            });
            loginController?.statusItem = (NSApp.delegate as? AppDelegate)?.statusItem
            (NSApp.delegate as? AppDelegate)?.setupMenuWithButton()
            
            loginController?.showPopover()
            
        }
        else{
            PreferencesStore.sharedInstance.logoutUser()
            self.reloadLoginWithStore()

        }

        }
//            (NSApp.delegate as? AppDelegate)?.setupMenuWithButton()
//            loginViewController.showPopover()

    @IBAction func didClickQuitApp(_ sender: NSMenuItem) {
        NSApp.terminate(sender)
    }
    
    
    func updateFileRelatedMenu() {
        myCaptures.submenu?.removeAllItems();

        for path in RecordingStoreManager.capturedFiles().reversed() {
            if path == ".DS_Store"
            {
                continue
            }
            let item = NSMenuItem.init()
            let field = CaptureTextField(withFilePath:path)
//            field.stringValue = path
            field.backgroundColor = NSColor.clear
            field.drawsBackground = true
            item.view = field
            
            myCaptures.submenu?.addItem(item)

//            myCaptures.submenu?.addItem(withTitle: path, action: nil, keyEquivalent: "")
        }
    }
    
    func updateSyncRelatedMenu() {
        sync.submenu?.removeAllItems();
        
        for path in RecordingStoreManager.syncFiles() {
            if path == ".DS_Store"
            {
                continue
            }
            let item = NSMenuItem.init()
//            let field = CaptureTextField(withFilePath:path)
//            //            field.stringValue = path
//            field.backgroundColor = NSColor.clear
//            field.drawsBackground = true
//            item.view = field
//
//            sync.submenu?.addItem(item)
//
            sync.submenu?.addItem(withTitle: path, action: nil, keyEquivalent: "")
        }
    }
}

extension MenuBarActionHandler : NSMenuDelegate {
    
    public func menuWillOpen(_ menu: NSMenu){
        print("menuWillOpen")
        syncFilesManager.checkAndSyncFiles()
        syncRecordingManager.checkAndSyncFiles()
        
        NSApp.activate(ignoringOtherApps: true)
        updateSyncRelatedMenu()
//        self.updateMenuWithCurrentStatus()
    }
    
    public func menuDidClose(_ menu: NSMenu){
        print("menuDidClose")
        
    }
    
}
