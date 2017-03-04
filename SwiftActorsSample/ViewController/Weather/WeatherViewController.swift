//
//  WeatherViewController.swift
//  SwiftActorsSample
//
//  Created by 荒木敦 on 2017/03/04.
//  Copyright © 2017年 WishMatch, Inc. All rights reserved.
//

import UIKit
import SwiftActors

class WeatherViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var localWeatherArray = [LocalWeather]()
    
    var weatherService: WeatherService?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 143
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // self.tableView.backgroundColor = UIColor.lightGray
        
        self.tableView.register(
            UINib(
                nibName : WeatherTableViewCell.className,
                bundle : nil
            ),
            forCellReuseIdentifier: WeatherTableViewCell.className
        )
        
        self.weatherService = WeatherService(tableView: self.tableView)
        
        guard let weatherService = self.weatherService else {
            // FIXME: - send error report
            return
        }
        
        weatherService.loadAll()
        
//        var parameters = [String : Any]()
//        parameters["q"] = "London,uk"
//        parameters["appid"] = "b1b15e88fa797225412429c1c50c122a1"
//        
//        let localWeatherFetcher = LocalWeatherFetcher(
//            path: "/data/2.5/weather",
//            method: .get,
//            parameters: parameters
//        )
//        
//        localWeatherFetcher.request(success: { (localWeather: LocalWeather) in
//            
//            self.localWeatherArray.append(localWeather)
//            print(self.localWeatherArray)
//            print(self.localWeatherArray.count)
//            self.tableView.reloadData()
//        }) { (error: Error?) in
//            if let error = error {
//                // FIXME: send error report
//                print(error.localizedDescription)
//            }
//            self.tableView.reloadData()
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let weatherService = self.weatherService else {
            return 0
        }
        
        return weatherService.weatherListModel.localWeatherArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let weatherTableViewCell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.className) as? WeatherTableViewCell else {
            // FIXME: send error report
            return UITableViewCell()
        }
        
        guard let weatherService = self.weatherService else {
            return UITableViewCell()
        }
        
//        let localWeather = localWeatherArray[indexPath.row]
        
        let localWeather = weatherService.weatherListModel.localWeatherArray[indexPath.row]
        
        weatherTableViewCell.cityNameLabel.text = localWeather.name
        
        if let main = localWeather.main,
        let temp_max =  main.temp_max {
            weatherTableViewCell.maxTemperatureLabel.text = String(temp_max)
        } else {
            weatherTableViewCell.maxTemperatureLabel.text = ""
        }
        
        if let main = localWeather.main,
        let temp_min =  main.temp_min {
            weatherTableViewCell.minTemperatureLabel.text = String(temp_min)
        } else {
            weatherTableViewCell.minTemperatureLabel.text = ""
        }
        
        return weatherTableViewCell
    }
}


extension WeatherViewController: UITableViewDelegate {
    
}
