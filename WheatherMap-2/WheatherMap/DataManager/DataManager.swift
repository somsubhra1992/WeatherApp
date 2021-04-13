//
//  DataManager.swift
//  WheatherMap
//
//  Created by Somsubhra Dasgupta on 12/04/21.
//  Copyright © 2021 Somsubhra. All rights reserved.
//

import Foundation

class Datamanager : NSObject
{
    let WEATHER_URL = "https://api.openweathermap.org/data/2.5/forecast"
    let APP_ID = "fae7190d7e6433ec3a45285ffcf55c86"
    
    public static let shared = Datamanager()
        
    private override init()
    {
        super.init()
    }
    
    func generateURL(using lat: Double, long: Double) -> URL?
    {
        let urlString = "\(WEATHER_URL)?lat=\(lat)&lon=\(long)&appid=\(APP_ID)"
        return URL.init(string: urlString) ?? nil
    }
    
    func fetchWeatherInfo(for lat:Double, long: Double, completionHandler: @escaping (WeatherModel?) -> Void)
    {
        if let url = generateURL(using: lat,long: long)
        {
            let dataTask = URLSession.shared.dataTask(with: url){ (data, response, error) in
                if error == nil
                {
                    let decoder = JSONDecoder()
                    
                    guard let weatherInfo = try? decoder.decode(WeatherModel.self, from: data!) as WeatherModel else {
                       return
                    }
                    
                    completionHandler(weatherInfo)
                    print(response)
                }
                else
                {
                    print(error)
                }
            }
            dataTask.resume()
        }
       
        
        
    }
    
}
