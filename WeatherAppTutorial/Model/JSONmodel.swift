//
//  JSONmodel.swift
//  WeatherAppTutorial
//
//  Created by haritS on 30/10/2567 BE.
//

import Foundation

struct Weather: Codable {
    //
    var location: Location
    var forecast: Forecast
}

struct Location: Codable {
    var name: String
}

struct Forecast: Codable {
    var forecastday: [ForecastDay]
}

struct ForecastDay: Codable,Identifiable {
    var date_epoch: Int
    var id: Int { return date_epoch }
    var day: Day
}

struct Day: Codable {
    var avgtemp_c: Double
    var condition: Condition
}

struct Condition: Codable {
    var text: String
}
