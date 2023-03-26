//
//  WeatherData.swift
//  New
//
//  Created by Dmytro Yurchenko on 22.03.2023.
//

import Foundation

struct WeatherResponse: Decodable {
    let list: [WeatherData]
    let city: Location
}

struct WeatherData: Decodable {
    let main: Main
    let weather: [Weather]
}

struct Location: Decodable {
    let name: String
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let id: Int
}
