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
    var captureList: [MusicItem]?

    var playerController = MiniAudioPlayerController.instance()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
        self.updateFileRelatedMenu()
        FavouriteListUpdater.updateFavouriteItemList()
        InboxListUpdater.updateInboxItemList()
        CaptureListUpdater.updateCaptureItemList()
        reloadFavouriteWithStore()
        reloadInboxWithStore()
        reloadCaptureWithStore()
        reloadLoginWithStore()
        self.myCaptures.title = "Captures"
//        self.recordAudio.image = #imageLiteral(resourceName: "record")
        self.recordAudio.title = "Captures Audio 🔴"
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
    func reloadCaptureWithStore()  {
        
        self.captureList = CaptureListUpdater.getUpdatedCapturedItems()
        
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
            loginLogout.title = "Logout .. @\(PreferencesStore.sharedInstance.user.firstName ?? "")"
        }
        else{
            loginLogout.title = "Login"
        }
    }
    
    @IBAction func didClickRecordAudio(_ sender: NSMenuItem) {
        let isRecording = recordingController.isRecording();
        print(isRecording)
        if (isRecording){
            (NSApp.delegate as? AppDelegate)?.setupMenuForNormal();
            recordingController.stopRecording()
            recordAudio.title = "Capture Audio  🔴"

        }
        else{
            (NSApp.delegate as? AppDelegate)?.setupMenuForRecording();
            recordingController.createRecorderFromMix()
            recordingController.startRecording()
            recordAudio.title = "Stop Recording  🔴"
            self.updateFileRelatedMenu()
        }
    }
    
    @IBAction func didClickPlayNext(_ sender: NSMenuItem) {
        playerController.window?.makeKeyAndOrderFront(sender)
       
        switch sender.tag {
        case 1:
            if let songs = inboxList {
                if songs.count > 0{
                    playerController.playerController.configureWithSongs(songs: songs)
                }
                else{
                    NSApp.presentError(NSError.init(domain: "No song found to play", code: 0, userInfo: nil));
                }

            }
            
        case 2:
            if let songs = favouriteList {
                if songs.count > 0{
                    playerController.playerController.configureWithSongs(songs: songs)
                }
                else{
                    NSApp.presentError(NSError.init(domain: "No song found to play", code: 0, userInfo: nil));
                }

            }
            
        case 3:
            
//            if let songs = RecordingStoreManager.getRecordingMusicItem() {
            captureList = CaptureListUpdater.getUpdatedCapturedItems()
            if let songs = captureList {

                if songs.count > 0{
                    playerController.playerController.configureWithSongs(songs: songs)
                }
                else{
                    NSApp.presentError(NSError.init(domain: "No song found to play", code: 0, userInfo: nil));
                }
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
        for path in RecordingStoreManager.capturedFiles() {
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

    public func menu(_ menu: NSMenu, willHighlight item: NSMenuItem?)
    {
        print("\(item?.title)")
        if let strTitle = item?.title {
            if strTitle == "Captures"{

            }
        }
    }
    
    public func menuWillOpen(_ menu: NSMenu){
        print("menuWillOpen")
        if false == NSApp.isActive {
            let itms = menu.items
            menu.removeAllItems()
            print("Removed")
            NSApp.activate(ignoringOtherApps: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0001, execute: {
//                menu.items = items
                for item in itms{
                    menu.addItem(item)
                }
                print("ADDED")

                (NSApp.delegate as? AppDelegate)?.statusItem.popUpMenu(self);

            })
            
            //                    menu.setMenuBarVisible(visible:true)
        }

//        if false == NSApp.isActive {
//            NSApp.activate(ignoringOtherApps: true)
//        }

        syncFilesManager.checkAndSyncFiles()
        syncRecordingManager.checkAndSyncFiles()
        
        updateSyncRelatedMenu()
//        self.updateMenuWithCurrentStatus()
    }
    
    public func menuDidClose(_ menu: NSMenu){
        print("menuDidClose")
        
    }
    
}
