//
//  WeatherModel.swift
//  New
//
//  Created by Dmytro Yurchenko on 22.03.2023.
//

import Foundation

struct WeatherModel {
    let id: Int
    let city: String
    let temperature: Double
    
    var temperatureValue: String {
        return String(format: "%.1f", temperature)
    }
    
    var weatherConditionName: String {
        switch id {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud"
        default:
            return "sun.max"
        }
    }
    
}
