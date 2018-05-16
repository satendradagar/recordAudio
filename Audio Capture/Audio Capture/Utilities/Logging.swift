//
//  Logging.swift
//  Hello Demo
//
//  Created by Satendra Singh on 16/05/18.
//  Copyright © 2018 CB. All rights reserved.
//

import Foundation

// Gobal log() function
//
// note that empty functions are removed by the Swift compiler -> use #if $endif to enclose all the code inside the log()
// these log() statements therefore do not need to be removed in the release build !
//
// to enable logging
//
// Project -> Build Settings -> Swift Compiler - Custom flags -> Other Swift flags -> Debug
// add one of these 3 possible combinations :
//
//      -D kLOG_ENABLE
//      -D kLOG_ENABLE -D kLOG_DETAILS
//      -D kLOG_ENABLE -D kLOG_DETAILS -D kLOG_THREADS
//
// you can just call log() anywhere in the code, or add a message like log("hello")
//
func log(message: String = "", filePath: String = #file, line: Int = #line, function: String = #function) {
    #if kLOG_ENABLE
    
    #if kLOG_DETAILS
    
    var threadName = ""
    #if kLOG_THREADS
    threadName = NSThread.currentThread().isMainThread ? "MAIN THREAD" : (NSThread.currentThread().name ?? "UNKNOWN THREAD")
    threadName = "[" + threadName + "] "
    #endif
    
    let fileName = NSURL(fileURLWithPath: filePath).URLByDeletingPathExtension?.lastPathComponent ?? "???"
    
    var msg = ""
    if message != "" {
        msg = " - \(message)"
    }
    
    NSLog("-- " + threadName + fileName + "(\(line))" + " -> " + function + msg)
    #else
    NSLog(message)
    #endif
    #endif
}

