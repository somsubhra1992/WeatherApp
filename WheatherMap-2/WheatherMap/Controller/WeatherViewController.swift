//
//  WeatherViewController.swift
//  WheatherMap
//
//  Created by Somsubhra Dasgupta on 10/04/21.
//  Copyright © 2021 Somsubhra. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    
    
    var latitude : Double = 0
    var longitude : Double = 0
    var locationName : String = ""
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var rainChangesLabel: UILabel!
    @IBOutlet weak var weeklyWeatherDetailsCollectionView: UICollectionView!
    @IBOutlet weak var weeklyForeCastTableView: UITableView!
    
    
    var weatherModel : WeatherModel?
    var currentDate : String = ""
    var currentTime : String = ""
    var currentWeatherForecastInfo : [WeatherInfoModel]?
    var weeklyWeatherForecastInfo : [WeatherInfoModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.fetchWeatherInfoDetials()

    }
    
    func fetchWeatherInfoDetials()
    {
        Datamanager.shared.fetchWeatherInfo(for: self.latitude, long: self.longitude) { [weak self](weatherModel) in
            
            if let wthrModel = weatherModel
            {
                self?.determineCurrentDate()
                self?.weatherModel = wthrModel
                self?.updateUIWithData()
            }
            
        }
        
    }
    
    func determineCurrentDate()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let currentDate = Date()
        let dateString = dateFormatter.string(from: currentDate)
        if let dateCompStr = dateString.components(separatedBy: " ").first,
            let timeCompStr = dateString.components(separatedBy: " ").last
        {
            self.currentDate = dateCompStr
            let timeCompArray = timeCompStr.components(separatedBy: ":")
            
            if let hourComp = timeCompArray.first,
                let hourIntComp = Int(hourComp)
            {
                let modHour = hourIntComp%3
                let hourToConsider = hourIntComp-modHour
                self.currentTime = "\(hourToConsider):00:00"
            }
            
            
        }
        
    }
    
    func updateUIWithData()
    {
        self.currentWeatherForecastInfo = self.weatherModel?.weatherInfoList.filter({$0.date == self.currentDate})
        self.weeklyWeatherForecastInfo = self.weatherModel?.weatherInfoList.filter({$0.date != self.currentDate && $0.time == self.currentTime})
        
        DispatchQueue.main.async {

            if let midDayTempDict = self.currentWeatherForecastInfo?.filter({$0.time == self.currentTime}).first,
                let city = self.weatherModel?.city.name,
                let weather = midDayTempDict.weatherInfo.first?.weather,
                let temp = midDayTempDict.main["temp"] as? Double,
                let humidity = midDayTempDict.main["humidity"],
                let windSpeed = midDayTempDict.wind["speed"] as? Double
            {
                self.cityName.text = locationName
                self.weatherLabel.text = weather
                self.tempLabel.text = String(format: "%.2f°C", temp-273)
                self.humidityLabel.text = "\(humidity)"
                self.rainChangesLabel.text = "NA"
                self.windLabel.text = "\(windSpeed)"
                self.weatherIcon.image = UIImage.init(named: midDayTempDict.weatherInfo.first?.updateWeatherIcon() ?? "Cloud-Refresh")
                self.weeklyWeatherDetailsCollectionView.reloadData()
                self.weeklyForeCastTableView.reloadData()
            }



        }
        
    }

}

extension WeatherViewController : UICollectionViewDelegate, UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.currentWeatherForecastInfo?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellView", for: indexPath)
        
        if let customCell = cell as? CustomCollectionViewCell
        {
            if let weatherDict = self.currentWeatherForecastInfo?[indexPath.row],
                let weather = weatherDict.weatherInfo.first?.weather,
                let temp = weatherDict.main["temp"],
                let time = weatherDict.time as? String
            {
                customCell.weatherIcon.image = UIImage.init(named: weatherDict.weatherInfo.first?.updateWeatherIcon() ?? "Cloud-Refresh")
//                customCell.weatherLabel.text = self.weatherModel?.weatherInfo.first?.weather
                customCell.tempLabel.text = "\(Int(temp)-273)°C"
                customCell.humidityLabel.text = time
            }

            return customCell
            
        }
        
        return cell
        
    }
    
    
}

extension WeatherViewController : UITableViewDelegate, UITableViewDataSource
{
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.weeklyWeatherForecastInfo?.count ?? 0
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellView", for: indexPath)

        if let weeklyForecastCell = cell as? WeeklyForcastTableViewCell
        {
            if let forecastDict = self.weeklyWeatherForecastInfo?[indexPath.row],
                let temp = self.weeklyWeatherForecastInfo?[indexPath.row].main["temp"],
                let humidity = self.weeklyWeatherForecastInfo?[indexPath.row].main["humidity"],
                let windSpeed = self.weeklyWeatherForecastInfo?[indexPath.row].wind["speed"],
                let windDeg = self.weeklyWeatherForecastInfo?[indexPath.row].wind["deg"]
            {
                weeklyForecastCell.daylabel.text = self.weeklyWeatherForecastInfo?[indexPath.row].date
                weeklyForecastCell.tempLabel.text = "\(Int(temp)-273)°C"
                weeklyForecastCell.humidityLabel.text = "\(humidity)"
                weeklyForecastCell.windLabel.text = "\(windSpeed) - \(windDeg)°"
                
                weeklyForecastCell.weatherIcon.image = UIImage.init(named: forecastDict.weatherInfo.first?.updateWeatherIcon() ?? "Cloud-Refresh")
                
                return weeklyForecastCell;
            }

        }
        
        return cell
    }
}


class CustomCollectionViewCell : UICollectionViewCell
{
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
}


class WeeklyForcastTableViewCell : UITableViewCell
{
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var daylabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
}
