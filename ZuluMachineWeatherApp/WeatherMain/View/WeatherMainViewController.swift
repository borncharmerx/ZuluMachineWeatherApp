//
//  WeatherMainViewController.swift
//  ZuluMachineWeatherApp
//
//  Created by Sipho Motha on 2020/02/19.
//  Copyright © 2020 ZuluMachine House. All rights reserved.
//

import UIKit
import CoreLocation

enum ViewState {
    case normal
    case loading
}

class WeatherMainViewController: UIViewController {
    //TODO Separate View for reuse and cleaner code
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var currentTempDescriptionLabel: UILabel!
    @IBOutlet weak var currentSmallDegreesLabel: UILabel!
    @IBOutlet weak var maxSmallDegreesLabel: UILabel!
    @IBOutlet weak var minSmallDegreesLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dataContainerStackView: UIStackView!
    @IBOutlet weak var loadingIndicatorFullScreenView: UIView!
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var loadingMessageLabel: UILabel!
    @IBOutlet weak var loadingIndicatorOnScreenButton: UIButton!
    @IBOutlet weak var fullScrenActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    private var viewModel: WeatherMainViewModel?
    var viewState: ViewState
    var locationManager = CLLocationManager()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.viewState = .loading
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.viewModel = WeatherMainViewModel(with: self, service: WeatherService())
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.viewState = .loading
        super.init(coder: aDecoder)
        self.viewModel = WeatherMainViewModel(with: self, service: WeatherService())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO Load offline data
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    //MARK button actions
    @IBAction func RetryRefreshButtonClicked() {
        if viewState == .normal {
            guard let location = locationManager.location else {
                return
            }
            
            self.viewModel?.loadWeather(coordinate: location.coordinate)
        }
    }
    
    @IBAction func fullLoadingScreenRetryButtonClicked() {
        guard let location = locationManager.location else {
            return
        }
        
        self.viewModel?.loadWeather(coordinate: location.coordinate)
        viewState = .loading
    }
}

extension WeatherMainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        guard let location = locations.last else {
            return
        }
        
        self.viewModel?.loadWeather(coordinate: location.coordinate)
    }
}

extension WeatherMainViewController: WeatherMainViewContract {
    func updatedCurrentWeather(currentTemp: String, minTemp: String, maxTemp: String, weatherDescription: String) {
        currentTempDescriptionLabel.text = weatherDescription
        currentTempLabel.text = currentTemp
        currentSmallDegreesLabel.text = currentTemp
        minSmallDegreesLabel.text = minTemp
        maxSmallDegreesLabel.text = maxTemp
        tableView.reloadData()
        viewState = .normal
        weatherIconImageView.image = viewModel?.getWeatherBackgroudImageIcon()
        view.backgroundColor = viewModel?.getWeatherBackgroudColor()
        
        let dateFromEpoch = viewModel?.getDateFromEpochTime(epochTime: viewModel?.currentWeather?.dt,
                                                            dateFormatType: .date) ?? "__"
        let lastUpdatedDateString = String(format: "Last update at %@ - click here to refresh", dateFromEpoch)
        loadingIndicatorOnScreenButton.setTitle(lastUpdatedDateString, for: .normal)
    }
    
    func showLoadingIndicator() {
        switch viewState {
        case .loading:
            dataContainerStackView.isHidden = true
            loadingIndicatorFullScreenView.isHidden = false
            loadingMessageLabel.text = "Loading..."
            tryAgainButton.isHidden = true
            loadingIndicatorOnScreenButton.isHidden = true
            fullScrenActivityIndicator.isHidden = false
        case .normal:
            loadingIndicatorOnScreenButton.setTitle("updating now ...", for: .normal)
        }
    }
    
    func hideLoadingIndicator() {
        dataContainerStackView.isHidden = false
        loadingIndicatorFullScreenView.isHidden = true
        loadingIndicatorOnScreenButton.isHidden = false
        loadingIndicatorOnScreenButton.setTitle("", for: .normal)
    }
    
    func showRetryErrorState() {
        switch viewState {
        case .loading:
            loadingMessageLabel.text = "Something went wrong, please try again later"
            tryAgainButton.isHidden = false
            fullScrenActivityIndicator.isHidden = true
        case .normal:
            loadingIndicatorOnScreenButton.setTitle("Something went wrong, click here to try again", for: .normal)
        }
    }
}

extension WeatherMainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel?.multiWeather?.list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherTableViewCell else {
            return UITableViewCell()
        }
        
        let weather = viewModel?.multiWeather?.list?[indexPath.row]
        
        cell.dateLabel.text = viewModel?.getDateFromEpochTime(epochTime: weather?.dt, dateFormatType: .day)
        cell.weatherUnitsLabel.text = viewModel?.getStringValueWithDegreesWhenValid(degreeValue: weather?.main?.temp)
        cell.weatherIconImageView.image = viewModel?.getBlackWhiteWeatherImageIcon(weatherCode: weather?.weather?.first?.id ?? 0)
        
        return cell
    }
}
