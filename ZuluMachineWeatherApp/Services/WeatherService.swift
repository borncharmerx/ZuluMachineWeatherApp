//
//  WeatherService.swift
//  ZuluMachineWeatherApp
//
//  Created by Sipho Motha on 2020/02/22.
//  Copyright © 2020 ZuluMachine House. All rights reserved.
//

import Foundation
import CoreLocation

public class WeatherService: WeatherServiceContract {
    private var currentLocationServiceURLComponents = NSURLComponents(string: "https://api.openweathermap.org/data/2.5/weather")
    private var currentLocationMultiServiceURLComponents = NSURLComponents(string: "https://api.openweathermap.org/data/2.5/forecast")
    private let appID = "010c8726e2730d03286f1f1cdc4dbf12"
    public func getCurrentWeather(completion: @escaping (WeatherServiceResponse?) -> (), coordinate: CLLocationCoordinate2D, dispatchGroup: DispatchGroup) {
        dispatchGroup.enter()
        currentLocationServiceURLComponents?.queryItems = [
            URLQueryItem(name: "lat", value: String(coordinate.latitude)),
            URLQueryItem(name: "lon", value: String(coordinate.longitude)),
            URLQueryItem(name: "appid", value: appID),
            URLQueryItem(name: "units", value: "metric")
        ]
        
        if let url = currentLocationServiceURLComponents?.url {
            URLSession.shared.dataTask(with: url) { data, res, err in
                dispatchGroup.leave()
                
                if let data = data,
                    let weatherServiceResponse = try? JSONDecoder().decode(WeatherServiceResponse.self, from: data) {
                    completion(weatherServiceResponse)
                }
            }.resume()
        }
    }
    
    public func getMultiWeather(completion: @escaping (MultiWeatherServiceResponse?) -> (), coordinate: CLLocationCoordinate2D, dispatchGroup: DispatchGroup) {
        dispatchGroup.enter()
        currentLocationMultiServiceURLComponents?.queryItems = [
            URLQueryItem(name: "lat", value: String(coordinate.latitude)),
            URLQueryItem(name: "lon", value: String(coordinate.longitude)),
            URLQueryItem(name: "appid", value: appID),
            URLQueryItem(name: "units", value: "metric"),
        ]
        
        if let url = currentLocationMultiServiceURLComponents?.url {
            URLSession.shared.dataTask(with: url) { data, res, err in
                dispatchGroup.leave()
                
                if let data = data,
                    let multiWeatherServiceResponse = try? JSONDecoder().decode(MultiWeatherServiceResponse.self, from: data) {
                    //Must save information for offline use
                    completion(multiWeatherServiceResponse)
                }
                
            }.resume()
        }
    }
}
