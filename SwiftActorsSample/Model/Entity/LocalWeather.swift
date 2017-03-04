//
//  Pepositories.swift
//  SwiftActorsSample
//
//  Created by 荒木敦 on 2017/03/04.
//  Copyright © 2017年 WishMatch, Inc. All rights reserved.
//

import Foundation
import ObjectMapper

struct LocalWeather: Mappable {
    var cood: cood?
    var weather: [weather]?
    var base: String?
    var main: main?
    var name: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        cood <- map["cood"]
        weather <- map["weather"]
        base <- map["base"]
        main <- map["main"]
        name <- map["name"]
    }
}

struct cood: Mappable {
    var lon: Double?
    var lat: Double?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        lon <- map["lon"]
        lat <- map["lat"]
    }
}

struct weather: Mappable {
    var id: Int?
    var main: String?
    var description: String?
    var icon: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        main <- map["main"]
        description <- map["description"]
        icon <- map["icon"]
    }
}

struct main: Mappable {
    var temp: Double?
    var pressure: Double?
    var humidity: Double?
    var temp_min: Double?
    var temp_max: Double?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        temp <- map["temp"]
        pressure <- map["pressure"]
        humidity <- map["humidity"]
        temp_min <- map["temp_min"]
        temp_max <- map["temp_max"]
    }
}

