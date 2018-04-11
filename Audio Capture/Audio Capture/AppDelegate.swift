//
//  AppDelegate.swift
//  Audio Capture
//
//  Created by Satendra Dagar on 27/12/17.
//  Copyright © 2017 CB. All rights reserved.
//

enum InterfaceStyle : String {
    case Dark, Light
    
    init() {
        let type = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") ?? "Light"
        self = InterfaceStyle(rawValue: type)!
    }
}

let currentStyle = InterfaceStyle()
import Cocoa
import ServiceManagement

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var menu: MenuBarActionHandler!
    let popover = NSPopover()
    var dateReact = NSRect()
    var popoverkey = 1

    var statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
  
    func setupMenuForRecording() {
        var img = NSImage(named: NSImage.Name("status"))

        if(InterfaceStyle() == .Dark){
            img = NSImage(named: NSImage.Name("statusDark"))
        }
        statusItem.image = img

    }
    
    func setupMenuForRecording(withTitle title:NSAttributedString) {
//        var img = NSImage(named: NSImage.Name("status"))
//
//        if(InterfaceStyle() == .Dark){
//            img = NSImage(named: NSImage.Name("statusDark"))
//        }
        statusItem.image = nil
        statusItem.attributedTitle = title
        
    }

    func setupMenuForNormal() {
        
        let img = NSImage(named: NSImage.Name("status_Recording"))
        statusItem.image = img
        statusItem.title = ""


    }

    func setupMenuWithButton() {
        let button = NSButton(frame: CGRect(x: 0, y: 0, width: 41, height: 18)) as? NSButton
        statusItem.view = button
        let img = NSImage(named: NSImage.Name("status_Recording"))
        button?.image = img
//        button?.title = "Audio"
        //    [button highlight:YES];
        //    button.bezelStyle = NSRecessedBezelStyle;
        //    [button setTransparent:YES];
        button?.isBordered = false
        //    [button setTarget:self];
        //    [button setAction:@selector(showMainMenu)];
    }
    
    func setupMenuWithMainMenu() {
        if nil == statusItem.view {
            return
        }
        statusItem.view = nil
        let img = NSImage(named: NSImage.Name("status_Recording"))
        statusItem.menu = menu
        statusItem.image = img
//        statusItem.title = "Audio"

//        let highlightedImage = NSImage(named: NSImage.Name("menuBarSelectedIcon"))
//        statusItem.alternateImage = highlightedImage
//        statusItem.highlightMode = true
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        statusItem.menu = menu //set the menu
//        statusItem.title = "Audio"
//        statusItem.target = self
//        statusItem.action = #selector(AppDelegate.togglePopover(_:))
//        //        statusItem.title = statusBarTitleString()
//        statusItem.highlightMode = true
//        //statusItem.menu = menu
//        if let button = statusItem.button {
//            button.action = #selector(AppDelegate.statusBarButtonClicked(_:))
//
//            //4th June .
//            button.sendAction( on: (NSEvent.EventTypeMask(rawValue: UInt64(Int(NSEvent.EventTypeMask.rightMouseDown.rawValue) | Int(NSEvent.EventTypeMask.leftMouseDown.rawValue)))))
//
//
//        }
        self.setupMenuForNormal()
        let isSet = PreferencesStore.sharedInstance.isFirstLaunch()
        if isSet == false {
            self.startAtLogin = true
        }
    }

    let helperBundleIdentifier = "com.corebitss.Audio-Capture.launcher"
    
