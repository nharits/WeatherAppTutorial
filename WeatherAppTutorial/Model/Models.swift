//
//  JSONmodel.swift
//  WeatherAppTutorial
//
//  Created by haritS on 30/10/2567 BE.
//

import SwiftUI

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
    var hour: [Hour]
}

struct Day: Codable {
    var avgtemp_c: Double
    var condition: Condition
}

struct Condition: Codable {
    var text: String
    var code: Int
}

struct Hour: Codable, Identifiable {
    var time_epoch: Int
    var time: String
    var temp_c: Double
    var condition: Condition
    var id: Int { time_epoch }
}

/*
        VStack{
            Spacer()
            Text(cityName)
                .font(.system(size: 35))
                .foregroundStyle(.white)
                .bold()
            Text("\(Date().formatted(date: .complete, time: .omitted))")
                .font(.system(size: 18))
                .foregroundStyle(.white)
            Text(weatherEmoji)
                .font(.system(size: 180))
                .shadow(radius: 75)
            Text("\(currentTemp)°C")
                .font(.system(size: 70))
                .foregroundStyle(.white)
                .bold()
            Text(conditionText)
                .font(.system(size: 22))
                .foregroundStyle(.white)
                .bold()
            Spacer()
            Spacer()
            Spacer()
            List(results) { forecast in
                HStack(alignment: .center, spacing: nil) {
                    Text("\(getShortDate(epoch: forecast.date_epoch))")
                        .frame(maxWidth: 50, alignment: .leading)
                        .bold()
                    Text("\(getWeatherEmoji(code: forecast.day.condition.code))").frame(maxWidth: 30, alignment: .leading)
                    Text("\(Int(forecast.day.avgtemp_c))°C")
                        .frame(maxWidth: 50, alignment: .leading)
                    Spacer()
                    Text("\(forecast.day.condition.text)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .listRowBackground(Color.white.blur(radius: 75).opacity(0.5))
                //.listRowSeparator(.hidden)
            }
            .contentMargins(.vertical,0)
            .scrollContentBackground(.hidden)
            .preferredColorScheme(.dark)
            Spacer()
            Text("Data supplied by Weather API")
                .font(.system(size: 14))
                .foregroundStyle(.white)
        }
        .background(backgroundColor)
        .frame(width: .infinity, height: .infinity, alignment: .topLeading)
        .task {
            await fetchWeather()
        }
*/
