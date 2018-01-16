//
//  DictionaryCleanup.swift
//  Audio Capture
//
//  Created by Satendra Dagar on 09/01/18.
//  Copyright © 2018 CB. All rights reserved.
//

import Foundation

extension NSMutableDictionary{

    func findAndReplaceNull()  {
        var removals = [Any]()
        
        for key in self.allKeys {
            if let nulVal = self[key] as? NSNull{
                removals.append(key)
                print("removing\(nulVal)-\(key)")
//                [self .removeObject(forKey: key)];
            }
        }
        
        self.removeObjects(forKeys: removals)
    }

}
