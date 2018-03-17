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
    
//    @IBOutlet weak var sync: NSMenuItem!
    
    @IBOutlet weak var loginLogout: NSMenuItem!

//    @IBOutlet weak var recordMenuView: NSView!

    @IBOutlet weak var recordTitle: NSTextField!

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
        self.recordAudio.title = "Capture Audio                              🔴"
//        self.recordAudio.onStateImage = #imageLiteral(resourceName: "record")
        self.recordAudio.offStateImage = #imageLiteral(resourceName: "record")
//        self.recordAudio.mixedStateImage = #imageLiteral(resourceName: "record")
//        let statusItemView = StatusItemView.init(frame: NSRect.init(x: 0, y: 0, width: 200, height: 50))
//
////        statusItemView.statusItem = self.recordAudio
////        statusItemView.menu = menu
//        statusItemView.toolTip = NSLocalizedString("Menubar Countdown", comment: "Status Item Tooltip")
//        recordAudio.view = statusItemView
//        statusItemView.title = "00:00:00"

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
            loginLogout.title = "Logout, \(PreferencesStore.sharedInstance.user.firstName ?? "")"
        }
        else{
            loginLogout.title = "Login"
        }
    }
    
    @IBAction func didClickRecordAudio(_ sender: Any?) {
        let isRecording = recordingController.isRecording();
        print(isRecording)
        if (isRecording){
            (NSApp.delegate as? AppDelegate)?.setupMenuForNormal();
            recordingController.stopRecording()
            recordTitle.stringValue = "Capture Audio"

        }
        else{
            (NSApp.delegate as? AppDelegate)?.setupMenuForRecording();
            recordingController.createRecorderFromMix()
            recordingController.startRecording()
            recordTitle.stringValue = "Stop Recording"
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
    
    @IBAction func didClickShowInFinder(_ sender: NSMenuItem) {
        var path:String?
        switch sender.tag {
        case 1:
            print("Captures")
            path = RecordingStoreManager.capturesRootPath()

        default:
            print("Sync")
            path = RecordingStoreManager.syncRootPath()

        }
        func showError() {
            let alert = NSAlert()
            alert.messageText = "Error"
            alert.informativeText = "Sorry, the document couldn't be shown in the Finder."
            alert.runModal()
        }
        
        // if the path isn't known, then show an error
        guard path != nil else {
            showError()
            return
        }
        
        // try to select the file in the Finder
        let workspace = NSWorkspace.shared
        let selected = workspace.selectFile(path!, inFileViewerRootedAtPath: "")
        if !selected {
            showError()
        }
        
    }
    
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
//        sync.submenu?.removeAllItems();
//
//        for path in RecordingStoreManager.syncFiles() {
//            if path == ".DS_Store"
//            {
//                continue
//            }
//            let item = NSMenuItem.init()
////            let field = CaptureTextField(withFilePath:path)
////            //            field.stringValue = path
////            field.backgroundColor = NSColor.clear
////            field.drawsBackground = true
////            item.view = field
////
////            sync.submenu?.addItem(item)
////
//            sync.submenu?.addItem(withTitle: path, action: nil, keyEquivalent: "")
//        }
    }
    
    
    func updateRecordingRelatedMenu() {

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
        let isRecording = recordingController.isRecording();
        print(isRecording)
        if (isRecording == false){
            syncFilesManager.checkAndSyncFiles()
            syncRecordingManager.checkAndSyncFiles()
            updateSyncRelatedMenu()
        }
//        self.updateMenuWithCurrentStatus()
    }
    
    public func menuDidClose(_ menu: NSMenu){
        print("menuDidClose")
        
    }
    
}
