//
//  AuthManager.swift
//  Spofity
//
//  Created by Pallavi on 14/07/21.
//

import Foundation
final class AuthManager{
    static let shared = AuthManager()
    struct Constants {
       static let ClientID =  "39222b6321264661ac0c546cc22fb124"
        static let ClientSecretID = "0eaf602ac6ad49c7a5af3877b7cae8f2"

    }
    
    private init(){
        
    }
    
    var isSignedIn:Bool  {
        return false
    }
    private var accessToken:String? {
        return nil
    }
    private var refershToken:String? {
        return nil
    }
    private var tokenExipersionDate:Date? {
        return nil
    }
    
    private var shouldrefreshToken:Bool{
        return false
    }
    
}
