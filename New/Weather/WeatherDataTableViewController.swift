//
//  WeatherDataTableViewController.swift
//  New
//
//  Created by Dmytro Yurchenko on 24.03.2023.
//

import UIKit
import CoreLocation

class WeatherDataTableViewController: UITableViewController {
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    var model = [WeatherModel]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "3 hour forecast"
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "weather")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationManager.requestLocation()
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weather", for: indexPath)
        
        if !model.isEmpty {
            let model = model[indexPath.row]
            cell.textLabel?.text = "\(model.temperatureValue)˚"
            cell.imageView?.image = .init(systemName: model.weatherConditionName)
        }

        return cell
    }
    
}

//MARK: - WeatherManagerDelegate
extension WeatherDataTableViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: [WeatherModel]) {
        DispatchQueue.main.async { [weak self] in
            self?.model = weather
            self?.tableView.reloadData()
        }
        
    }
    
    func didFailWithError(_ error: Error) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "New", message: error.localizedDescription, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: "Default action"), style: .default, handler: { _ in
                return
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}

//MARK: - CLLocationManagerDelegate
extension WeatherDataTableViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(lat: lat, lon: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}


