//
//  WeatherMainViewContract.swift
//  ZuluMachineWeatherApp
//
//  Created by Sipho Motha on 2020/02/19.
//  Copyright © 2020 ZuluMachine House. All rights reserved.
//

import Foundation

public protocol WeatherMainViewContract {
    func updatedCurrentWeather(currentTemp: String, minTemp: String, maxTemp: String, weatherDescription: String)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showRetryErrorState()
}

