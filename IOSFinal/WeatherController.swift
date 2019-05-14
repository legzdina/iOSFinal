//
//  WeatherController.swift
//  IOSFinal
//
//  Created by Kristine Legzdina on 13/05/2019.
//  Copyright © 2019 Kristine Legzdina. All rights reserved.
//Bija japarveido,jo nocakareju view ta ka pavisam
//

import UIKit
import Firebase
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import CoreLocation

class WeatherController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var locationLabel: UILabel!

    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var conditionImageView: UIImageView!
    
    @IBOutlet weak var conditionLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    let apiKey = "YOUR_KEY" //from https://home.openweathermap.org/
    var lat = 57.5130
    var lon = 24.7220
    var activityIndicator: NVActivityIndicatorView!
    let locationManager = CLLocationManager() //handle users location
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      // navigationController?.navigationBar.topItem?.hidesBackButton = true
        
        let indicatorSize: CGFloat = 70
        let indicatorFrame = CGRect(x: (view.frame.width-indicatorSize)/2, y: (view.frame.height-indicatorSize)/2, width: indicatorSize, height: indicatorSize)
        activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: UIColor.white, padding: 20.0)
        activityIndicator.backgroundColor = UIColor.black
        view.addSubview(activityIndicator)
        
        //getting users location
        locationManager.requestWhenInUseAuthorization() //popup
        activityIndicator.startAnimating()
        if(CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
        
        //lets make request to the server!
        Alamofire.request("http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric").responseJSON {
            response in
            self.activityIndicator.stopAnimating()
            //start read json data from server
            if let responseStr = response.result.value {
                let jsonResponse = JSON(responseStr)
                let jsonWeather = jsonResponse["weather"].array![0]
                let jsonTemp = jsonResponse["main"]
                let iconName = jsonWeather["icon"].stringValue //img are named based on this json abriv
                
                self.locationLabel.text = jsonResponse["name"].stringValue
                self.conditionImageView.image = UIImage(named: iconName)
                self.conditionLabel.text = jsonWeather["main"].stringValue
                self.temperatureLabel.text = "\(Int(round(jsonTemp["temp"].doubleValue)))" //round
                
                            let date = Date()
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "EEEE"
                            self.dayLabel.text = dateFormatter.string(from: date)
                
            }
        }
            self.locationManager.stopUpdatingLocation()
    }
    
}
