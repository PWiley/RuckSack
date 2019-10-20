//
//  WeatherViewController.swift
//  Bundle
//
//  Created by Patrick Wiley on 29.08.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import UIKit

class WeatherViewController: UITableViewController, WeatherModelDelegate {
    
    
    static var whichTown: Bool = true
    let weather = WeatherModel()
    func didUpdateWeatherData() {
        print("Houra")
    }
    

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
//        let blur = UIBlurEffect(style: UIBlurEffect.Style.light)
//        let blurView = UIVisualEffectView(effect: blur)
//        blurView.frame = self.view.bounds
//        //view.insertSubView(blurView, atIndex: 0)
//        self.tableView.backgroundView!.addSubview(blurView)
        //tableViewWeather.backgroundView = UIImageView(image: UIImage(named: "Background_Weather_NewYork"))
        //navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(changeTown))
        //weather.askWeatherState(town: WeatherModel.berlin)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Town?", style: .plain, target: self, action: #selector(changeTown))
        // Do any additional setup after loading the view.
    
    }
    override func viewWillAppear(_ animated: Bool) {
        //weather.askWeatherState(town: WeatherModel.berlin)
    }
    override func viewDidAppear(_ animated: Bool) {
        let indexPath: IndexPath = IndexPath(row: 1, section: 0)
        tableViewWeather.scrollToRow(at: indexPath, at: .bottom, animated: true)
        //let weather = WeatherModel()
        tableViewWeather.backgroundView?.fadeOut()
        weather.askWeatherState(town: WeatherModel.berlin)
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
        //navigationItem.rightBarButtonItem?.title = "Berlin"
        //navigationItem.title = "Berlin"
        WeatherViewController.whichTown = !WeatherViewController.whichTown
        let changeTownAlert = UIAlertController(title: "Change Town?", message: "Do You want to change the town?", preferredStyle: .alert)
        changeTownAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            print("I want to change to another town")
            if WeatherViewController.self.whichTown == true {
                self.tableViewWeather.backgroundView?.fadeOut()
            //self.weather.askWeatherState(town: WeatherModel.berlin)
            self.tableViewWeather.backgroundView = UIImageView(image: UIImage(named: "Background_Weather_Berlin"))
                self.tableViewWeather.backgroundView?.fadeIn()
            } else {
                self.tableViewWeather.backgroundView?.fadeOut()
            self.weather.askWeatherState(town: WeatherModel.newYork)
            self.tableViewWeather.backgroundView = UIImageView(image: UIImage(named: "Background_Weather_NewYork"))
                self.tableViewWeather.backgroundView?.fadeIn()
            }
        }))
        changeTownAlert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        
        self.present(changeTownAlert, animated: true, completion: nil)
    }
}
