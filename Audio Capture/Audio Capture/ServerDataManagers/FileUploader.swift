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
    
    static func uploadMediaAtPath(_ filePath:String, completion:@escaping ((_ filePath:String, _ status:Bool) -> Void)) {
        
        
        let URL = ApiConstant.pathFor(type: .sync)
        let fileUrl = Foundation.URL(string: filePath)
        
        /*
         let parameters = [
         [
         "name": "user_id",
         "value": "1"
         ],
         [
         "name": "bit_rate",
         "value": "44100"
         ],
         [
         "name": "file",
         "fileName": "/Users/satendrasingh/Desktop/Desktop/Songs/Punjabi/_Nu_Shraab--[HoTJaTT.CoM].mp3"
         ]
         ]
 */

        let params: Parameters = ["user_id": PreferencesStore.sharedInstance.user.id ?? "",
                                  "bit_rate": "44100",
//                                  "filename":fileUrl?.lastPathComponent ?? "File.aiff"
                                  ]
//        let data = try! Data.init(contentsOf:fileUrl!)
        let data = FileManager.default.contents(atPath: filePath)

        Alamofire.upload(multipartFormData:
        {
            
        (multipartFormData) in
            for (key, value) in params
            {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }

//            multipartFormData.append(data! , withName: "file" , mimeType: "audio/mpeg")
            multipartFormData.append(data!, withName: "file", fileName: fileUrl?.lastPathComponent ?? "File.aiff", mimeType: "audio/mpeg")
            
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
                            let status = dict.value(forKey: "error_code")as! String
                            if status=="200"
                            {
                                print("DATA UPLOAD SUCCESSFULLY")
                            }
                            completion(filePath, true)
                        }
                        else{
                            completion(filePath, false)
                        }

                }
            case .failure(let encodingError):
                completion(filePath, false)
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

