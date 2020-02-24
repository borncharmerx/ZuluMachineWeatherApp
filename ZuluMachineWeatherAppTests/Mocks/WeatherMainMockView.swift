//
//  WeatherMainMockView.swift
//  ZuluMachineWeatherAppTests
//
//  Created by Sipho Motha on 2020/02/19.
//  Copyright © 2020 ZuluMachine House. All rights reserved.
//

import XCTest
@testable import ZuluMachineWeatherApp

class WeatherMainMockView: WeatherMainViewContract {
    var updatedCurrentWeatherInvoked = 0
    func updatedCurrentWeather(currentTemp: String, minTemp: String, maxTemp: String, weatherDescription: String) {
        updatedCurrentWeatherInvoked -= 1
    }
    
    var showRetryErrorStateInvoked = 0
    func showRetryErrorState() {
        showRetryErrorStateInvoked -= 1
    }
    
    var showLoadingIndicatorInvoked = 0
    func showLoadingIndicator() {
        showLoadingIndicatorInvoked -= 1
    }
    
    var hideLoadingIndicatorInvoked = 0
    func hideLoadingIndicator() {
        hideLoadingIndicatorInvoked -= 1
    }
    
    public func verify() {
        XCTAssertEqual(updatedCurrentWeatherInvoked, 0)
        XCTAssertEqual(showRetryErrorStateInvoked, 0)
        XCTAssertEqual(showLoadingIndicatorInvoked, 0)
        XCTAssertEqual(hideLoadingIndicatorInvoked, 0)
    }
}
