//
//  WeatherView.swift
//  WeatherAppTutorial
//
//  Created by haritS on 30/10/2567 BE.
//

import SwiftUI
import Alamofire

struct WeatherView: View {
    
    @State private var results = [ForecastDay]()
    
    @State var backgroundColor = Color.init(red: 135/255, green: 206/255, blue: 235/255)
    @State var weatherEmoji = "☀️"
    @State var currentTemp = 0
    @State var conditionText = "Slightly Overcast"
    @State var cityName = "Toronto"
    @State var loading = true
    
    
    var body: some View {
        
        if loading {
            ZStack {
                Color.init(backgroundColor)
                    .ignoresSafeArea()
                ProgressView()
                    .scaleEffect(2, anchor: .center)
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .task {
                    await fetchWeather()
                }
            }
        } else {
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
        }
        
//        VStack{
//            Spacer()
//            Text(cityName)
//                .font(.system(size: 35))
//                .foregroundStyle(.white)
//                .bold()
//            Text("\(Date().formatted(date: .complete, time: .omitted))")
//                .font(.system(size: 18))
//                .foregroundStyle(.white)
//            Text(weatherEmoji)
//                .font(.system(size: 180))
//                .shadow(radius: 75)
//            Text("\(currentTemp)°C")
//                .font(.system(size: 70))
//                .foregroundStyle(.white)
//                .bold()
//            Text(conditionText)
//                .font(.system(size: 22))
//                .foregroundStyle(.white)
//                .bold()
//            Spacer()
//            Spacer()
//            Spacer()
//            List(results) { forecast in
//                HStack(alignment: .center, spacing: nil) {
//                    Text("\(getShortDate(epoch: forecast.date_epoch))")
//                        .frame(maxWidth: 50, alignment: .leading)
//                        .bold()
//                    Text("\(getWeatherEmoji(code: forecast.day.condition.code))").frame(maxWidth: 30, alignment: .leading)
//                    Text("\(Int(forecast.day.avgtemp_c))°C")
//                        .frame(maxWidth: 50, alignment: .leading)
//                    Spacer()
//                    Text("\(forecast.day.condition.text)")
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                }
//                .listRowBackground(Color.white.blur(radius: 75).opacity(0.5))
//                //.listRowSeparator(.hidden)
//            }
//            .contentMargins(.vertical,0)
//            .scrollContentBackground(.hidden)
//            .preferredColorScheme(.dark)
//            Spacer()
//            Text("Data supplied by Weather API")
//                .font(.system(size: 14))
//                .foregroundStyle(.white)
//        }
//        .background(backgroundColor)
//        .frame(width: .infinity, height: .infinity, alignment: .topLeading)
//        .task {
//            await fetchWeather()
//        }
    }
}

#Preview {
    WeatherView()
}

extension WeatherView {
    
    func fetchWeather() async {
        let request = AF.request("http://api.weatherapi.com/v1/forecast.json?key=6c9f65c397a04f7b88b113731242910&q=London&days=3&aqi=no&alerts=no")
        request.responseDecodable(of: Weather.self) { response in
            //handler
            switch response.result {
            case .success(let weather) :
                cityName = weather.location.name
                results = weather.forecast.forecastday
                currentTemp = Int(results[0].day.avgtemp_c)
                backgroundColor = getBackgroundColor(code: results[0].day.condition.code)
                weatherEmoji = getWeatherEmoji(code: results[0].day.condition.code)
                conditionText = results[0].day.condition.text
                loading = false
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
   
    
}//end
