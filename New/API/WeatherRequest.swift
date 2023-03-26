//
//  WeatherRequest.swift
//  New
//
//  Created by Dmytro Yurchenko on 23.03.2023.
//

import Foundation

struct WeatherRequest: Request {
    typealias Response = WeatherResponse
    
    var path: String = "https://api.openweathermap.org/data/2.5/forecast?appid=8022a936e09b18d1f6516299dcac53d8&units=metric"
    
    var method: HTTPMethod = .get
    
    var parameters: [String : Any]?

    var headers: [String : String]?
    
}
