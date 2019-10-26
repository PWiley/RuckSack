//
//  WeatherViewController.swift
//  Bundle
//
//  Created by Patrick Wiley on 29.08.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import UIKit

class WeatherViewController: UITableViewController, WeatherServiceDelegate {
    
    let weatherService = WeatherService()
    
    func didUpdateWeatherData(forecast: YahooWeather) {
        temperatureActual.text = String(forecast.list[0].main.temp.celcius.roundTo)
        //temperatureActual.text = String(format:"%.2f", String(forecast.list[0].main.temp.celcius.r))
        temperatureMin.text = String(forecast.list[0].main.tempMin.celcius.roundTo)
        temperatureMax.text = String(forecast.list[0].main.tempMax.celcius.roundTo)
        
        temperatureMinDayOne.text = String(forecast.list[1].main.tempMin.celcius.roundTo)
        temperatureMaxDayOne.text = String(forecast.list[1].main.tempMax.celcius.roundTo)
        
        temperatureMinDayTwo.text = String(forecast.list[2].main.tempMin.celcius.roundTo)
        temperatureMaxDayTwo.text = String(forecast.list[2].main.tempMax.celcius.roundTo)
        
        temperatureMinDayThree.text = String(forecast.list[3].main.tempMin.celcius.roundTo)
        temperatureMaxDayThree.text = String(forecast.list[3].main.tempMax.celcius.roundTo)
        
        temperatureMinDayFour.text = String(forecast.list[4].main.tempMin.celcius.roundTo)
        temperatureMaxDayFour.text = String(forecast.list[4].main.tempMax.celcius.roundTo)
        
        temperatureMinDayFive.text = String(forecast.list[5].main.tempMin.celcius.roundTo)
        temperatureMaxDayFive.text = String(forecast.list[5].main.tempMax.celcius.roundTo)
    }
    
    static var whichTown: Bool = true
  
    @IBOutlet var tableViewWeather: UITableView!
    
    // MARK: - TemperatureCell
    
    @IBOutlet weak var imageWeatherState: UIImageView!
    @IBOutlet weak var weatherStateTitle: UILabel!
    @IBOutlet weak var temperatureMax: UILabel!
    @IBOutlet weak var temperatureMin: UILabel!
    @IBOutlet weak var temperatureActual: UILabel!
    
    // MARK: - WeekCell
    
    // Day One
    
    @IBOutlet weak var imageStateDayOne: UIImageView!
    @IBOutlet weak var dayOneName: UILabel!
    @IBOutlet weak var temperatureMaxDayOne: UILabel!
    @IBOutlet weak var temperatureMinDayOne: UILabel!
    
    // Day Two
    
    @IBOutlet weak var imageStateDayTwo: UIImageView!
    @IBOutlet weak var dayTwoName: UILabel!
    @IBOutlet weak var temperatureMaxDayTwo: UILabel!
    @IBOutlet weak var temperatureMinDayTwo: UILabel!
    
    // Day Three
    
    @IBOutlet weak var imageStateDayThree: UIImageView!
    @IBOutlet weak var dayThreeName: UILabel!
    @IBOutlet weak var temperatureMaxDayThree: UILabel!
    @IBOutlet weak var temperatureMinDayThree: UILabel!
    
    // Day Four
    
    @IBOutlet weak var imageStateDayFour: UIImageView!
    @IBOutlet weak var dayFourName: UILabel!
    @IBOutlet weak var temperatureMaxDayFour: UILabel!
    @IBOutlet weak var temperatureMinDayFour: UILabel!
    
    // Day Five
    
    @IBOutlet weak var imageStateDayFive: UIImageView!
    @IBOutlet weak var dayFiveName: UILabel!
    @IBOutlet weak var temperatureMaxDayFive: UILabel!
    @IBOutlet weak var temperatureMinDayFive: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewWeather.backgroundView = UIImageView(image: UIImage(named: "Background_Weather_Berlin"))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Town?", style: .plain, target: self, action: #selector(changeTown))
        weatherService.delegate = self
        weatherService.askWeatherState(town: WeatherService.berlin)
        // Do any additional setup after loading the view.
    
    }
    override func viewWillAppear(_ animated: Bool) {
        //weather.askWeatherState(town: WeatherService.berlin)
    }
    override func viewDidAppear(_ animated: Bool) {
        let indexPath: IndexPath = IndexPath(row: 1, section: 0)
        tableViewWeather.scrollToRow(at: indexPath, at: .bottom, animated: true)
        tableViewWeather.backgroundView?.fadeOut()
        weatherService.askWeatherState(town: WeatherService.berlin)
        tableViewWeather.backgroundView?.fadeIn()
        
    }
   
    /*
    // MARK: - Navigation
b
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func changeTown() {
        print("Changed town")
        WeatherViewController.whichTown = !WeatherViewController.whichTown
        let changeTownAlert = UIAlertController(title: "Change Town?", message: "Do You want to change the town?", preferredStyle: .alert)
        changeTownAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            print("I want to change to another town")
            if WeatherViewController.self.whichTown == true {
                self.tableViewWeather.backgroundView?.fadeOut()
            self.weatherService.askWeatherState(town: WeatherService.berlin)
            self.tableViewWeather.backgroundView = UIImageView(image: UIImage(named: "Background_Weather_Berlin"))
                self.tableViewWeather.backgroundView?.fadeIn()
            } else {
                self.tableViewWeather.backgroundView?.fadeOut()
            self.weatherService.askWeatherState(town: WeatherService.newYork)
            self.tableViewWeather.backgroundView = UIImageView(image: UIImage(named: "Background_Weather_NewYork"))
                self.tableViewWeather.backgroundView?.fadeIn()
            }
        }))
        changeTownAlert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        
        self.present(changeTownAlert, animated: true, completion: nil)
    }
}
