//
//  FavouriteListUpdater.swift
//  Audio Capture
//
//  Created by Satendra Dagar on 05/01/18.
//  Copyright © 2018 CB. All rights reserved.
//

import Foundation
import Alamofire
import Alamofire_SwiftyJSON

import Cocoa

class MusicItem: NSObject {
    
    var title:String?
    var url:String?
    var avatar: String?
    
    init?(with dict:[String:Any?]?) {
        if let data = dict {
            title = data["title"] as? String
            url = data["music_url"] as? String
            avatar = data["avatar"] as? String
        }
        else{
            return nil
        }
    }
}

class FavouriteItem: MusicItem {
    
}

class FavouriteListUpdater: NSObject {
    
    static func updateFavouriteItemList() {
        if false == PreferencesStore.sharedInstance.user.isLogin {
            return;
        }
        let URL = ApiConstant.pathFor(type: .favourite)
        Alamofire.request(URL, method: .post, parameters: ["user_id": PreferencesStore.sharedInstance.user.id ?? ""], encoding: URLEncoding.default).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value as? NSDictionary {
                
                print("JSON: \(json)") // serialized json response
                
                if let err = json["error"] as? String{
                    print("error\(err)")
                    PreferencesStore.sharedInstance.storeFavouriteList(data: nil )
                    
                }
                else{
                    let data = json["data"] as? [Any]
                    PreferencesStore.sharedInstance.storeFavouriteList(data: data )
                }
                
            }
            else{
                PreferencesStore.sharedInstance.storeFavouriteList(data: nil )
                
                print("Incorrect format")
            }
            
            //            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
            //                print("Data: \(utf8Text)") // original server data as UTF8 string
            //            }
        }
        
    }
    
    static func getUpdatedFavouriteItems()  -> [FavouriteItem]{
        
        if let list = PreferencesStore.sharedInstance.favouriteList() {
            var items = [FavouriteItem]()
            for item in list{
                if let fav = FavouriteItem(with: item){
                    items.append(fav)
                }
            }
            return items;
        }
        return []
    }
}
