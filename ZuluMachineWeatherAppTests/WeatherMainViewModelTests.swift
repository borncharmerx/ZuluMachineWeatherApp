//
//  WeatherMainViewModelTests.swift
//  ZuluMachineWeatherAppTests
//
//  Created by Sipho Motha on 2020/02/19.
//  Copyright © 2020 ZuluMachine House. All rights reserved.
//

import XCTest
import CoreLocation
@testable import ZuluMachineWeatherApp

class WeatherMainViewModelTests: XCTestCase {
    //TODO Added good mocking tool
    var viewModel: WeatherMainViewModel?
    var mockView: WeatherMainMockView?
    var mockService: WeatherServiceMock?
    
    override func setUp() {
        super.setUp()
        mockView = WeatherMainMockView()
        mockService = WeatherServiceMock()
        viewModel = WeatherMainViewModel(with: mockView!, service: mockService!)
    }
    
    override func tearDown() {
        mockView?.verify()
        mockService?.verify()
        super.tearDown()
    }
    
    func testLoadCurrenWeartherShouldHaveCurrentWeatherNotNil() {
        let coordinates = CLLocationCoordinate2D()
        mockService?.multiWeatherServiceResponse = getMockedMultiWeatherServiceResponse()
        mockService?.currentWeatherServiceResponse = getMockedWeatherServiceResponse()
        
        mockService?.getCurrentWeatherInvoked = 1
        mockService?.getMultiWeatherInvoked = 1
        mockView?.showLoadingIndicatorInvoked = 1
        mockView?.hideLoadingIndicatorInvoked = 1
        mockView?.updatedCurrentWeatherInvoked = 1
        
        viewModel?.loadWeather(coordinate: coordinates)
        
        let expect = expectation(description: "dispatchGroupNotify")
        DispatchQueue.main.async() {
            XCTAssertNotNil(self.viewModel?.currentWeather)
            XCTAssertNotNil(self.viewModel?.multiWeather)
            expect.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testLoadCurrenWeartherShouldHaveCurrentWeatherNil() {
        let coordinates = CLLocationCoordinate2D()
        mockService?.multiWeatherServiceResponse = getMockedMultiWeatherServiceResponse()
        mockService?.currentWeatherServiceResponse = nil
        
        mockService?.getCurrentWeatherInvoked = 1
        mockService?.getMultiWeatherInvoked = 1
        mockView?.showLoadingIndicatorInvoked = 1
        mockView?.showRetryErrorStateInvoked = 1
        
        viewModel?.loadWeather(coordinate: coordinates)
        
        let expect = expectation(description: "dispatchGroupNotify")
        DispatchQueue.main.async() {
            XCTAssertNil(self.viewModel?.currentWeather)
            XCTAssertNotNil(self.viewModel?.multiWeather)
            expect.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testLoadCurrenWeartherShouldHaveMultiWeatherNil() {
        let coordinates = CLLocationCoordinate2D()
        mockService?.multiWeatherServiceResponse = nil
        mockService?.currentWeatherServiceResponse = getMockedWeatherServiceResponse()
        
        mockService?.getCurrentWeatherInvoked = 1
        mockService?.getMultiWeatherInvoked = 1
        mockView?.showLoadingIndicatorInvoked = 1
        mockView?.showRetryErrorStateInvoked = 1
        
        viewModel?.loadWeather(coordinate: coordinates)
        
        let expect = expectation(description: "dispatchGroupNotify")
        DispatchQueue.main.async() {
            XCTAssertNotNil(self.viewModel?.currentWeather)
            XCTAssertNil(self.viewModel?.multiWeather)
            expect.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testLoadCurrenWeartherShouldHaveMultiWeatherNilAndCurrentWeatherNil() {
        let coordinates = CLLocationCoordinate2D()
        mockService?.multiWeatherServiceResponse = nil
        mockService?.currentWeatherServiceResponse = nil
        
        mockService?.getCurrentWeatherInvoked = 1
        mockService?.getMultiWeatherInvoked = 1
        mockView?.showLoadingIndicatorInvoked = 1
        mockView?.showRetryErrorStateInvoked = 1
        
        viewModel?.loadWeather(coordinate: coordinates)
        
        let expect = expectation(description: "dispatchGroupNotify")
        DispatchQueue.main.async() {
            XCTAssertNil(self.viewModel?.currentWeather)
            XCTAssertNil(self.viewModel?.multiWeather)
            expect.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testGetDateFromEpochTimeShouldReturnDashesWhenEpochTimeIsNil() {
        let expectedResults = "__"
        let results = viewModel?.getDateFromEpochTime(epochTime: nil, dateFormatType: .date)
        
        XCTAssertEqual(results, expectedResults)
    }
    
    func testGetDateFromEpochTimeShouldReturnExpectedDayWithTime() {
        let expectedResults = "Monday 9 PM"
        let results = viewModel?.getDateFromEpochTime(epochTime: 1582572297, dateFormatType: .day)
        
        XCTAssertEqual(results, expectedResults)
    }
    
    func testGetDateFromEpochTimeShouldReturnExpectedDateWithTime() {
        let expectedResults = "24/02/2020 9:24 PM"
        let results = viewModel?.getDateFromEpochTime(epochTime: 1582572297, dateFormatType: .date)
        
        XCTAssertEqual(results, expectedResults)
    }
    
    func testGetWeatherBackgroudImageIconShouldReturnExpecatedRainImage() {
        let expected = UIImage(named: "forest_rainy")
        viewModel?.currentWeather = getMockedWeatherServiceResponse(weatherID: 200)
        
        let results = viewModel?.getWeatherBackgroudImageIcon()
        
        XCTAssertEqual(results, expected)
    }
    
    func testGetWeatherBackgroudImageIconShouldReturnExpecatedSunnyImage() {
         let expected = UIImage(named: "forest_sunny")
         viewModel?.currentWeather = getMockedWeatherServiceResponse(weatherID: 800)
         
         let results = viewModel?.getWeatherBackgroudImageIcon()
         
         XCTAssertEqual(results, expected)
     }
    
    func testGetWeatherBackgroudImageIconShouldReturnExpecatedCloudsImae() {
         let expected = UIImage(named: "forest_cloudy")
         viewModel?.currentWeather = getMockedWeatherServiceResponse(weatherID: 802)
         
         let results = viewModel?.getWeatherBackgroudImageIcon()
         
         XCTAssertEqual(results, expected)
     }
        
    func testGetBlackWhiteWeatherImageIconShouldReturnExpecatedRainIcon() {
        let expected = UIImage(named: "rain")
        let results = viewModel?.getBlackWhiteWeatherImageIcon(weatherCode: 200)
        
        XCTAssertEqual(results, expected)
    }
    
    func testGetBlackWhiteWeatherImageIconShouldReturnExpecatedSunnyIcon() {
        let expected = UIImage(named: "clear")
        let results = viewModel?.getBlackWhiteWeatherImageIcon(weatherCode: 800)
         
         XCTAssertEqual(results, expected)
     }
    
    func testGetBlackWhiteWeatherImageIconShouldReturnExpecatedCloudsIcon() {
         let expected = UIImage(named: "partlysunny")
         let results = viewModel?.getBlackWhiteWeatherImageIcon(weatherCode: 802)
         
         XCTAssertEqual(results, expected)
     }

    func testGetWeatherBackgroudColorShouldReturnExpecatedRainColor() {
        let expected = UIColor().hexStringToUIColor(hex: "#57575D")
        viewModel?.currentWeather = getMockedWeatherServiceResponse(weatherID: 200)
        
        let results = viewModel?.getWeatherBackgroudColor()
        
        XCTAssertEqual(results, expected)
    }
    
    func testGetWeatherBackgroudColorShouldReturnExpecatedSunnyColor() {
         let expected = UIColor().hexStringToUIColor(hex: "#47AB2F")
         viewModel?.currentWeather = getMockedWeatherServiceResponse(weatherID: 800)
         
         let results = viewModel?.getWeatherBackgroudColor()
         
         XCTAssertEqual(results, expected)
     }
    
    func testGetWeatherBackgroudColorShouldReturnExpecatedCloudsColor() {
         let expected = UIColor().hexStringToUIColor(hex: "#54717A")
         viewModel?.currentWeather = getMockedWeatherServiceResponse(weatherID: 802)
         
         let results = viewModel?.getWeatherBackgroudColor()
         
         XCTAssertEqual(results, expected)
     }
    
    private func getMockedWeatherServiceResponse(weatherID: Int = 800) -> WeatherServiceResponse {
        let weather = Weather(id: weatherID, main: "Clear", weatherDescription: "Sunny Day", icon: "icon")
        let main = Main(temp: 20,
                        pressure: 32,
                        humidity: 80,
                        tempMin: 12,
                        tempMax: 26,
                        seaLevel: 30,
                        grndLevel: 20)
        return WeatherServiceResponse(coord: Coord(lon: 0, lat: 0),
                                      weather: [weather],
                                      base: "",
                                      main: main,
                                      wind: nil,
                                      clouds: nil,
                                      dt: 1313131313,
                                      sys: nil,
                                      id: 23,
                                      name: "Jozi",
                                      cod: 12)
        
    }
    
    private func getMockedMultiWeatherServiceResponse() -> MultiWeatherServiceResponse {
        return MultiWeatherServiceResponse(
            cod: "2121, -122",
            message: 200,
            cnt: 1,
            list: [getMockedWeatherServiceResponse()],
            city: City(id: 0, name: "New York", coord: Coord(lon: 0, lat: 0), country: "USA"))
    }
}
