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
    @State var hourlyForecast = [Hour]()
    @State var query: String = ""
    @State var contentSize: CGSize = .zero
    @State var textFieldHeight = 15.0
    
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
                        await fetchWeather(query: "")
                }
            }
        } else {
            VStack{
                Spacer()
                //track height of textfield according to keyboard
                TextField("Enter the city name", text: $query,onEditingChanged: getFocus)
                    .textFieldStyle(PlainTextFieldStyle())
                    .background(
                        Rectangle()
                            .foregroundStyle(.white.opacity(0.2))
                            .cornerRadius(25)
                            .frame(height: 50)
                    )
                    .padding(.leading,40)
                    .padding(.trailing,40)
                    .padding(.bottom,15)
                    .padding(.top, textFieldHeight)
                    .multilineTextAlignment(.center)
                    .tint(.white)
                    .font(Font.system(size: 20, design: .default))
                    .onSubmit {
                        Task {
                            await fetchWeather(query: query)
                            print("text is summited")
                        }
                        withAnimation {
                            textFieldHeight = 15
                            print("reduce textfieldheight")
                        }
                    }
                    
                
                Text(cityName)
                    .font(.system(size: 35))
                    .foregroundStyle(.white)
                    .bold()
                    .shadow(color: .black.opacity(0.2),
                            radius: 1, x: 0, y: 2)
                    .padding(.bottom, 1)
                Text("\(Date().formatted(date: .complete, time: .omitted))")
                    .font(.system(size: 16))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.2),
                            radius: 1, x: 0, y: 2)
                Text(weatherEmoji)
                    .font(.system(size: 110))
                    .shadow(color: .black.opacity(0.2),
                            radius: 1, x: 0, y: 2)
                Text("\(currentTemp)°C")
                    .font(.system(size: 50))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.2),
                            radius: 1, x: 0, y: 2)
                Text(conditionText)
                    .font(.system(size: 18))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.2),
                            radius: 1, x: 0, y: 2)
                Spacer()
                Spacer()
                Spacer()
                
                Text("Hourly Forecast")
                    .font(.system(size: 17))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.2),
                            radius: 1, x: 0, y: 2)
                    .bold()
                    .padding(.top,12)
                
                ScrollView(.horizontal,showsIndicators: false ) {
                    HStack{
                        ForEach(hourlyForecast) { forecast in
                            VStack {
                                Text("\(getShortTime(time: forecast.time))")
                                    .shadow(color: .black.opacity(0.2),
                                             radius: 1, x: 0, y: 2)
                                Text("\(getWeatherEmoji(code: forecast.condition.code))")
                                    .shadow(color: .black.opacity(0.2),
                                             radius: 1, x: 0, y: 2)
                                Text("\(Int(forecast.temp_c))°C")
                            }
                            .frame(width: 50, height: 90)
                        }
                        Spacer()
                    }
                    .background(Color.white.blur(radius: 75).opacity(15))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                .padding(.top,.zero)
                .padding(.leading, 18)
                .padding(.trailing, 18)
                
                Text("3 Day Forecast")
                    .font(.system(size: 22))
                    .foregroundStyle(.white)
                    .bold()
                
                List(results) { forecast in
                    HStack(alignment: .center, spacing: nil) {
                        Text("\(getShortDate(epoch: forecast.date_epoch))")
                            .frame(maxWidth: 50, alignment: .leading)
                            .bold()
                        Text("\(getWeatherEmoji(code: forecast.day.condition.code))")
                            .frame(maxWidth: 30, alignment: .leading)
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
                    .shadow(color: .black.opacity(0.2),
                            radius: 1, x: 0, y: 2)
            }
            .background(backgroundColor)
            .frame(width: .infinity, height: .infinity, alignment: .topLeading)
        }
    }
}

#Preview {
    WeatherView()
}

extension WeatherView {
    
    func getFocus(focused: Bool) {
        withAnimation {
            textFieldHeight = 130
        }
    }
    
    func fetchWeather(query: String) async {
        var queryText = query
        if (queryText == "") {
            queryText = "http://api.weatherapi.com/v1/forecast.json?key=6c9f65c397a04f7b88b113731242910&q=Bangkok&days=3&aqi=no&alerts=no"
        } else {
            queryText = "http://api.weatherapi.com/v1/forecast.json?key=6c9f65c397a04f7b88b113731242910&q=\(query)&days=3&aqi=no&alerts=no"
        }
        
        let request = AF.request(queryText)
        request.responseDecodable(of: Weather.self) { response in
            //handler
            switch response.result {
            case .success(let weather) :
                cityName = weather.location.name
                results = weather.forecast.forecastday
                
                // if date1 in fetched data != date now, set index to 1
                var index = 0
                if Date(timeIntervalSince1970: TimeInterval(results[0].date_epoch)).formatted(Date.FormatStyle().weekday(.abbreviated)) != Date().formatted(Date.FormatStyle().weekday(.abbreviated)) {
                    index = 1
                }
                
                currentTemp = Int(results[index].day.avgtemp_c)
                hourlyForecast = results[index].hour
                backgroundColor = getBackgroundColor(code: results[index].day.condition.code)
                weatherEmoji = getWeatherEmoji(code: results[index].day.condition.code)
                conditionText = results[index].day.condition.text
                loading = false
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
   
    
}//end
