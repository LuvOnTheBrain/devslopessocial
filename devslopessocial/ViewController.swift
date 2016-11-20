//
//  ViewController.swift
//  devslopessocial
//
//  Created by Lemonade on 2016/11/13.
//  Copyright © 2016年 Lynx. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase


class ViewController: UIViewController {
    
    
    @IBOutlet weak var emailfield: UITextField!
    @IBOutlet weak var passwordfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func fbBtnTapped(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self, handler: {(result, error) in
            if error != nil {
                print("JESS: Unable to authenticate with Facebook - \(error)")
            } else if result?.isCancelled == true {
                print("JESS: User cancelled Facebook authentication")
            } else {
                print("JESS: Successfully authenticated with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
                
            }
        }
        )
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    // Code Source: https://developers.facebook.com/docs/swift/login
    // first authenticated with provider(Facebook), then with Firebase
    // After a user successfully signs in, get an access token for the signed-in user and exchange it for a Firebase credential:
    // Finally, authenticate with Firebase using the Firebase credential:
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                    case .errorCodeInvalidEmail:
                        print("nothing")
                        
                    case .errorCodeEmailAlreadyInUse:
                        print("in use")
                    default:
                        print("Create User Error: \(error)")
                    }
                }
                print("JESS: Unable to authenticate with Firebase - \(error)")
            } else {
                print("JESS: Successfully authenticated with Firebase")
            }
           
        })
    }
    
    
    
    @IBAction func loginPressed(_ sender: Any) {
        if let email = emailfield.text, let password = passwordfield.text{
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: {(user, error) in
                if error == nil {
                    print("JESS: Email user authenticated with Firebase")
                } else {
                    //user not existing
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: {(user, error) in
                        if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                            switch errCode {
                            case .errorCodeInvalidEmail:
                                // 上拉菜单 Action Sheet Version
//                                let  alertController = UIAlertController(title: "保存或删除数据", message: "删除数据将不可恢复", preferredStyle: UIAlertControllerStyle.actionSheet)
//                                let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
//                                let deleteAction = UIAlertAction(title: "删除", style: UIAlertActionStyle.destructive, handler: nil)
//                                let archiveAction = UIAlertAction(title: "保存", style: UIAlertActionStyle.default, handler: nil)
//                                alertController.addAction(cancelAction)
//                                alertController.addAction(deleteAction)
//                                alertController.addAction(archiveAction)
//                                self.present(alertController, animated: true, completion: nil)
//                                // Action Sheet for iPad
//                                let popover = alertController.popoverPresentationController
//                                if (popover != nil) {
//                                    popover?.sourceView = sender as? UIView
//                                    popover?.sourceRect = (sender as AnyObject).bounds
//                                    popover?.permittedArrowDirections = UIPopoverArrowDirection.any
//                                }
//                                 tbd: release dialog controller programatically
//                                 Action Sheet Version 
//                                
//                                 对话框 Alert Version
                                let alertController = UIAlertController(title: "标题", message: "这个是Alert Controller的标准样式", preferredStyle: UIAlertControllerStyle.alert)
                                let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
                                
                                let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.default, handler: {
                                    (action: UIAlertAction!) -> Void in
                                    // we can use account and password here
                                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
                                })
                                
                                alertController.addAction(cancelAction)
                             
                                alertController.addAction(okAction)
                                okAction.isEnabled = false
                                alertController.addTextField(configurationHandler: {
                                    (textField: UITextField!) -> Void in
                                    textField.placeholder = "登陆"
                                })
                                alertController.addTextField(configurationHandler: {
                                    (textField: UITextField!) -> Void in
                                        textField.placeholder = "密码"
                                        textField.isSecureTextEntry = true
                                    NotificationCenter.default.addObserver(self, selector: #selector(ViewController.alertTextFieldDidChange(notification:)), name: NSNotification.Name.UITextFieldTextDidChange, object: textField)
                                    
                                    }
                                
                                )
                                self.present(alertController, animated: true, completion: nil)
                            default:
                                print("Error: \(error)")
                            }
                            print("JESS: Unable to authenticate with Firebase using email")
                        } else {
                            print("JESS: Successfully authenticate with Firebase")
                        }
                    })
                }
            })
            // potential error: invalid email / email already in use / operation not allowed / weak password.
    }
    }
    
    func alertTextFieldDidChange(notification: NSNotification) {
    let alertController = self.presentedViewController as! UIAlertController?
    if (alertController != nil) {
        let login = (alertController!.textFields?.last)! as UITextField
        let okAction = alertController!.actions.last! as UIAlertAction
        if (login.text?.characters.count)! > 3 {
            okAction.isEnabled = true
        }
        if (login.text?.characters.count)! < 3 {
            okAction.isEnabled = false
        }
       
    }

}
}

