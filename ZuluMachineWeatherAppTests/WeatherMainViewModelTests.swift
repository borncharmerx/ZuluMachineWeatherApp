//
//  WeatherMainViewModelTests.swift
//  ZuluMachineWeatherAppTests
//
//  Created by Sipho Motha on 2020/02/19.
//  Copyright © 2020 ZuluMachine House. All rights reserved.
//

import XCTest
@testable import ZuluMachineWeatherApp

class WeatherMainViewModelTests: XCTestCase {
    var viewModel: WeatherMainViewModel?
    var mockView: WeatherMainMockView?
    override func setUp() {
        super.setUp()
        mockView = WeatherMainMockView()
        viewModel = WeatherMainViewModel(with: mockView!)
    }
    

    func testShouldLoadCurrenWearther() {
       // viewModel.LoadCurrentService(with: )
    }
}
