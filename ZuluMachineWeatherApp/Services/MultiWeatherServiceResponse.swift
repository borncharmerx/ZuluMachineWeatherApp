//
//  MultiWeatherServiceResponse.swift
//  ZuluMachineWeatherApp
//
//  Created by Sipho Motha on 2020/02/22.
//  Copyright © 2020 ZuluMachine House. All rights reserved.
//

import Foundation

// MARK: - MultiWeatherServiceResponse
public struct MultiWeatherServiceResponse: Codable {
    let cod: String?
    let message: Double?
    let cnt: Int?
    let list: [WeatherServiceResponse]?
    let city: City?
}

// MARK: - City
struct City: Codable {
    let id: Int?
    let name: String?
    let coord: Coord?
    let country: String?
}
