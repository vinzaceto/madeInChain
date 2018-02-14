//
//  DataConnections.swift
//  Waller
//
//  Created by Vincenzo Aceto on 14/02/2018.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import Foundation

class DataConnections {
    
    enum Result<Value> {
        case success(Value)
        case failure(Error)
    }
    
    func getBitcoinValue(currency: String, completion: ((Result<BitstampValue>) -> Void)?) {
        var urlComponents = URLComponents()
        urlComponents.scheme = Props.httpsSchema
        urlComponents.host = Props.bitstampHost
        urlComponents.path = "/api/v2/ticker/"+currency

        print("Bitstamp URL: \(urlComponents.url)")
        guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            DispatchQueue.main.async {
                guard responseError == nil else {
                    completion?(.failure(responseError!))
                    return
                }
                
                guard let jsonData = responseData else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Data was not retrieved from request"]) as Error
                    completion?(.failure(error))
                    return
                }
                
                // Now we have jsonData, Data representation of the JSON returned to us
                // from our URLRequest...
                
                // Create an instance of JSONDecoder to decode the JSON data to our
                // Codable struct
                let decoder = JSONDecoder()
                
                do {
                    // We would use Post.self for JSON representing a single Post
                    // object, and [Post].self for JSON representing an array of
                    // Post objects
                    let posts = try decoder.decode(BitstampValue.self, from: jsonData)
                    completion?(.success(posts))
                } catch {
                    completion?(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
}
