//
//  DataService.swift
//  devslopessocial
//
//  Created by Lemonade on 2016/11/29.
//  Copyright © 2016年 Lynx. All rights reserved.
//

import Foundation
import Firebase


let DB_BASE = FIRDatabase.database().reference()
// contain the url of data base. this information is from googleplist.

class DataService {
   static let ds = DataService()
// create a singleton instance that's globally accessible
   private var _REF_BASE = DB_BASE
   private var _REF_POSTS = DB_BASE.child("posts")
   private var _REF_USERS = DB_BASE.child("users")
   
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
        //if uid doesn't exist, we will create a database for it.
        //check out the documentation for update / set ChildValues, update: only add new data, not overwriting any existing data, set: wipe out the old data, put new data in.
    }

    
    
}
