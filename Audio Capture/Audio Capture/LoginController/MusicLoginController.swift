//
//  MusicLoginController.swift
//  Audio Capture
//
//  Created by Satendra Dagar on 07/01/18.
//  Copyright © 2018 CB. All rights reserved.
//

import Foundation
import Cocoa
import Alamofire
import Alamofire_SwiftyJSON

class MusicLoginController: NSViewController, NSPopoverDelegate {

     var statusItem: NSStatusItem?
    
    @IBOutlet weak var loginPopover: NSPopover!
    @IBOutlet weak var emailIDField: NSTextField!
    @IBOutlet weak var passwordField: NSTextField!
    @IBOutlet weak var loginButton: NSButton!
    @IBOutlet weak var circularProgressView: NSProgressIndicator!
    var closureBlock: (() -> Bool)?
    @IBAction private func didClickClosePopover(_ sender: Any) {
       _ = closureBlock!()
        loginPopover.close()
    }
    class func isValidEmailId(_ emailID: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        if !emailTest.evaluate(with: emailID) {
            return false
        }
        else {
            // check before @ atleast 6 character
            //        NSArray *emailCompArr = [self componentsSeparatedByString:@"@"];
            //        if (emailCompArr && emailCompArr.count>1) {
            //            NSString *strEmailUserName = [emailCompArr objectAtIndex:0];
            //            if (strEmailUserName && strEmailUserName.length>=6) {
            //                return YES;
            //            }
            //            else {
            //                return NO;
            //            }
            //        }
            return true
        }
    }
    
    init(nibName nibNameOrNil: String, bundle nibBundleOrNil: Bundle, popOverDismissHandler popOverClosure: @escaping () -> Bool) {
        super.init(nibName: NSNib.Name(rawValue: nibNameOrNil), bundle: nibBundleOrNil)
        
        closureBlock = popOverClosure
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        //    [super viewDidLoad];
        // Do view setup here.
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        circularProgressView.isHidden = true
        let loginEmail = PreferencesStore.sharedInstance.currentEmail()
        if nil != loginEmail {
            emailIDField.stringValue = loginEmail ?? ""
        }
        emailIDField.stringValue = "satendradagar@gmail.com"
        passwordField.stringValue = "sattubhai"

    }
    func showPopover() {
        let view: NSView? = self.view
        print("view")
        loginPopover.delegate = self
        loginPopover.show(relativeTo: statusItem!.view!.bounds, of: statusItem!.view!, preferredEdge: .minY)
//        loginPopover.show(relativeTo: statusItem!.view.bounds, of: statusItem.view, preferredEdge: .minYEdge)
    }
    @IBAction func didClickLogin(_ sender: Any) {
        if false == MusicLoginController.isValidEmailId(emailIDField.stringValue) {
            _ = NSUtilities.dialogOK(question: "Incorrect Email Enter", text: "Please provide a valid email id.")
            emailIDField.becomeFirstResponder()
            return
        }
        if 0 == (passwordField.stringValue.count ) {
            
           _ = NSUtilities.dialogOK(question: "Enter Password", text: "Please Enter password.")

            passwordField.becomeFirstResponder()
            return
        }
        circularProgressView.startAnimation(nil)
        circularProgressView.isHidden = false
        loginButton.isEnabled = false
        let emailId: String = emailIDField.stringValue
        let password: String = passwordField.stringValue
        
        let URL = ApiConstant.pathFor(type: .login)
        Alamofire.request(URL, method: .post, parameters: ["email": emailId,"password": password,"ios_token": ""], encoding: URLEncoding.default).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value as? NSDictionary {
                
                print("JSON: \(json)") // serialized json response

                if let err = json["error"] as? String{
                    print("error\(err)")
                    PreferencesStore.sharedInstance.saveLoginDetails(data: nil )

                }
                else{
                    let data = json["data"] as! NSDictionary
                    PreferencesStore.sharedInstance.saveLoginDetails(data: data )
                }

            }
            else{
                PreferencesStore.sharedInstance.saveLoginDetails(data: nil )

                print("Incorrect format")
            }
            
//            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                print("Data: \(utf8Text)") // original server data as UTF8 string
//            }
        }
        
//        let URL = ApiConstant.pathFor(type: .login)
//        Alamofire.request(URL, method: .post, parameters: ["email": emailId,"password": password,"ios_token": ""], encoding: URLEncoding.default).responseSwiftyJSON { response in
//            print("###Success: \(response.result.isSuccess)")
//            //now response.result.value is SwiftyJSON.JSON type
//            print("###Value: \(String(describing: response.result.value?["args"].array))")
//            print("###Value: \(String(describing: response.result.value?.type))")
//            switch response.result {
//            case .success(let value):
//                do {
//                    let resposeDict = response.result.value?.dictionary
//                    PreferencesStore.sharedInstance.saveLoginDetails(data: resposeDict!)
//
//            }
//            case .failure(let error):
//                print(error)
//            }
//
//        }

    }
}

