//
//  RemoteDataManager.swift
//  RecipeFinder
//
//  Created by BMGH SRL on 11/08/2017.
//  Copyright © 2017 BMAGH SRL. All rights reserved.
//

import Foundation

public class RemoteDataManager {
    
    
    private let session: URLSession!
    
    // MARK: Life Cycle
    
    init() {
        session = URLSession.shared
    }
    
    class func sharedClient() -> RemoteDataManager {
        
        struct Singleton {
            static let sharedClient = RemoteDataManager()
        }
        
        return Singleton.sharedClient
    }
    
    
    typealias CompletionHandler = (_ data: Data? , _ error: NSError?) -> Void
    typealias DataCompletionHandler = (_ recipies: [Recipe]?, _ error: NSError?) -> Void
    
    
    func loadDataFromURL(url: URL, completion: @escaping CompletionHandler) -> Void {
        
        let loadDataTask = session.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completion(nil, error! as NSError)
            } else if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    let statusError = NSError(domain: "recipepuppy.com",
                                              code: response.statusCode,
                                              userInfo: [NSLocalizedDescriptionKey: "HTTP status code has unexpected value."])
                    completion(nil, statusError)
                } else {
                    completion(data, nil)
                }
            }
        }
        loadDataTask.resume()
    }
    
    
    // Will compose URL by adding QueryItems
    func encodeQueryParameters(with query: String) -> URL? {
        
        var components = URLComponents(url: URL(string: API.baseUrl)!, resolvingAgainstBaseURL: false)
        
        let normalQuery = URLQueryItem(name: Endpoints.OptParameters.NormalQuery,
                                       value: query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
        let pageQuery = URLQueryItem(name: Endpoints.OptParameters.Page,
                                     value: "1")
        
        components?.queryItems = [normalQuery, pageQuery]
        
        return components?.url
        
    }
    
    
    // If necesary will extend like this to search in the API by ingredients
    func encodeQueryParametersWithIngredients(with query: String, ingredients: [String]) -> URL? {
        
        
        var components = URLComponents(url: URL(string: API.baseUrl)!,
                                       resolvingAgainstBaseURL: false)
        
        
        // sanitize tokens
        
        var sanitizedTokens = [String]()
        
        for token in ingredients {
            if let encodedToken = token.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
                sanitizedTokens.append(encodedToken)
            } else {
                print("Error encoding ingredients")
                return nil
            }
        }
        
        let ingredientsQuery = URLQueryItem(name: Endpoints.OptParameters.MultipleIngredients, value: sanitizedTokens.joined(separator: ","))
        
        let normalQuery = URLQueryItem(name: Endpoints.OptParameters.NormalQuery, value: query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
        
        let pageQuery = URLQueryItem(name: Endpoints.OptParameters.Page, value: "10")
        
        components?.queryItems = [ingredientsQuery, normalQuery, pageQuery]
        
        return components?.url
        
    }
    
    
    // Utility function to parse data
    func parsingData(recipies: [Recipe], data: Data, completion: DataCompletionHandler) {
        
        var recipies = recipies
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: AnyObject]
            
            if let resultsNode = jsonResult[Endpoints.Nodes.results] as? [[String:AnyObject]] {
                
                for result in resultsNode {
                    
                    do {
                        recipies.append(try Recipe(json: result))
                    } catch {
                        print("wrong parse cause: \(error.localizedDescription)")
                    }
                }
            }
            
            completion(recipies.reversed(), nil)
            
        } catch {
            completion(nil, error as NSError)
        }
        
    }
    
    
}
