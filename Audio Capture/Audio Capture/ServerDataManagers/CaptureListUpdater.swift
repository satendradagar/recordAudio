//
//  CaptureListUpdater.swift
//  Hello Demo
//
//  Created by Satendra Dagar on 15/02/18.
//  Copyright © 2018 CB. All rights reserved.
//


import Foundation
import Alamofire

class CaptureListUpdater: NSObject {
    
    static func updateCaptureItemList() {
        if false == PreferencesStore.sharedInstance.user.isLogin {
            return;
        }
        let URL = ApiConstant.pathFor(type: .capture)
        var headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        if let token = PreferencesStore.sharedInstance.user.authToken{
            headers = [
                "Authorization": "Bearer \(token)",
                "Accept": "application/json"
            ]
        }

        Alamofire.request(URL, method: .post, parameters: ["user_id": PreferencesStore.sharedInstance.user.id ?? ""], encoding: URLEncoding.default, headers:headers).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value as? NSDictionary {
                
                print("JSON: \(json)") // serialized json response
                
                if let err = json["error"] as? String{
                    print("error\(err)")
                    PreferencesStore.sharedInstance.storeCaptureList(data: nil )
                    
                }
                else{
                    let data = json["data"] as? [[String:Any?]]
                    var finalRep = [[String:Any?]]()
                    for item in data!{
                        if let music =  MusicItem.init(with: item){
                            finalRep.append(music.dictionaryRepresentation())
                        }
                    }
                    PreferencesStore.sharedInstance.storeCaptureList(data: finalRep )
                }
                
            }
            else{
                PreferencesStore.sharedInstance.storeCaptureList(data: nil )
                
                print("Incorrect format")
            }
            
            //            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
            //                print("Data: \(utf8Text)") // original server data as UTF8 string
            //            }
        }
        
    }
    
    static func getUpdatedCapturedItems()  -> [MusicItem]{
        
        if let list = PreferencesStore.sharedInstance.captureList() {
            var items = [MusicItem]()
            for item in list{
                if let fav = MusicItem(with: item){
                    items.append(fav)
                }
            }
            return items
        }
        return []
    }
}
