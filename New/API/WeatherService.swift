//
//  WeatherManager.swift
//  New
//
//  Created by Dmytro Yurchenko on 21.03.2023.
//

import UIKit
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: [WeatherModel])
    func didFailWithError(_ error: Error)
}

struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    
    let network = NetworkLayer()
    
    var weatherRequest = WeatherRequest()
    
    mutating func fetchWeather(cityName: String) {
        weatherRequest.path = "\(weatherRequest.path)&q=\(cityName)"
        performRequest()
    }
    
    mutating func fetchWeather(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        weatherRequest.path = "\(weatherRequest.path)&lat=\(lat)&lon=\(lon)"
        performRequest()
    }
    
    private func performRequest() {
        network.sendRequest(weatherRequest) { result in
            switch result {
            case .success(let response):
                var data = [WeatherModel]()
                response.list.map { weather in
                    let model = WeatherModel(id: weather.weather[0].id, city: response.city.name, temperature: weather.main.temp)
                    data.append(model)
                }
                self.delegate?.didUpdateWeather(self, weather: data)
            case .failure(let error):
                delegate?.didFailWithError(error)
            }
        }
    }
    
}

