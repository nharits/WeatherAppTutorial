//
//  WeatherDetails.swift
//  WeatherAppTutorial
//
//  Created by haritS on 4/11/2567 BE.
//

import SwiftUI

struct WeatherDetails: View {
    
    @Binding var results: [ForecastDay]
    @Binding var cityName: String
    var index: Int
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

//#Preview {
//    WeatherDetails()
//}
