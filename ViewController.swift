//
//  ViewController.swift
//  SmallWeatherApp
//
//  Created by Monisha Ravi on 9/2/21.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet var zipSearchTextField: UITextField!
    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var cityTemperatureLabel: UILabel!
    let apiKey = "K9ThwCmT3GORmKWcF8osHlQ9TaviWkXV"
    var zipCode: String = ""
    var locationKey: String = ""
    var cityName: String = ""
    var cityTemperature: Double = 0.0
    
    //button f(x)
    @IBAction func searchCity(_ sender: UIButton) {
        zipCode = zipSearchTextField.text!
        print(zipCode)
        LocationAPI()
       // callTemperatureAPI()
    }
    //parse for location key
    func LocationAPI() {
        print("REACHED LOCATION API")
        let url = URL(string: "http://dataservice.accuweather.com/locations/v1/postalcodes/search?apikey=\(apiKey)&q=\(zipCode)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session: URLSession = {
               let config = URLSessionConfiguration.default
               return URLSession(configuration: config)
           }()
            print("REACHED SESSION")
            let task = session.dataTask(with: request) {
                (data, response, error) in
                if let jsonData = data {
                    if let jsonString = String(data: jsonData, encoding: .utf8) {
                        //print(jsonString)
                        let users = try! JSONDecoder().decode([Location].self, from: jsonData)
                        print("BeFore LOOP")
                        for user in users {
                            //print("\(user.Key)")
                            self.cityName = user.LocalizedName
                            self.locationKey = user.Key
                           print("FORLOOP \(self.locationKey)")
                           // print(" \(self.cityName)")
                            DispatchQueue.main.async {
                                self.cityNameLabel.text = self.cityName
                            
                            }
                        }
                    }
                    
                    
                    } else if let requestError = error {
                    print("Error fetching location: \(requestError)")
                    } else {
                    print("Unexpected error fetching location")
                    }
            }
        task.resume()
        print("BEFORE CALLAPI: \(locationKey)")
        
       }
        
     //parse for city name, temperature, and icon
     func callTemperatureAPI() {
        print("REACHED TEMPERATURE API")
        print("REACHED LOCATION KEY:\(locationKey)")
        let url = URL(string: "http://dataservice.accuweather.com/forecasts/v1/hourly/1hour/7986_PC?apikey=K9ThwCmT3GORmKWcF8osHlQ9TaviWkXV&language=en-us&details=false&metric=true")!
        print("URL: \(url)")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let session: URLSession = {
               let config = URLSessionConfiguration.default
               return URLSession(configuration: config)
           }()

            let task = session.dataTask(with: request) {
                (data, response, error) in
                if let jsonData = data {
                    if let jsonString = String(data: jsonData, encoding: .utf8) {
                        print(jsonString)
                        let users = try! JSONDecoder().decode([TemperatureElement].self, from: jsonData)

                        for user in users {
                            print("\(user.temperature)")
                            self.cityTemperature = user.temperature.metric.value
                            print(" \(self.cityTemperature)")
                            break
                        }
        }
                    DispatchQueue.main.async {
                        self.cityTemperatureLabel.text = String(self.cityTemperature)
                    
                    }
                } else if let requestError = error {
                    print("Error fetching temperature: \(requestError)")
        } else {
                    print("Unexpected error fetching temperature")
                }
        }
        
        print("CITY TEMPERATURE: \(String(describing: cityTemperatureLabel.text))")
            task.resume()
        
       }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.systemBlue
        // Do any additional setup after loading the view.
    }


}

