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



class ViewController: UIViewController {

  
    @IBOutlet weak var loginButton: FBSDKButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton = FBSDKLoginButton()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func fbBtnTapped(_ sender: Any) {
      let login = FBSDKLoginManager.init()
        login.logIn(withReadPermissions: @[@"public_profile"], from: self, handler: result: FBSDKLoginManagerLoginResult, error: NSError {
            
        })
    }

   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}

