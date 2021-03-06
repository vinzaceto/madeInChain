//
//  BTCTestnetInfo.swift
//  CoreBitcoin
//
//  Created by Vincenzo Ajello on 07/02/18.
//

import UIKit

struct BTCUnspentRespose:Codable
{
    let unspent_outputs:[BTCUtx]
}

struct BTCUtx:Codable
{
    let tx_hash:String
    let tx_hash_big_endian:String
    let tx_index:UInt32
    let tx_output_n:UInt32
    let script:String
    let value:BTCAmount
    let value_hex:String
    let confirmations:UInt
}

struct WalletTransactions:Codable
{
    let address:String
    let total_received:BTCAmount
    let total_sent:BTCAmount
    let final_balance:BTCAmount
    let txs:[TXs]
}

struct TXs:Codable
{
    let inputs:[TXin]
    let out:[TXout]
    let time:UInt32
}

struct TXin:Codable
{
    let sequence:UInt32
    let prev_out:TXout
    let script:String
}

struct TXout:Codable
{
    let spent:Bool
    let tx_index:UInt32
    let type:Int
    let addr:String
    let value:BTCAmount
    let n:UInt32
    let script:String
}

class BTCTestnetInfo: NSObject
{
    func getWalletTransactions(address:String, completion: @escaping ((Bool,WalletTransactions?) -> Void))
    {
        let url = URL(string: "https://testnet.blockchain.info/it/rawaddr/\(address)")!
        let request = URLRequest(url: url)
        var data: Data? = nil
        
        URLSession.shared.dataTask(with: request)
        {
            (responseData, _, _) -> Void in
            data = responseData
            
            //let reply = data.flatMap { String(data: $0, encoding: .utf8) } ?? ""
            //print(reply)
            
            let decoder = JSONDecoder()
            do
            {
                if data != nil {
                    let decodedResponse = try decoder.decode(WalletTransactions.self, from: data!)
                    completion(true,decodedResponse)
                } else {
                    completion(false,nil)
                }
                return
            }
            catch
            {
                print("error converting data to JSON")
                completion(false,nil)
                return
            }
        }.resume()
    }

    
    func unspentOutputsWithAddress(address:String,completion: @escaping ((Bool,String,[BTCTransactionOutput]?) -> Void))
    {
        let url = URL(string: "https://testnet.blockchain.info/unspent?active=\(address)")!
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request)
        {
            (responseData, _, _) -> Void in
            guard let data = responseData else { completion(false,"wrong data",nil); return }

            //let reply = responseData.flatMap { String(data: $0, encoding: .utf8) } ?? ""
            //print(reply)
            
            let decoder = JSONDecoder()
            do
            {
                let decodedResponse = try decoder.decode(BTCUnspentRespose.self, from: data)
                let txs = self.unspentOutputsForResponseData(data: decodedResponse.unspent_outputs)
                completion(true,"nil",txs)
                return
            }
            catch {completion(false,"error converting data to JSON",nil);return}
            
        }.resume()
    }
    
    func unspentOutputsForResponseData(data:[BTCUtx]) -> [BTCTransactionOutput]?
    {
        //print(data)

        var outputs:[BTCTransactionOutput] = []
        
        for utx in data
        {
            let txout = BTCTransactionOutput.init()
            txout.value = utx.value
            let script = BTCScript.init(hex: utx.script)
            txout.script = script
            txout.index = utx.tx_output_n
            txout.confirmations = utx.confirmations
            txout.transactionHash = BTCDataFromHex(utx.tx_hash)
            outputs.append(txout)
        }
        
        if outputs.count > 0 {return outputs}
        
        return nil
        
    }

    
    
    
    
    
    
    
    
    
  
    
    
    func requestForTransactionBroadcastWithData(data:Data) -> NSMutableURLRequest?
    {
        guard let hex = BTCHexFromData(data) else
        {
            print("unable to compute transaction data to hex")
            return nil
        }
        
        let url = URL.init(string: "https://testnet.blockchain.info/pushtx?tx=\(hex)")
        let request = NSMutableURLRequest.init(url: url!)
        return request
    }
    
    
    
    func broadcastTransactionData(data:Data, completion:@escaping ((Bool,String?) -> Void))
    {
        guard let hex = BTCHexFromData(data) else
        {
            completion(false,"unable to compute transaction data to hex")
            return
        }
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "testnet.blockchain.info"
        urlComponents.path = "/pushtx"
        urlComponents.queryItems = [URLQueryItem.init(name: "tx", value: hex)]
        
        guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
      
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/x-www-form-urlencoded"
        request.allHTTPHeaderFields = headers
        
        print("url : \(urlComponents)")
        
        
//        let encoder = JSONEncoder()
//        do
//        {
//            let jsonData = try encoder.encode(thc)
//            request.httpBody = jsonData
//            print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
//        }
//        catch
//        {
//            completion(false,"unable to json encode")
//            return
//        }
        
        // Create and run a URLSession data task with our JSON encoded POST request
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request)
        {
            (responseData, response, responseError) in
            guard responseError == nil else
            {
                completion(false,responseError.debugDescription)
                return
            }
            // APIs usually respond with the data you just sent in your POST request
            if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
                print("response: ", utf8Representation)
            } else {
                print("no readable data received in response")
            }
        }
        task.resume()
        
    }
    
    
    
}
