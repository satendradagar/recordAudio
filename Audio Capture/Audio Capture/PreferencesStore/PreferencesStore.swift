   //
//  PreferencesStore.swift
//  calendar
//
//  Created by Satendra Singh on 5/8/17.
//  Copyright © 2017 CB. All rights reserved.
//

import Cocoa

   class LoginUser: NSObject {
    var firstName: String?;
    var lastName: String?;
    var email: String?;
    var id: String?;
    var isLogin = false
    
    func configure(with dict:NSDictionary) {

    firstName = dict.value(forKey: "first_name") as? String
        lastName = dict.value(forKey: "last_name") as? String
        email = dict.value(forKey: "email") as? String
        if let idInt =  dict.value(forKey: "id") as?Int {
            id = String(idInt)
        }
        else{
            id = ""
        }

        if nil != id && id!.count >= 0 {
            self.isLogin = true
        }
        else{
            self.isLogin = false
        }
     }
   }
class PreferencesStore: NSObject {
    
    static let sharedInstance = PreferencesStore()
    
    let defaults = UserDefaults.standard
    let user = LoginUser.init()
    
    fileprivate override init() {
        
        super.init()
  //  5th June convert swift 3.0.
        let dict = defaults.value(forKey: "U_Login")
        if nil != dict {
            user.configure(with: dict as! NSDictionary)
        }
       
    }

    func currentEmail() -> String? {
        
        return self.defaults.string(forKey: "userLoginId")
    }
    
    func saveLoginDetails(data:NSDictionary? )
    {
        if let dataObj = data {
            let dict = dataObj.mutableCopy() as! NSMutableDictionary
            dict.findAndReplaceNull()
            self.defaults.setValue(dict, forKey: "U_Login")
            user.configure(with: dict)
        }
        else{
            self.user.isLogin = false
        }
    }
    
    func storeFavouriteList(data:[Any]? )
    {
        if let dataObj = data {
            self.defaults.setValue(dataObj, forKey: "U_Favourite")
        }
        else{
            self.defaults.setValue(nil, forKey: "U_Favourite")

        }
    }
    
    func favouriteList() -> [[String:Any?]]? {
        
        let dict = defaults.value(forKey: "U_Favourite") as? [[String:Any?]]
        return dict
    }
    
    func storeInboxList(data:[Any]? )
    {
        if let dataObj = data {
            self.defaults.setValue(dataObj, forKey: "U_Inbox")
        }
        else{
            self.defaults.setValue(nil, forKey: "U_Inbox")
            
        }
    }
    
    func inboxList() -> [[String:Any?]]? {
        
        let dict = defaults.value(forKey: "U_Inbox") as? [[String:Any?]]
        return dict
    }

    func storeCaptureList(data:[Any]? )
    {
        if let dataObj = data {
            self.defaults.setValue(dataObj, forKey: "U_Capture")
        }
        else{
            self.defaults.setValue(nil, forKey: "U_Capture")
            
        }
    }
    
    func captureList() -> [[String:Any?]]? {
        
        let dict = defaults.value(forKey: "U_Capture") as? [[String:Any?]]
        return dict
    }

    func logoutUser(){
        self.defaults.setValue(nil, forKey: "U_Inbox")
        self.defaults.setValue(nil, forKey: "U_Favourite")
        self.defaults.setValue(nil, forKey: "U_Login")
        self.user.isLogin = false
    }
    
    func updateSyncFile(fileProperties:[String:Any], forPath path:String) {

        var preDict = [:] as [String:Any?]
    
        if let oldDict = self.syncFileHistory(){
            preDict = oldDict
        }
        preDict[path] = fileProperties
        self.defaults.setValue(preDict, forKey: "U_Sync")
        self.defaults.synchronize()
    }
    
    func syncFileForPath(path: String) -> [String:Any?]? {
        if let oldDict = self.syncFileHistory(){
            return oldDict[path] as? [String:Any?]
        }
        return nil
    }
    
    func syncFileHistory() -> [String:Any?]? {
        
        let dict = defaults.value(forKey: "U_Sync") as? [String:Any?] ?? [:]
        return dict
    }
}
