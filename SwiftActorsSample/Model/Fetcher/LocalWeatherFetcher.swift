//
//  LocalWeatherFetcher.swift
//  SwiftActorsSample
//
//  Created by 荒木敦 on 2017/03/04.
//  Copyright © 2017年 WishMatch, Inc. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftTask
import ObjectMapper
import Keys

private let host = "http://samples.openweathermap.org/data/2.5/weather?q=London,uk&appid=b1b15e88fa797225412429c1c50c122a1"

struct LocalWeatherFetcher {
    let url: String
    let method: HTTPMethod
    let parameters: Parameters
    
    init(
        path: String,
        method: HTTPMethod = .get,
        parameters: Parameters = [:]
    ) {
        url = host + path
        self.method = method
        self.parameters = parameters
    }
    
    func request(
        success: @escaping (_ localWeather: LocalWeather)-> Void,
        fail: @escaping (_ error: Error?)-> Void
    ) {
        Alamofire.request(
            url,
            method: method,
            parameters: parameters
            ).responseObject { ( dataResponse:DataResponse<LocalWeather>) in
                switch dataResponse.result {
                case Result<LocalWeather>.success(let localWeather):
                    success(localWeather)
                case Result<LocalWeather>.failure(let error):
                    fail(error)
                }
        }
    }
}

//final class LocalWeatherFetcher: NSObject {
//    func getResponse() {
//        Alamofire.request(
//            host,
//            method: HTTPMethod = .get,
//            parameters: nil,
//            encoding: ParameterEncoding.JSON,
//            headers: nil
//            ).downloadProgress { (progress: Progress) in
//            
//        }
//        
//    }
//}


