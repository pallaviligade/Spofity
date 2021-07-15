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
    
    public var signInurl:URL?{
        let scopes = "user-read-private"
        let redircturl = "https://pallaviligade.wordpress.com/"
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(Constants.ClientID)&scope=\(scopes)&redirect_uri=\(redircturl)&show_dialog=TRUE"
        return URL(string: string)
       
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
    public func exchangeAccessToken(code:String,complicaton:@escaping ((Bool)->Void))
    {
        // Make API call to get token
        
        
    }
    public func refershAccessToken(){
        
    }
    public func catchToken(){
        
    }
    
    
}
