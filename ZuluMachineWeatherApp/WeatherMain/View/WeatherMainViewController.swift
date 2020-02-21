//
//  WeatherMainViewController.swift
//  ZuluMachineWeatherApp
//
//  Created by Sipho Motha on 2020/02/19.
//  Copyright © 2020 ZuluMachine House. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherMainViewController: UIViewController {
    private var viewModel: WeatherMainViewModel?
    var locationManager = CLLocationManager()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.viewModel = WeatherMainViewModel(with: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // viewModel.ViewHasLoaded()
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
}

extension WeatherMainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last! as CLLocation
        
        /* you can use these values*/
        let lat = location.coordinate.latitude
        let long = location.coordinate.longitude
        
        

    }
}

extension WeatherMainViewController: WeatherMainViewContract {
    
}
