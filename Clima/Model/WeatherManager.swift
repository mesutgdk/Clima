//
//  SceneDelegate.swift
//  Clima
//
//  Created by mesut on 14.10.2022.

import UIKit
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather (_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error) 
}
struct WeatherManager {
    let weatherURL =
        "https://api.openweathermap.org/data/2.5/weather?&appid=3624c94118857997b2e84b137581e05f&units=metric"
    
    var delegate: WeatherManagerDelegate?
  
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
       //  print(urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
         // print(urlString) // arama butonuyla girilen url
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    //print(error!)
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
        }
            task.resume()
        }
    }
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedDate = try decoder.decode(WeatherData.self, from: weatherData)
             let id = decodedDate.weather[0].id
            let temp = decodedDate.main.temp
            let name = decodedDate.name
            
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            
            //let image = weather.conditionName
            //let tempDecimal = weather.temperatureString
            
            //print(image, tempDecimal, name)
            
        }catch {
            delegate?.didFailWithError(error: error)
            //print(error)
            return nil
        }
      
    }
    
  
    }
    
