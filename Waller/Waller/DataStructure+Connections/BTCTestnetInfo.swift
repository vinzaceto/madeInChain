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

struct WalletBalance:Codable
{
    let hash160:String
    let address:String
    let n_tx:UInt32
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
    func getWalletBalance(address:String) -> WalletBalance?
    {
        let url = URL(string: "https://testnet.blockchain.info/it/rawaddr/\(address)")!
        let request = URLRequest(url: url)
        let semaphore = DispatchSemaphore(value: 0)
        var data: Data? = nil
        
        URLSession.shared.dataTask(with: request)
        {
            (responseData, _, _) -> Void in
            data = responseData
            semaphore.signal()
        }.resume()
        semaphore.wait(timeout: .distantFuture)

        let reply = data.flatMap { String(data: $0, encoding: .utf8) } ?? ""
        //print(reply)
        
        let decoder = JSONDecoder()
        do
        {
            let decodedResponse = try decoder.decode(WalletBalance.self, from: data!)
            return decodedResponse
        }
        catch
        {
            print("error converting data to JSON")
            return nil
        }
    }

    
    func unspentOutputsWithAddress(address:String) -> [BTCTransactionOutput]?
    {
        let url = URL(string: "https://testnet.blockchain.info/unspent?active=\(address)")!
        let request = URLRequest(url: url)
        let semaphore = DispatchSemaphore(value: 0)
        var data: Data? = nil
        
        URLSession.shared.dataTask(with: request)
        {
            (responseData, _, _) -> Void in
            data = responseData
            semaphore.signal()
        }.resume()
        semaphore.wait(timeout: .distantFuture)
        
        let reply = data.flatMap { String(data: $0, encoding: .utf8) } ?? ""
        print(reply)
        
        let decoder = JSONDecoder()
        do
        {
            let decodedResponse = try decoder.decode(BTCUnspentRespose.self, from: data!)
            return unspentOutputsForResponseData(data: decodedResponse.unspent_outputs)
        }
        catch
        {
            print("error converting data to JSON")
            return nil
        }
        return nil
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

    
    
    func requestForTransactionBroadcastWithData(data:NSData) -> NSMutableURLRequest?
    {
        if data.length == 0 {return nil}
        let urlstring = "https://blockchain.info/pushtx"
        let request = NSMutableURLRequest.init(url: URL.init(string: urlstring)!)
        request.httpMethod = "POST"
        let form = "tx=\(BTCHexFromData(Data.init(referencing: data)))"
        request.httpBody = form.data(using: .utf8)
        return request
    }
    
    func broadcastTransactionData(data:NSData,error:NSError?)
    {

        let request = requestForTransactionBroadcastWithData(data: data)
        var data: Data? = nil
        let session = URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)

        session.dataTask(with: request! as URLRequest)
        {
            (responseData, _, _) -> Void in
            data = responseData
            semaphore.signal()
        }.resume()
        semaphore.wait(timeout: .distantFuture)
        
        let reply = data.flatMap { String(data: $0, encoding: .utf8) } ?? ""
        print(reply)
    }
    
    
/*
 
     
     

     - (BOOL) broadcastTransactionData:(NSData*)data error:(NSError**)errorOut {
     NSURLRequest* req = [self requestForTransactionBroadcastWithData:data];
     NSURLResponse* response = nil;
     NSData* resultData = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:errorOut];
     if (!resultData) {
     return NO;
     }
     
     // TODO: parse the response to determine if it was successful or not.
     
     return YES;
     }
     

 
 */
    
    
}
