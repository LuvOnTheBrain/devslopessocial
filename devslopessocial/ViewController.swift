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
                        let alert = UIAlertController(title: "Sorry", message: "The E-Mail is invalid", preferredStyle:UIAlertControllerStyle.alert )
                        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                        alert.addAction(action)
                        
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
                                print("Please type in a valid e-mail address")
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
        
    

     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

