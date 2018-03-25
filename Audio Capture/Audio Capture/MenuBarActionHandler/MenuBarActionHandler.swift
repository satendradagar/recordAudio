//
//  MenuBarActionHandler.swift
//  Audio Capture
//
//  Created by Satendra Dagar on 28/12/17.
//  Copyright © 2017 CB. All rights reserved.
//


import Foundation
import Cocoa

let  FFTViewControllerFFTWindowSize = 4096 as vDSP_Length;

class MenuBarActionHandler: NSMenu {
    
    var maxFrequency: Float?;

    var isRec = false
    
    @IBOutlet weak var recordAudio: NSMenuItem!
    
    @IBOutlet weak var playNext: NSMenuItem!
    
    @IBOutlet weak var myCaptures: NSMenuItem!

    @IBOutlet weak var inboxMenu: NSMenuItem!

    @IBOutlet weak var favourites: NSMenuItem!
    
//    @IBOutlet weak var sync: NSMenuItem!
    
    @IBOutlet weak var loginLogout: NSMenuItem!

//    @IBOutlet weak var recordMenuView: NSView!

    @IBOutlet weak var recordTitle: NSTextField!
    //
    // Used to calculate a rolling FFT of the incoming audio data.
    //
    var fft: EZAudioFFTRolling?
    //
    // A label used to display the maximum frequency (i.e. the frequency with
    // the highest energy) calculated from the FFT.
    //
    @IBOutlet weak var noteMenu: NSMenuItem!
    
    @IBOutlet weak var frequencyMenu: NSMenuItem!

    @IBOutlet  var noteView: NSView!
    
    @IBOutlet  var frequencyView: NSView!

    @IBOutlet weak var noteLabel: NSTextField!

    @IBOutlet weak var maxFrequencyLabel: NSTextField!
    
