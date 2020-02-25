//
//  WeatherServiceContract.swift
//  ZuluMachineWeatherApp
//
//  Created by Sipho Motha on 2020/02/22.
//  Copyright © 2020 ZuluMachine House. All rights reserved.
//

import Foundation
import CoreLocation

public protocol WeatherServiceContract {
    func getCurrentWeather(completion: @escaping (WeatherServiceResponse?) -> (), coordinate: CLLocationCoordinate2D, dispatchGroup: DispatchGroup)
    
    func getMultiWeather(completion: @escaping (MultiWeatherServiceResponse?) -> (), coordinate: CLLocationCoordinate2D, dispatchGroup: DispatchGroup)
}
