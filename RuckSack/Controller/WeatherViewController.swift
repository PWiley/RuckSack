//
//  WeatherViewController.swift
//  Bundle
//
//  Created by Patrick Wiley on 29.08.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import UIKit

class WeatherViewController: UITableViewController {

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
        tableViewWeather.backgroundView = UIImageView(image: UIImage(named: "Background_Weather"))
        // Do any additional setup after loading the view.
    
    }
    override func viewDidAppear(_ animated: Bool) {
        let indexPath: IndexPath = IndexPath(row: 1, section: 0)
        tableViewWeather.scrollToRow(at: indexPath, at: .bottom, animated: true)
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
    
}
