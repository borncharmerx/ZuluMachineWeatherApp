//
//  WeatherMainViewModel.swift
//  ZuluMachineWeatherApp
//
//  Created by Sipho Motha on 2020/02/19.
//  Copyright © 2020 ZuluMachine House. All rights reserved.
//

import Foundation

class WeatherMainViewModel {
    let view: WeatherMainViewContract
    
     init(with view: WeatherMainViewContract) {
        self.view = view
    }
}
