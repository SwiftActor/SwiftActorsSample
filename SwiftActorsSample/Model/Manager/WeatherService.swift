//
//  WeatherService.swift
//  SwiftActorsSample
//
//  Created by 荒木敦 on 2017/03/04.
//  Copyright © 2017年 WishMatch, Inc. All rights reserved.
//

import Foundation
import SwiftActors
import ObjectMapper
import Keys.SwiftActorsSampleKeys

class WeatherService {
    
    var tableView: UITableView
    
    var actorSystem:ActorSystem
    var downloaderActor: ActorRef
    var tableViewUpdateActor: ActorRef
    
    var weatherListModel = WeatherListModel()
    
    var weatherUrlArray = [
        "http://api.openweathermap.org/data/2.5/weather?q=London,uk&appid=" + SwiftActorsSampleKeys().openWeatherApiKey,
        "http://api.openweathermap.org/data/2.5/weather?q=Paris,fr&appid=" + SwiftActorsSampleKeys().openWeatherApiKey,
        "http://api.openweathermap.org/data/2.5/weather?q=Krakow,pl&appid=" + SwiftActorsSampleKeys().openWeatherApiKey,
        "http://api.openweathermap.org/data/2.5/weather?q=San+Francisco,us&appid=" + SwiftActorsSampleKeys().openWeatherApiKey,
        "http://api.openweathermap.org/data/2.5/weather?q=Paris,fr&appid=" + SwiftActorsSampleKeys().openWeatherApiKey,
        "http://api.openweathermap.org/data/2.5/weather?q=Berlin,de&appid=" + SwiftActorsSampleKeys().openWeatherApiKey,
    ]
    
    init(tableView:UITableView) {
        
        self.tableView = tableView
        
        self.actorSystem = ActorSystem()
        
        let tableViewUpdateActor = TableViewUpdateActor(
            actorSystem: self.actorSystem,
            weatherListModel: self.weatherListModel
        )
        
        tableViewUpdateActor.tableView = tableView
        
        self.tableViewUpdateActor = actorSystem.actorOf(actor: tableViewUpdateActor)
        
        let weatherDownloaderActor = WeatherDownloaderActor(actorSystem: self.actorSystem)
        weatherDownloaderActor.tableViewUpdateActor = self.tableViewUpdateActor
        
        self.downloaderActor = actorSystem.actorOf(actor: weatherDownloaderActor)
    }
    
    func loadAll() {
        for (index, weatherUrl) in weatherUrlArray.enumerated() {
            downloaderActor ! WeatherFetchMessage(url: weatherUrl, row: index)
        }
    }
}

class WeatherListModel {
    var localWeatherArray = [LocalWeather]()
    
    func setLocalWeather(localWeather: LocalWeather, position: Int) {
        localWeatherArray[position] = localWeather
    }
    
    func getLocalWeather(row: Int) -> LocalWeather {
        return localWeatherArray[row]
    }
    
    var localWeatherArrayCount: Int {
        get {
            return self.localWeatherArray.count
        }
    }
}

class TableViewUpdateActor : ActorUI {
    
    var tableView: UITableView?
    var weatherListModel: WeatherListModel
    
    required init(actorSystem: ActorSystem) {
        fatalError("init(actorSystem:) has not been implemented")
    }
    
    init(
        actorSystem: ActorSystem,
        weatherListModel: WeatherListModel
        ) {
        self.weatherListModel = weatherListModel
        super.init(actorSystem: actorSystem)
    }
    
    override func receive(message: Any) {
        guard let tableView = tableView else {
            // FIXME: - send Error report
            return
        }
        
        switch(message) {
            case let updateTableMessage as UpdateTableMessage:
                self.weatherListModel.localWeatherArray.append(updateTableMessage.localWeather)
//                let indexPath = IndexPath(row: updateTableMessage.row, section: 0)
//                tableView.reloadRows(at: [indexPath], with: .none)
//                print("Reloaded row \(message.row)")
                tableView.reloadData()
            default:
                tableView.reloadData()
        }
        
    }
}

class WeatherDownloaderActor : Actor {
    
    let config = URLSessionConfiguration.default
    let session: URLSession
    var tableViewUpdateActor: ActorRef?
//    var localWeatherArray = [LocalWeather]()
    
    required init(actorSystem: ActorSystem) {
        self.session = URLSession(configuration: self.config)
        super.init(actorSystem: actorSystem)
    }
    
    override func receive(message: Any) {
        switch (message) {
        case let weatherFetchMessage as WeatherFetchMessage:

            WeatherFetcher()
                .getResponse(url: weatherFetchMessage.url)
                .success { (localWeather: LocalWeather?) -> Void in
                    if let localWeather = localWeather {
                        
                        if let tableViewUpdateActor = self.tableViewUpdateActor {
                            tableViewUpdateActor ! UpdateTableMessage(localWeather: localWeather, row: weatherFetchMessage.row)
                        } else {
                            print("uiUpdateActor is nil")
                        }
                    } else {
                        // FIXME: - send error report
                        print("localWeather is nil")
                    }
                }
                .failure { (errorInfo: (error: Error?, isCancelled: Bool)) in
                    // FIXME: - send error report
                    if let error = errorInfo.error {
                        print("error = \(error)")
                    } else {
                        print("isCancelled = \(errorInfo.isCancelled)")
                    }
                }
        default:
            print("Unable to handle \(message)")
        }
    }
}

struct WeatherFetchMessage {
    let url: String
    let row: Int
}

struct UpdateTableMessage {
    let localWeather: LocalWeather
    let row: Int
}

