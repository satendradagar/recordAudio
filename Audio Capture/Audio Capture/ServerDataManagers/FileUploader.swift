//
//  FileUploader.swift
//  Hello Demo
//
//  Created by Satendra Dagar on 23/01/18.
//  Copyright © 2018 CB. All rights reserved.
//

import Foundation
import Alamofire


class FileUploader: NSObject {
    
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
    
    static func uploadImage(_ filePath:String) {
        
        let params: Parameters = ["user_id": PreferencesStore.sharedInstance.user.id ?? ""]
        let URL = ApiConstant.pathFor(type: .favourite)
        let fileUrl = Foundation.URL(string: filePath)

        let data = try! Data.init(contentsOf:fileUrl!)
        
        Alamofire.upload(multipartFormData:
        {
        (multipartFormData) in
            multipartFormData.append(data , withName: fileUrl!.lastPathComponent , mimeType: "media/mp3")
        for (key, value) in params
        {
        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
        }
        }, to:URL,headers:nil)
        { (result) in
            switch result {
            case .success(let upload,_,_ ):
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                })
                upload.responseJSON
                    { response in
                        //print response.result
                        if response.result.value != nil
                        {
                            let dict :NSDictionary = response.result.value! as! NSDictionary
                            let status = dict.value(forKey: "status")as! String
                            if status=="1"
                            {
                                print("DATA UPLOAD SUCCESSFULLY")
                            }
                        }
                }
            case .failure(let encodingError):
                break
            }
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

