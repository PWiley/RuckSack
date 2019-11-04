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
    var night = false
    var town = Town.berlin
    
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
        print("We just get our infos")
        
    }
    
    static var whichTown: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        whichTown(town: .berlin)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Town?", style: .plain , target: self, action: #selector(changeTown))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(displayP3Red: 247.0, green: 0.0, blue: 143.0, alpha: 1)
        
        weatherService.delegate = self
        weatherService.askWeatherState(town: WeatherService.berlin)
        //setupEffectBlur()
        //setupAlphaBackground()
        //self.tableViewWeather.backgroundColor = UIColor.clear
//        let gestureRefresh = UISwipeGestureRecognizer(target: self, action: #selector(self.refreshWeatherState))
//        gestureRefresh.direction = .down
//        self.view.addGestureRecognizer(gestureRefresh)
    }
    override func viewDidAppear(_ animated: Bool) {
        let indexPath: IndexPath = IndexPath(row: 1, section: 0)
        tableViewWeather.scrollToRow(at: indexPath, at: .bottom, animated: true)
        //tableViewWeather.backgroundView?.fadeOut()
        print(tableViewWeather.bounds.maxY)
        weatherService.askWeatherState(town: WeatherService.berlin)
        //tableViewWeather.backgroundView?.fadeIn()
        //setupVisualEffectBlur()
    }
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let contentOffSetY = scrollView.contentOffset.y
//        print(contentOffSetY)
//        if contentOffSetY > 0 {
//            animator.fractionComplete = 0.5
//            return
//        }
//        animator.fractionComplete = abs(contentOffSetY)
//
//    }
   override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let indexpath = IndexPath(row: 0, section: 0)
        let rowZeroFrame = tableViewWeather.rectForRow(at: indexpath)
        //print(rowZeroFrame.height)
        let offset = scrollView.contentOffset.y/(self.tableViewWeather.contentSize.height - rowZeroFrame.height)
        //print(offset)
        self.tableViewWeather.backgroundView?.alpha = 1-offset
    }

    
    @objc func changeTown() {
        print("Changed town")
        WeatherViewController.whichTown = !WeatherViewController.whichTown
        let changeTownAlert = UIAlertController(title: "Change Town?", message: "Do You want to change the town?", preferredStyle: .alert)
        changeTownAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            print("I want to change to another town")
            if WeatherViewController.self.whichTown == true {
                self.whichTown(town: .berlin)
                //self.navigationItem.title = "Berlin"
                //self.tableViewWeather.backgroundView?.fadeOut()
                self.weatherService.askWeatherState(town: WeatherService.berlin)
                //self.tableViewWeather.backgroundView = UIImageView(image: UIImage(named: "Background_Weather_Berlin_Ver2"))
                //self.tableViewWeather.backgroundView?.fadeIn()
            } else {
                self.whichTown(town: .newYork)
                //self.navigationItem.title = "New-York"
                //self.tableViewWeather.backgroundView?.fadeOut()
                self.weatherService.askWeatherState(town: WeatherService.newYork)
                //self.tableViewWeather.backgroundView = UIImageView(image: UIImage(named: "Background_Weather_NewYork"))
                //self.tableViewWeather.backgroundView?.fadeIn()
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
            String(format:"%.f", weatherService.openWeather!.list[number].main.tempMax.celcius) + " °C"
        dayWeatherState.tempMin.text =
            String(format:"%.f", weatherService.openWeather!.list[number].main.tempMin.celcius) + " °C"
        return dayWeatherState
    }
    func createTodayState() {
        
        actualDayWeather.weatherDescription.text = weatherService.openWeather!.list[0].weather[0].weatherDescription.rawValue
        actualDayWeather.imageActualWeather.image = setStateImage(indexList: 0)
        actualDayWeather.tempMax.text = String(format:"%.f", weatherService.openWeather!.list[0].main.tempMax.celcius) + " °C"
        actualDayWeather.tempMin.text =
            String(format:"%.f", weatherService.openWeather!.list[0].main.tempMin.celcius) + " °C"
        actualDayWeather.tempActual.text = String(format:"%.f", weatherService.openWeather!.list[0].main.temp.celcius) + " °C"
    }
    
    func setStateImage(indexList: Int) -> UIImage {
        var imageStateDay = UIImage()
        let value = weatherService.openWeather?.list[indexList].weather[0].main
        //print("State value impossible to get")
        //throw StructureError.valueError
        
        let description = weatherService.openWeather?.list[indexList].weather[0].weatherDescription
        //print("Description impossible to get")
        //throw StructureError.descriptionError
        
        switch value {
        case .clouds:
            if night == false {
                if description!.rawValue == "few clouds" {
                    imageStateDay = UIImage(named: "02d")!
                }
                if description!.rawValue == "scattered clouds" {
                    imageStateDay = UIImage(named: "03d")!
                }
                if description!.rawValue == "broken clouds" || description!.rawValue == "overcast clouds" {
                    imageStateDay = UIImage(named: "04d")!
                }
            } else{
                if description!.rawValue == "few clouds" {
                    imageStateDay = UIImage(named: "02n")!
                }
                if description!.rawValue == "scattered clouds" {
                    imageStateDay = UIImage(named: "03n")!
                }
                if description!.rawValue == "broken clouds" || description!.rawValue == "overcast clouds" {
                    imageStateDay = UIImage(named: "04n")!
                }
            }
        case .rain:
            if description!.rawValue == "freezing rain" {
                imageStateDay = UIImage(named: "13d")!
            }
            if description!.rawValue == "light intensity shower rain" ||   description!.rawValue == "shower rain" || description!.rawValue == "heavy intensity shower rain" || description!.rawValue == "ragged shower rain" {
                imageStateDay = UIImage(named: "09d")!
            }
            else {
                imageStateDay = UIImage(named: "10d")!
            }
        case .clear:
            if night == false {
                imageStateDay = UIImage(named: "01d")!
            } else{
                imageStateDay = UIImage(named: "01n")!
            }
        case .thunderstorm:
            imageStateDay = UIImage(named: "11d")!
        case .drizzle:
            imageStateDay = UIImage(named: "09d")!
        case .snow:
            imageStateDay = UIImage(named: "13d")!
        case .mist, .smoke, .haze, .dust, .fog, .sand, .ash, .squall, .tornado :
            imageStateDay = UIImage(named: "50d")!
            
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
   //var animator: UIViewPropertyAnimator!
//
//    fileprivate func setupEffectBlur() {
//        animator = UIViewPropertyAnimator(duration: 3.0, curve: .linear, animations: { [weak self] in
//             let blurEffect = UIBlurEffect(style: .regular)
//                   let blurEffectView = UIVisualEffectView(effect: blurEffect)
//            blurEffectView.frame = self!.tableViewWeather.frame
//            self!.tableViewWeather.backgroundView!.insertSubview(blurEffectView, at: 0)
//            //self!.tableViewWeather.addSubview(blurEffectView)
//            self!.tableViewWeather.separatorEffect = UIVibrancyEffect(blurEffect: blurEffect)
//        })
////        animator.fractionComplete = 1
//
//
//
//
//
//    }
    
//    func setupAlphaBackground() {
//         animator = UIViewPropertyAnimator(duration: 3.0, curve: .linear, animations: { [unowned self] in
//            self.tableViewWeather.backgroundView?.alpha = self.animator.fractionComplete
////                    self!.tableViewWeather.backgroundView!.insertSubview(blurEffectView, at: 0)
////                    //self!.tableViewWeather.addSubview(blurEffectView)
////                    self!.tableViewWeather.separatorEffect = UIVibrancyEffect(blurEffect: blurEffect)
//                })
//        animator.startAnimation()
//
//    }
    func whichTown(town: Town) {
        
//        var backgroundTableView = UIImageView()
//        backgroundTableView.contentMode = .scaleAspectFit
        //tableViewWeather.backgroundView = backgroundTableView
        
        switch town {
        case .berlin:
            tableViewWeather.backgroundView = UIImageView(image: UIImage(named: "Background_Weather_Berlin_Ver2"))
            tableViewWeather.backgroundView?.contentMode = .scaleAspectFit
            navigationItem.title = "Berlin"
        case .newYork:
            tableViewWeather.backgroundView = UIImageView(image: UIImage(named: "Background_Weather_NewYork"))
            tableViewWeather.backgroundView?.contentMode = .scaleAspectFit
            navigationItem.title = "New-York"
            
            
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
//    @objc func refreshWeatherState() {
//        weatherService.askWeatherState(town: )
//    }
}
enum StructureError: Error {
    case valueError
    case descriptionError
}

enum Town {
    case berlin
    case newYork
}
