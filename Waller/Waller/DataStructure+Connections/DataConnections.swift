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
                
                let decoder = JSONDecoder()
                
                do {
                    let posts = try decoder.decode(BitstampValue.self, from: jsonData)
                    completion?(.success(posts))
                } catch {
                    completion?(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    func getBitcoinChartData(completion: ((Result<ChartResponse>) -> Void)?) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = Props.httpSchema
        urlComponents.host = Props.istampHost
        urlComponents.path = "/api/getchartsdata"
        
        print("iStamp URL: \(String(describing: urlComponents.url))")
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
                
                let decoder = JSONDecoder()
                
                do {
                    let posts = try decoder.decode(ChartResponse.self, from: jsonData)
                    completion?(.success(posts))
                } catch {
                    completion?(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    // http://istamp.mskaline.com/api/getchartsdata
    
}
