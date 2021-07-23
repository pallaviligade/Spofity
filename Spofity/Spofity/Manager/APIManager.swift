//
//  APIManager.swift
//  Spofity
//
//  Created by Pallavi on 14/07/21.
//

import Foundation
final class APIManager {
    static let shared = APIManager()
    
    private init(){
        
    }
    struct constant {
        static let baseAPIurl = "https://api.spotify.com/v1"
    }
    enum APIError : Error
    {
        case failedToGetData
    }
    public func getcurrentUserProfile(complication: @escaping (Result<UserProfile, Error>)-> Void)
    {
        createRequest(with:URL (string: constant.baseAPIurl + "/me"), type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, response, error in
                guard let data = data , error == nil else {
                    complication(.failure(APIError.failedToGetData))
                    return
                }
                do{
                   // let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let json = try JSONDecoder().decode(UserProfile.self, from: data)
                    complication(.success(json))
                }catch{
                    print(error.localizedDescription)
                    complication(.failure(error))
                }
                
            }
            task.resume()
        }
       
    }
    //MARK - Private
    enum HTTPMethods:String {
        case POST
        case GET
    }
    private func createRequest(with url:URL?,
                               type:HTTPMethods
                               ,complication:@escaping (URLRequest) -> Void)
    {
        guard let apiURL = url else {return}
        AuthManager.shared.withValidtoken { token in
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 3600
            complication(request)
            
        }
        
       
    }
}
