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
    
    // Code Source: https://developers.facebook.com/docs/swift/login
    // first authenticated with provider(Facebook), then with Firebase
    // After a user successfully signs in, get an access token for the signed-in user and exchange it for a Firebase credential:
    // Finally, authenticate with Firebase using the Firebase credential:
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("JESS: Unable to authenticate with Firebase - \(error)")
            } else {
                print("JESS: Successfully authenticated with Firebase")
            }
        })
    }

     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