    //------------------------------------------------------------------------------
    //
    // Use a OpenGL based plot to visualize the data coming in
    //
    @IBOutlet weak var recordingAudioPlot: EZAudioPlotGL!
    //------------------------------------------------------------------------------
    
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
        self.myCaptures.isHidden = true
        noteMenu.isHidden = true
        frequencyMenu.isHidden = true
        noteMenu.view = nil
        frequencyMenu.view = nil

//        self.myCaptures.attributedTitle = self.attributedTitleWith(title: "Hello", subTitle: "New")
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
        configuureRecordingView()
        self.updateMenuBarTitleWith(note: "Hell", frequency: "Frequ")
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
            isRec = false
            recordingController.stopRecording()
            recordTitle.stringValue = "     Capture Audio"
            noteMenu.isHidden = true
            frequencyMenu.isHidden = true
            noteMenu.view = nil
            frequencyMenu.view = nil
            (NSApp.delegate as? AppDelegate)?.setupMenuForNormal();

        }
        else{
            isRec = true
            (NSApp.delegate as? AppDelegate)?.setupMenuForRecording();

//            recordingController.createRecorderFromMix()
            recordingController.recordManager.delegate = self;
            noteMenu.isHidden = false
            frequencyMenu.isHidden = false
            noteMenu.view = noteView
            frequencyMenu.view = frequencyView

            recordingController.startRecording()
            recordTitle.stringValue = "     Stop Recording"

            self.updateFileRelatedMenu()

        }
        self.cancelTracking()
    }
    
    @IBAction func didClickPlayNext(_ sender: NSMenuItem) {
        playerController.window?.makeKeyAndOrderFront(sender)
       
        switch sender.tag {
        case 1:
             reloadInboxWithStore()
            if let songs = inboxList {
                if songs.count > 0{
                    playerController.playerController.configureWithSongs(songs: songs)
                }
                else{
                    NSApp.presentError(NSError.init(domain: "No song found to play", code: 0, userInfo: nil));
                }

            }
            
        case 2:
            reloadFavouriteWithStore()
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

extension MenuBarActionHandler: RecordingManagerDelegate,EZAudioFFTDelegate {
    func configuureRecordingView() {
        
        recordingAudioPlot.color = NSColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        recordingAudioPlot.plotType = EZPlotType.rolling
        recordingAudioPlot.shouldFill = true
        recordingAudioPlot.shouldMirror = true
        self.recordingController.recordManager.delegate = self;
        // Create an instance of the EZAudioFFTRolling to keep a history of the incoming audio data and calculate the FFT.
        //
        //        EZAudioFFTRolling.init(windowSize: vDSP_Length, sampleRate: <#T##Float#>, delegate: <#T##EZAudioFFTDelegate!#>)
        fft = EZAudioFFTRolling.init(windowSize: FFTViewControllerFFTWindowSize, sampleRate: Float(recordingController.recordManager.microphone.audioStreamBasicDescription().mSampleRate), delegate: self)
    }

    //Hanlde recording delegates
    // MARK: - RecordingManagerDelegate
    func didStartRecordingToOutputFile(at outputURL: URL?) {
//        playButton.enabled = true
//        window.title = outputURL?.path
    }

    func didFinishRecordingToOutputFile(at outputURL: URL?) {
//        window.title = "RecordFile"
    }

    func updateAudioPlotBuffer(_ buffer: UnsafeMutablePointer<Float>?, withBufferSize bufferSize: UInt32) {
//        print(#function)
        self.recordingAudioPlot.updateBuffer(buffer, withBufferSize: bufferSize)
        //
        // Calculate the FFT, will trigger EZAudioFFTDelegate
        //
        fft?.computeFFT(withBuffer: buffer, withBufferSize: bufferSize)
//        playingAudioPlot.updateBuffer(buffer, withBufferSize: bufferSize)
    }
    
//    func recorderUpdatedCurrentTime(_ formattedCurrentTime: String?) {
//        if let aTime = formattedCurrentTime {
//            "\(currentTimeLabel)" = aTime
//        }
//    }
    //------------------------------------------------------------------------------
    // MARK: - EZAudioFFTDelegate
    //------------------------------------------------------------------------------
    func fft(_ fft: EZAudioFFT?, updatedWithFFTData fftData: UnsafeMutablePointer<Float>?, bufferSize: vDSP_Length) {
         maxFrequency = fft?.maxFrequency
        let noteName = EZAudioUtilities.noteNameString(forFrequency: maxFrequency!, includeOctave: true)
        DispatchQueue.main.async(execute: {() -> Void in
//            let text = "Highest Note: \(noteName)) \n Frequency: %.2f\(self.maxFrequency)"
//            print("Label:\(text)")
            var noteStr = ""
            var freqStr = ""

   
            
            if let freq = self.maxFrequency{
                if ( freq > 20.0 ){
                    freqStr = "\(freq)"
                    self.maxFrequencyLabel.stringValue = freqStr
                    if let note = noteName{
                        noteStr = "\(note)"
                        self.noteLabel.stringValue = noteStr
                    }
                }
                else{
                    self.maxFrequencyLabel.stringValue = ""
                    self.noteLabel.stringValue = ""

//                    if let note = noteName{
//                        noteStr = "\(note)"
//                        self.noteLabel.stringValue = ""
//                    }
                }
            }
            
            
//            self.noteLabel.stringValue = "\(String(describing: noteName))"
            self.recordingAudioPlot.updateBuffer(fftData, withBufferSize: UInt32(bufferSize))
            self.updateMenuBarTitleWith(note: noteStr, frequency: freqStr)
        })
    }
    
    func updateMenuBarTitleWith(note:String,frequency:String) {
        
        if isRec == false {
            return
        }
        (NSApp.delegate as? AppDelegate)?.setupMenuForRecording(withTitle: self.attributedTitleWith(title: note, subTitle: frequency));

    }
    
    func attributedTitleWith(title:String,subTitle:String) -> NSAttributedString {
        
        var textColor = NSColor.black
        if(InterfaceStyle() == .Dark){
            textColor = NSColor.white
        }
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // *** set LineSpacing property in points ***
//        paragraphStyle.lineSpacing = 0.0 // Whatever line spacing you want in points
        paragraphStyle.lineSpacing = 0.5 // change line spacing between each line like 30 or 40
        paragraphStyle.maximumLineHeight = 6
        let stringAttributes = [
        
            NSAttributedStringKey.font : NSFont(name: "Helvetica Neue", size: 12.0)!,
//            NSAttributedStringKey.underlineStyle : 1,
            NSAttributedStringKey.foregroundColor : textColor,

//            NSAttributedStringKey.textEffect : NSAttributedString.TextEffectStyle.letterpressStyle,
//            NSAttributedStringKey.strokeWidth : 2.0
//            NSAttributedStringKey.paragraphStyle : paragraphStyle,
            ] as [NSAttributedStringKey : Any]
        let atrributedString = NSAttributedString(string: "\(title)\n", attributes: stringAttributes)
        
        let stringAttributes2 = [
            NSAttributedStringKey.font : NSFont(name: "Helvetica Neue", size: 8.0)!,
//            NSAttributedStringKey.underlineStyle : 1,
            NSAttributedStringKey.foregroundColor : textColor,
//            NSAttributedStringKey.textEffect : NSAttributedString.TextEffectStyle.letterpressStyle,
//            NSAttributedStringKey.strokeWidth : 2.0,
            NSAttributedStringKey.paragraphStyle : paragraphStyle,
            ] as [NSAttributedStringKey : Any]
        let atrributedString2 = NSAttributedString(string: subTitle, attributes: stringAttributes2)
        
        let attrStr = NSMutableAttributedString.init(attributedString: atrributedString)
        attrStr.append(atrributedString2)
//        attrStr.addAttributes([NSAttributedStringKey.paragraphStyle : paragraphStyle], range: NSMakeRange(0, attrStr.length))
//        sampleLabel.attributedText = atrributedString
        return attrStr
        
    }
    
}

