//
//  NSViewController+Utilities.swift
//  AJPlayerMac
//
//  Created by Satendra Singh on 31/10/17.
//  Copyright © 2017 geovision. All rights reserved.
//

import Foundation
import Cocoa

extension NSViewController{
    
    class func instance() -> Self {
        //Bundle.init(identifier:nil )"com.gtdigital.AJDisplay"
        let storyboardName = String(describing: self)
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: storyboardName), bundle: nil)
        return storyboard.initialViewController()
    }
    
    func addSSChildViewController(child:NSViewController){
        
        let subView = child.view;//Child
        self.addSSChildViewController(child: child, withView: subView)
    }
    func fit(childView: NSView, parentView: NSView) {
        childView.translatesAutoresizingMaskIntoConstraints = false
        childView.topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        childView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = true
        childView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive = true
        childView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
    }
    
    func addSSChildViewController(child:NSViewController, withView subView:NSView){
        
//        let subView = child.view;//Child
        let parent = self.view;//Parent
        self.addChildViewController(child)
        parent.addSubview(subView)
        fit(childView: subView, parentView: parent)
        subView.translatesAutoresizingMaskIntoConstraints = false
//        parent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subView]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subView": subView]))
//        parent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subView]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subView": subView]))
//
//        return
//        //width
//        let width = NSLayoutConstraint(item: subView, attribute: .width, relatedBy: .equal, toItem: parent, attribute: .width, multiplier: 1.0, constant: 0.0)        //
//
//        //height
//        let height = NSLayoutConstraint(item: subView, attribute: .height, relatedBy: .equal, toItem: parent, attribute: .height, multiplier: 1.0, constant: 0.0)        //
//
//        //top
//        let top = NSLayoutConstraint(item: subView, attribute: .bottom, relatedBy: .equal, toItem: parent, attribute: .bottom, multiplier: 1.0, constant: 0.0)        //
//
//        //Leading
//        let leading = NSLayoutConstraint(item: subView, attribute: .leading, relatedBy: .equal, toItem: parent, attribute: .leading, multiplier: 1.0, constant: 0.0)
//        parent.addConstraints([leading,top,height,width])
    }

}

extension NSWindowController{
    
    class func instance() -> Self {
        //Bundle.init(identifier:nil )"com.gtdigital.AJDisplay"
        let storyboardName = String(describing: self)
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: storyboardName), bundle: nil)
        return storyboard.initialViewController()
    }

}