//    @objc @available(OSX, deprecated: 10.10) // necessary to suppress the deprecated warning.
    @objc dynamic var startAtLogin : Bool {
        get {
            guard let jobDicts = SMCopyAllJobDictionaries( kSMDomainUserLaunchd ).takeRetainedValue() as NSArray as? [[String:Any]] else { return false }
            return jobDicts.filter { $0["Label"] as! String == helperBundleIdentifier }.isEmpty == false
        } set {
            if !SMLoginItemSetEnabled(helperBundleIdentifier as CFString, newValue) {
                print("SMLoginItemSetEnabled failed.")
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    // MARK: - Core Data stack

//    lazy var persistentContainer: NSPersistentContainer = {
//        /*
//         The persistent container for the application. This implementation
//         creates and returns a container, having loaded the store for the
//         application to it. This property is optional since there are legitimate
//         error conditions that could cause the creation of the store to fail.
//        */
//        let container = NSPersistentContainer(name: "Audio_Capture")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//
//                /*
//                 Typical reasons for an error here include:
//                 * The parent directory does not exist, cannot be created, or disallows writing.
//                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                 * The device is out of space.
//                 * The store could not be migrated to the current model version.
//                 Check the error message to determine what the actual problem was.
//                 */
//                fatalError("Unresolved error \(error)")
//            }
//        })
//        return container
//    }()

    // MARK: - Core Data Saving and Undo support

    @IBAction func saveAction(_ sender: AnyObject?) {
        // Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
//        let context = persistentContainer.viewContext
//
//        if !context.commitEditing() {
//            NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing before saving")
//        }
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                // Customize this code block to include application-specific recovery steps.
//                let nserror = error as NSError
//                NSApplication.shared.presentError(nserror)
//            }
//        }
    }

//    func windowWillReturnUndoManager(window: NSWindow) -> UndoManager? {
        // Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
//        return persistentContainer.viewContext.undoManager
//    }

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        // Save changes in the application's managed object context before the application terminates.
//        let context = persistentContainer.viewContext
//
//        if !context.commitEditing() {
//            NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing to terminate")
//            return .terminateCancel
//        }
//
//        if !context.hasChanges {
//            return .terminateNow
//        }
//
//        do {
//            try context.save()
//        } catch {
//            let nserror = error as NSError
//
//            // Customize this code block to include application-specific recovery steps.
//            let result = sender.presentError(nserror)
//            if (result) {
//                return .terminateCancel
//            }
//
//            let question = NSLocalizedString("Could not save changes while quitting. Quit anyway?", comment: "Quit without saves error question message")
//            let info = NSLocalizedString("Quitting now will lose any changes you have made since the last successful save", comment: "Quit without saves error question info");
//            let quitButton = NSLocalizedString("Quit anyway", comment: "Quit anyway button title")
//            let cancelButton = NSLocalizedString("Cancel", comment: "Cancel button title")
//            let alert = NSAlert()
//            alert.messageText = question
//            alert.informativeText = info
//            alert.addButton(withTitle: quitButton)
//            alert.addButton(withTitle: cancelButton)
//
//            let answer = alert.runModal()
//            if answer == .alertSecondButtonReturn {
//                return .terminateCancel
//            }
//        }
        // If we got here, it is time to quit.
        return .terminateNow
    }

}

extension AppDelegate{
    func showPopover(_ sender: AnyObject?) {
        
        if let button = statusItem.button {
            //            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.maxY )
            //            let buttonRect = button.bounds as NSRect;
            //            if(dateReact.size.width == 0) {
            //                dateReact = buttonRect
            //            }
            
            popover.show(relativeTo: dateReact, of: button, preferredEdge: NSRectEdge.minY)
            //            popover.positioningRect = (popover.contentViewController?.view.frame)!
            
            /// no closing calendar window when user click outside popover.
            if (popoverkey == 1) {
                popover.behavior = .transient
                NSApplication.shared.activate(ignoringOtherApps: true)
                
            }
            else if(popoverkey == 2){
                popover.behavior = .applicationDefined
                NSApplication.shared.deactivate()
                
            }
        }
    }
    
    func closePopover(_ sender: AnyObject?) {
        
        //        NotificationCenter.default.post(name: Notification.Name("RemoveAgendaView"), object: nil)
        popover.performClose(sender)
        
        
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        let button = statusItem.button
        
        if popover.isShown  {
            
            //            NotificationCenter.default.post(name: Notification.Name("RemoveAgendaView"), object: nil)
            button?.highlight(false)
            closePopover(sender)
            
            
        } else {
            button?.highlight(true)
            showPopover(sender)
            
        }
    }
    
    @objc func statusBarButtonClicked(_ sender: NSStatusBarButton) {
        let event = NSApp.currentEvent!
        print("click")
        print(event.type)
        if  event.type == NSEvent.EventType.rightMouseDown {
            
            if popover.isShown {
                closePopover(sender)
            }
            else
            {
                print("1 click")
                //statusItem.menu = menu //set the menu
                statusItem.popUpMenu(menu)// show the menu
            }
            
        } else if event.type == NSEvent.EventType.leftMouseDown {
            popover.performClose(sender)
            
            togglePopover(sender)
            print("2 click")
            
            
        }
    }
    
}
