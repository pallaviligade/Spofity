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
    public func getrecommendations(geners:Set<String>,complication:@escaping ((Result<RecimmendationResponse,Error>))-> Void){
        let  seeds = geners.joined(separator: ",")
       
        createRequest(with: URL(string: constant.baseAPIurl + "/recommendations?seed_genres=\(seeds)?limit=40"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data , error == nil else {
                    complication(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let json = try JSONDecoder().decode(RecimmendationResponse.self, from: data)

               // let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    complication(.success(json))

                }catch{
                    print(error.localizedDescription)
                    debugPrint(error)

                    //complication(.failure(error))
                }
            }
            task.resume()
        }
    }
  public func getRecommendationGenres(complication:@escaping ((Result<RecommendationGenresResponse,Error>))-> Void){
        createRequest(with: URL(string: constant.baseAPIurl + "/recommendations/available-genre-seeds"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data , error == nil else {
                    complication(.failure(APIError.failedToGetData))
                    return
                }
                do{
                //let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let json = try JSONDecoder().decode(RecommendationGenresResponse.self, from: data)
                    complication(.success(json))
                }catch{
                    print(error.localizedDescription)
                    debugPrint(error)

                    complication(.failure(error))
                }
            }
            task.resume()
        }
    }
    public func getFeaturedPlaylist(complication:@escaping ((Result<FeaturedPlaylistResponse,Error>)) -> Void){
        createRequest(with: URL(string:constant.baseAPIurl + "/browse/featured-playlists?limit=20"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data , error == nil else {
                    complication(.failure(APIError.failedToGetData))
                    return
                }
                do{
                   //let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                   let json = try JSONDecoder().decode(FeaturedPlaylistResponse.self, from: data)
                    print(json)
                    complication(.success(json))

                }catch{
                    debugPrint(error)
                    print(error as Any)
                    print(error.localizedDescription)
                    complication(.failure(error))
                    
                }
            }
            task.resume()
        }
        
    }
    public func getNewRelease(complication:@escaping ((Result<NewRealseResponse,Error>)) -> Void) {
        let str = constant.baseAPIurl + "/browse/new-releases?limit=8"
        createRequest(with: URL(string: str), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data , error == nil else {
                    complication(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                  // let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let result = try JSONDecoder().decode(NewRealseResponse.self, from: data)
                    complication(.success(result))
                }catch{
                    print(error.localizedDescription)
                    debugPrint(error)

                    complication(.failure(error))

                }
            }
            task.resume()
        }
        
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
                    debugPrint(error)

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
