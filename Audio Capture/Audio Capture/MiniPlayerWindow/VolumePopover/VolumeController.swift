//
//  VolumeController.swift
//  Hello Demo
//
//  Created by Satendra Dagar on 23/03/18.
//  Copyright © 2018 CB. All rights reserved.
//

import Foundation

class VolumeController: NSViewController,NSPopoverDelegate {
    
    @IBOutlet weak var loginPopover: NSPopover!
    @IBOutlet weak var slider: NSSlider!

    var closureBlock: ((_ isClose:Bool, _ volume:Double) -> Bool)?
    @IBAction private func didClickClosePopover(_ sender: Any) {
        _ = closureBlock!(true, slider.doubleValue)
        loginPopover.close()
    }

    init(nibName nibNameOrNil: String, bundle nibBundleOrNil: Bundle, popOverDismissHandler popOverClosure: @escaping ((Bool, Double)) -> Bool) {
        super.init(nibName: NSNib.Name(rawValue: nibNameOrNil), bundle: nibBundleOrNil)
        
        closureBlock = popOverClosure

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        loginPopover.delegate = self
        loginPopover.behavior = .transient
//            [super viewDidLoad];
        // Do view setup here.
    }

    func showPopover() {
//        let view: NSView? = self.view
        print("view")
//        loginPopover.show(relativeTo: statusItem!.view!.bounds, of: statusItem!.view!, preferredEdge: .minY)
        //        loginPopover.show(relativeTo: statusItem!.view.bounds, of: statusItem.view, preferredEdge: .minYEdge)
    }

}
