//
//  WeatherServiceMock.swift
//  ZuluMachineWeatherAppTests
//
//  Created by Sipho Motha on 2020/02/22.
//  Copyright © 2020 ZuluMachine House. All rights reserved.
//

import XCTest
import CoreLocation
@testable import ZuluMachineWeatherApp

class WeatherServiceMock: WeatherServiceContract {
    var getMultiWeatherInvoked = 0
    var multiWeatherServiceResponse: MultiWeatherServiceResponse?
    func getMultiWeather(completion: @escaping (MultiWeatherServiceResponse?) -> (), coordinate: CLLocationCoordinate2D, dispatchGroup: DispatchGroup) {
        getMultiWeatherInvoked -= 1
        completion(multiWeatherServiceResponse)
    }
    
    var getCurrentWeatherInvoked = 0
    var currentWeatherServiceResponse: WeatherServiceResponse?
    func getCurrentWeather(completion: @escaping (WeatherServiceResponse?) -> (), coordinate: CLLocationCoordinate2D, dispatchGroup: DispatchGroup) {
        getCurrentWeatherInvoked -= 1
        completion(currentWeatherServiceResponse)
    }
    
    public func verify() {
        XCTAssertEqual(getCurrentWeatherInvoked, 0, "getCurrentWeather was invoked")
        XCTAssertEqual(getMultiWeatherInvoked, 0, "getMultiWeather was invoked")
    }
}
