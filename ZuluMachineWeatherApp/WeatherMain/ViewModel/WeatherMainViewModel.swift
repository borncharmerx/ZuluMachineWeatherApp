//
//  WeatherMainViewModel.swift
//  ZuluMachineWeatherApp
//
//  Created by Sipho Motha on 2020/02/19.
//  Copyright © 2020 ZuluMachine House. All rights reserved.
//

import UIKit
import CoreLocation

enum dateFormatType {
    case day
    case date
}

class WeatherMainViewModel {
    let view: WeatherMainViewContract
    let service: WeatherServiceContract
    var currentWeather: WeatherServiceResponse?
    var multiWeather: MultiWeatherServiceResponse?
    let dispatchGroup = DispatchGroup()
    
    init(with view: WeatherMainViewContract, service: WeatherServiceContract) {
        self.view = view
        self.service = service
    }
    
    func loadWeather(coordinate: CLLocationCoordinate2D) {
        currentWeather = nil
        view.showLoadingIndicator()
        
        service.getCurrentWeather(completion: { (serviceRepsonse) in
            self.currentWeather = serviceRepsonse
        }, coordinate: coordinate, dispatchGroup: dispatchGroup)
        
        service.getMultiWeather(completion: { (serviceResponse) in
            self.multiWeather = serviceResponse
        }, coordinate: coordinate, dispatchGroup: dispatchGroup)
        
        dispatchGroup.notify(queue: .main) {
            //Update on how to handle error state
            if self.currentWeather == nil || self.multiWeather == nil {
                self.view.showRetryErrorState()
                return
            }
            
            self.view.hideLoadingIndicator()
            self.updateWeather()
        }
    }
    
    private func updateWeather() {
        let weatherDescription = currentWeather?.weather?.first?.weatherDescription ?? "__"
        let maxTemp = currentWeather?.main?.tempMax
        let minTemp = currentWeather?.main?.tempMin
        let currentTemp = currentWeather?.main?.temp
        
        self.view.updatedCurrentWeather(currentTemp: getStringValueWithDegreesWhenValid(degreeValue: currentTemp),
                                        minTemp: getStringValueWithDegreesWhenValid(degreeValue: minTemp),
                                        maxTemp: getStringValueWithDegreesWhenValid(degreeValue: maxTemp),
                                        weatherDescription: weatherDescription.uppercased())
        
    }
    
    func getStringValueWithDegreesWhenValid(degreeValue: Double?) -> String {
        guard let degree =  degreeValue else { return "__" }
        return String(format:"%.0f%@", degree, "\u{00B0}")
    }
    
    func getDateFromEpochTime(epochTime: Int?, dateFormatType: dateFormatType) -> String {
        guard let epochTime = epochTime  else {
            return "__"
        }
        
        let epochDate = Date(timeIntervalSince1970: TimeInterval(epochTime))
        
        let dateFormatString: String
        
        switch dateFormatType {
        case .day:
            dateFormatString = "EEEE h a"
        case .date:
            dateFormatString = "dd/MM/yyyy h:mm a"
        }
        
        //Date formatting
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormatString
        let epochDay = dateFormatter.string(from: epochDate)
        
        return epochDay
    }
    
    func getWeatherBackgroudImageIcon() -> UIImage? {
        guard let weatherCode = currentWeather?.weather?.first?.id else {
            return UIImage()
        }
        
        switch weatherCode  {
        case 200...781:
            //Rain, ThunderStorm and Drizzle
            return UIImage(named: "forest_rainy")
        case 800:
            //Clear
            return UIImage(named: "forest_sunny")
        case 801...804:
            //Clouds
            return UIImage(named: "forest_cloudy")
        default:
            return UIImage()
        }
    }
    
    func getBlackWhiteWeatherImageIcon(weatherCode: Int) -> UIImage? {
        switch weatherCode  {
        case 200...781:
            //Rain, ThunderStorm and Drizzle
            return UIImage(named: "rain")
        case 800:
            //Clear
            return UIImage(named: "clear")
        case 801...804:
            //Clouds
            return UIImage(named: "partlysunny")
        default:
            return UIImage()
        }
    }
    
    func getWeatherBackgroudColor() -> UIColor {
        guard let weatherCode = currentWeather?.weather?.first?.id else {
            return UIColor()
        }
        
        switch weatherCode  {
        case 200...781:
            //Rain, ThunderStorm and Drizzle
            return UIColor().hexStringToUIColor(hex: "#57575D")
        case 800:
            //Clear
            return UIColor().hexStringToUIColor(hex: "#47AB2F")
        case 801...804:
            //Clouds
            return UIColor().hexStringToUIColor(hex: "#54717A")
        default:
            return UIColor()
        }
    }
}
