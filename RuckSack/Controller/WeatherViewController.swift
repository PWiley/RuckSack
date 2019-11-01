//
//  WeatherViewController.swift
//  Bundle
//
//  Created by Patrick Wiley on 29.08.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import UIKit

class WeatherViewController: UITableViewController, WeatherServiceDelegate {
   
    // MARK: - TableView
    
    @IBOutlet var tableViewWeather: UITableView!
    
    // MARK: - TemperatureCell
    
    @IBOutlet weak var imageWeatherState: UIImageView!
    @IBOutlet weak var weatherStateTitle: UILabel!
    @IBOutlet weak var temperatureMax: UILabel!
    @IBOutlet weak var temperatureMin: UILabel!
    @IBOutlet weak var temperatureActual: UILabel!
    
    // MARK: - WeekCell
    
    @IBOutlet weak var actualDayWeather: ActualDayWeather!
    @IBOutlet weak var stackViewState: UIStackView!

   let weatherService = WeatherService()
    
   
    func didUpdateWeatherData(openWeather: OpenWeather) {
       setStackViewDaysState()
        createTodayState()
       
   }
   
   static var whichTown: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
      tableViewWeather.backgroundView = UIImageView(image: UIImage(named: "Background_Weather_Berlin"))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Town?", style: .plain, target: self, action: #selector(changeTown))
        weatherService.delegate = self
        weatherService.askWeatherState(town: WeatherService.berlin)

   }
    override func viewDidAppear(_ animated: Bool) {
        let indexPath: IndexPath = IndexPath(row: 1, section: 0)
        tableViewWeather.scrollToRow(at: indexPath, at: .bottom, animated: true)
        tableViewWeather.backgroundView?.fadeOut()
        weatherService.askWeatherState(town: WeatherService.berlin)
        tableViewWeather.backgroundView?.fadeIn()
        //setupVisualEffectBlur()
    }
 
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
    
    func createDayState(number: Int) -> UIView{
        let dayWeatherState = DayWeatherState()
        
        dayWeatherState.dayName.text = weatherService.setDayStateName(indexList: number)
        dayWeatherState.imageState.image = setStateImage(indexList: number)
        dayWeatherState.tempMax.text =
            String(format:"%.f", weatherService.openWeather!.list[number].main.tempMax.celcius) + " C°"
        dayWeatherState.tempMin.text =
            String(format:"%.f", weatherService.openWeather!.list[number].main.tempMin.celcius) + " C°"
        return dayWeatherState
    }
    func createTodayState() {
        
        actualDayWeather.weatherDescription.text = weatherService.openWeather!.list[0].weather[0].weatherDescription.rawValue
        actualDayWeather.imageActualWeather.image = setStateImage(indexList: 0)
        actualDayWeather.tempMax.text = String(format:"%.f", weatherService.openWeather!.list[0].main.tempMax.celcius) + " C°"
        actualDayWeather.tempMin.text =
            String(format:"%.f", weatherService.openWeather!.list[0].main.tempMin.celcius) + " C°"
        actualDayWeather.tempActual.text = String(format:"%.f", weatherService.openWeather!.list[0].main.temp.celcius) + " C°"
    }

    func setStateImage(indexList: Int) -> UIImage{
        var imageStateDay = UIImage()
        let value = weatherService.openWeather?.list[indexList].weather[0].main
        
        switch value {
        case .clouds :
            imageStateDay = UIImage(named: "partly-cloudy-day")!
        case .clear:
            imageStateDay = UIImage(named: "sun")!
        case .rain:
            imageStateDay = UIImage(named: "rain")!
          default:
            print("Type is something else")
        }
        return imageStateDay
    }
   fileprivate func setStackViewDaysState() {
      if stackViewState.arrangedSubviews.count != 0 {
           resetStackViewDaysState()
       }
       stackViewState.insertArrangedSubview(createDayState(number: 8), at: 0)
       stackViewState.insertArrangedSubview(createDayState(number: 16), at: 1)
       stackViewState.insertArrangedSubview(createDayState(number: 24), at: 2)
       stackViewState.insertArrangedSubview(createDayState(number: 32), at: 3)
       stackViewState.insertArrangedSubview(createDayState(number: 39), at: 4)
   }
   fileprivate func resetStackViewDaysState() {
       stackViewState.subviews.forEach { (view) in
           view.removeFromSuperview()
       }
    }
//    func setupVisualEffectBlur() {
//        animator = UIViewPropertyAnimator(duration: 3.0, curve: .linear, animations: {
//
//            let blurEffect = UIBlurEffect(style: .dark)
//            let visualEffectView = UIVisualEffectView(effect: blurEffect)
//            let imageView = self.tableViewWeather.backgroundView
//            visualEffectView.frame = imageView!.bounds
//            imageView!.addSubview(visualEffectView)
//        })
//        animator.fractionComplete = 0.5
//    }
}
