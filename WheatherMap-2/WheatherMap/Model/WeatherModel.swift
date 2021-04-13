//
//  WeatherModel.swift
//  WheatherMap
//
//  Created by Somsubhra Dasgupta on 11/04/21.
//  Copyright © 2021 Somsubhra. All rights reserved.
//

import UIKit

class WeatherModel: NSObject, Codable
{
    enum CodingKeys: String, CodingKey {
        case list, city
    }
    
    var weatherInfoList: [WeatherInfoModel]
    var city:City
    
    init(weatherInfoList: [WeatherInfoModel], city: City) {
        self.weatherInfoList = weatherInfoList
        self.city = city
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        weatherInfoList = try values.decode([WeatherInfoModel].self, forKey: .list)
        city = try values.decode(City.self, forKey: .city)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(weatherInfoList, forKey: .list)
        try container.encode(city, forKey: .city)
    }
}

class City: NSObject, Codable
{
    enum CodingKeys: String, CodingKey {
        case id, name
    }
    
    var id: Double
    var name:String
    
    init(id: Double, name: String) {
        self.id = id
        self.name = name
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(Double.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
    }
}

class WeatherInfoModel: NSObject, Codable{
    
    enum CodingKeys: String, CodingKey {
        case weather, main, visibility, wind, clouds, dt_txt
    }
    
    var weatherInfo: [WeatherIdInfoModel]
    var main: [String:Double]
    var visibility: Double
    var wind: [String:Double]
    var clouds : [String:Double]
    var date: String
    var time: String
    
    init(weather: [WeatherIdInfoModel], main: [String:Double], visibility: Double, wind: [String:Double], clouds : [String:Double], date: String, time:String) {
        self.weatherInfo = weather
        self.main = main
        self.visibility = visibility
        self.wind = wind
        self.clouds = clouds
        self.date = date
        self.time = time
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        weatherInfo = try values.decode([WeatherIdInfoModel].self, forKey: .weather)
        main = try values.decode([String:Double].self, forKey: .main)
        visibility = try values.decode(Double.self, forKey: .visibility)
        wind = try values.decode([String:Double].self, forKey: .wind)
        clouds = try values.decode([String:Double].self, forKey: .clouds)
        let dt_txt = try values.decode(String.self, forKey: .dt_txt)
        
        if let dtTxtArray = dt_txt.components(separatedBy: " ") as? [String],
            let dateCompoent = dtTxtArray.first,
            let timeComponent = dtTxtArray.last
        {
            date = dateCompoent
            time = timeComponent
        }
        else
        {
            date = ""
            time = ""
        }
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(weatherInfo, forKey: .weather)
        try container.encode(main, forKey: .main)
        try container.encode(visibility, forKey: .visibility)
        try container.encode(wind, forKey: .wind)
        try container.encode(clouds, forKey: .clouds)
    }
}

class WeatherIdInfoModel: NSObject, Codable{
    
    enum CodingKeys: String, CodingKey {
        case id, main, description, icon
    }
    
    var id: Double
    var weather: String
    var desc: String
    var icon: String
    
    
    init(id: Double, main: String, desc: String, icon: String) {
        self.id = id
        self.weather = main
        self.desc = desc
        self.icon = icon
        
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(Double.self, forKey: .id)
        weather = try values.decode(String.self, forKey: .main)
        desc = try values.decode(String.self, forKey: .description)
        icon = try values.decode(String.self, forKey: .icon)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(weather, forKey: .main)
        try container.encode(desc, forKey: .description)
        try container.encode(icon, forKey: .icon)
        
    }
    
    func updateWeatherIcon() -> String {
        
        switch (self.id) {
    
        case 0...300 :
            return "tstorm1"
        
        case 301...500 :
            return "light_rain"
        
        case 501...600 :
            return "shower3"
        
        case 601...700 :
            return "snow4"
        
        case 701...771 :
            return "fog"
        
        case 772...799 :
            return "tstorm3"
        
        case 800 :
            return "sunny"
        
        case 801...804 :
            return "cloudy2"
        
        case 900...903, 905...1000  :
            return "tstorm3"
        
        case 903 :
            return "snow5"
        
        case 904 :
            return "sunny"
        
        default :
            return "dunno"
        }

    }
}
