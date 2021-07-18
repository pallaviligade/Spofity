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
       static let tokenapicall = "https://accounts.spotify.com/api/token"
       static let redircturl = "https://pallaviligade.wordpress.com/"
       static let scopes = "user-read-private%20playlist-modify-public%20playlist-modify-private%20playlist-read-private%20playlist-read-collaborative%20user-follow-modify%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"

    }
    
    public var signInurl:URL?{
      
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(Constants.ClientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redircturl)&show_dialog=TRUE"
        return URL(string: string)
       
    }
    
    private init(){
        
    }
    
    var isSignedIn:Bool  {
        return accessToken != nil
    }
    private var accessToken:String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    private var refershToken:String? {
        return UserDefaults.standard.string(forKey: "refresh_token")

    }
    private var tokenExipersionDate:Date? {
        return UserDefaults.standard.string(forKey: "expires_in") as? Date

    }
    
    private var shouldrefreshToken:Bool{
        
        guard let tokenExipersionDate = tokenExipersionDate
        else {
            return false
        }
        let currentdate = Date()
        let fiveminuts: TimeInterval = 300
        return currentdate.addingTimeInterval(fiveminuts) >= tokenExipersionDate
    }
    public func exchangeAccessToken(code:String,completionHandler:@escaping ((Bool)->Void))
    {
        // Make API call to get token
        
        guard let url = URL(string: Constants.tokenapicall) else {return}
        var componts = NSURLComponents()
        componts.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redircturl)
        
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded ", forHTTPHeaderField: "Content-Type")
        request.httpBody = componts.query?.data(using: .utf8)

        let basicToken = Constants.ClientID + ":" + Constants.ClientSecretID
        let data = basicToken.data(using: .utf8)
        guard let base64token = data?.base64EncodedString() else {
            completionHandler(false)
            return
            
        }
        request.setValue("Basic \(base64token)", forHTTPHeaderField: "Authorization")
        
       let task = URLSession.shared.dataTask(with: request) {[weak self] data, _, error in
            guard let data = data , error == nil else{
                completionHandler(false)
                return
            }
        do {
         //   let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
           let json = try JSONDecoder().decode(AuthResponse.self, from: data)
            self?.catchToken(authResponse:json)
            print("Sucess:\(json)")
            completionHandler(true)
        } catch  {
            print(error.localizedDescription)
            completionHandler(false)
        }
        }
        task.resume()
        
        
    }
    public func refershIfNeeded(complication:@escaping (Bool) -> Void){
        guard shouldrefreshToken else{
            complication(true)
            return
        }
        guard let refershToken = self.refershToken else{
            return
        }
        
        guard let url = URL(string: Constants.tokenapicall) else {return}
        var componts = NSURLComponents()
        componts.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refershToken)
        
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded ", forHTTPHeaderField: "Content-Type")
        request.httpBody = componts.query?.data(using: .utf8)

        let basicToken = Constants.ClientID + ":" + Constants.ClientSecretID
        let data = basicToken.data(using: .utf8)
        guard let base64token = data?.base64EncodedString() else {
            complication(false)
            return
            
        }
        request.setValue("Basic \(base64token)", forHTTPHeaderField: "Authorization")
        
       let task = URLSession.shared.dataTask(with: request) {[weak self] data, _, error in
            guard let data = data , error == nil else{
                complication(false)
                return
            }
        do {
         //   let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
           let json = try JSONDecoder().decode(AuthResponse.self, from: data)
            print("Sucessfuly refersh token")
            self?.catchToken(authResponse:json)
            print("Sucess:\(json)")
            complication(true)
        } catch  {
            print(error.localizedDescription)
            complication(false)
        }
        }
        task.resume()
        
     
    }
    public func catchToken(authResponse:AuthResponse){
        UserDefaults.standard.setValue(authResponse.access_token, forKey: "access_token")
        if let refresh_token = authResponse.refresh_token{
            UserDefaults.standard.setValue(refresh_token, forKey: "refresh_token")
            
        }
        let date = Date().addingTimeInterval(TimeInterval(authResponse.expires_in))
        UserDefaults.standard.setValue(date, forKey: "expires_in")

      
    }
    
    
}
