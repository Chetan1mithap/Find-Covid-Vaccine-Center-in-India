
//
//  APIManager.swift
//  Created by Dev01 on 16/06/21.
//  Copyright © 2021 Dev01. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


let baseUrl = "https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/findByPin?"

let sessionheaders : HTTPHeaders = [
    "Content-Type" : "application/json",
    "Accept-Language": "hi_IN"
]

class ServiceHelper: NSObject {
    class var sharedInstance: ServiceHelper {
        struct Static {
            static let instance: ServiceHelper = ServiceHelper()
        }
        return Static.instance
    }
    
    // Getting response as Data
    func callAPIForGetMethod(_ apiName: String, completionBlock: @escaping (Data?, NSError?,String?,String?) -> Void) {
        
        if (isReachable() == false) {
            let error = NSError()
            let message = "No internet connection"
            completionBlock(nil,error,message, "0")
            return
        }
        
        let url = URL(string: "\(baseUrl)\(apiName)")!
        print(msg: "\(url)")
        
        AF.request(url, method: .get,encoding: JSONEncoding.default, headers: sessionheaders) .response { response in
            let error = response.error
            if error != nil {
                print(msg: "error    \(String(describing: error))")
                completionBlock(nil,error as NSError?,nil, nil)
                return
            } else {
                guard let result = response.data else{
                    completionBlock(nil,error as NSError?,nil, nil)
                    return
                }
                
                let res = dataToJson(data: result)
                print(res)
                
                if let status = response.response?.statusCode {
                    switch(status) {
                    case 200:
                        //Success
                        completionBlock(result,nil,nil, "200")
                        break
                    default:
                        completionBlock(nil,error as NSError?,nil,"500")
                        break
                    }
                }
            }
        }
    }
}

func dataToJson(data: Data) -> [String: Any]{
    var dataJson = [String: Any]()
    do {
        // make sure this JSON is in the format we expect
        guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
            return [:]
        }
        dataJson = json
    }
    catch let error as NSError {
        print("Failed to load: \(error.localizedDescription)")
    }
    return dataJson
}


func isReachable() -> Bool {
    if NetworkState.isConnected() {
        print("Internet is available.")
        return true
    }
    return false
}

class NetworkState {
    class func isConnected() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

extension ContentView{
    func callApiToGetAllCenter(pincode:String, date: Date) {
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "dd-MM-yyyy"
        let date1 = (formatter3.string(from: date))
       
        ServiceHelper.sharedInstance.callAPIForGetMethod("pincode=\(pincode)&date=\(date1)", completionBlock: { (response,_,_,status)  in
            if status == "200"{
            
            guard let responseData = response else { return }
            
            self.slotDataArray.removeAll()
            self.filterDataArray.removeAll()
            
            do {
                let decoder = JSONDecoder()
                let data = try decoder.decode(DataInfo.self, from: responseData)
                
                for dat in data.sessions!{
                    self.slotDataArray.append(dat)
                }
                
                if slotDataArray.count > 0{
                    filterDataArray = slotDataArray
                    ageLimit = "All"
                    feeType = "All"
                }else{
                    showAlert.toggle()
                }
            } catch DecodingError.keyNotFound(let key, let context) {
                Swift.print("could not find key \(key) in JSON: \(context.debugDescription)")
            } catch DecodingError.valueNotFound(let type, let context) {
                Swift.print("could not find type \(type) in JSON: \(context.debugDescription)")
            } catch DecodingError.typeMismatch(let type, let context) {
                Swift.print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
            } catch DecodingError.dataCorrupted(let context) {
                Swift.print("data found to be corrupted in JSON: \(context.debugDescription)")
            } catch let error as NSError {
                NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
            }
            }
        })
    }
}


