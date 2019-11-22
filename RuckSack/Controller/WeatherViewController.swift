//
//  WeatherViewController.swift
//  RuckSack
//
//  Created by Patrick Wiley on 29.08.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import UIKit

class WeatherViewController: UITableViewController, WeatherServiceDelegate {
    
    let weatherService = WeatherService.sharedWeather
    var night = false
    var backgroundDefault = UserDefaults.standard
    
    // MARK: - Outlets
    
    // MARK: ** TableView __ NavigationBar
    @IBOutlet var tableViewWeather: UITableView!
    @IBOutlet weak var buttonTown: UIBarButtonItem!
    
    // MARK: ** TemperatureCell
    @IBOutlet weak var imageWeatherState: UIImageView!
    @IBOutlet weak var weatherStateTitle: UILabel!
    @IBOutlet weak var temperatureMax: UILabel!
    @IBOutlet weak var temperatureMin: UILabel!
    @IBOutlet weak var temperatureActual: UILabel!
    
    // MARK: ** WeekCell
    @IBOutlet weak var actualDayWeather: ActualDayWeather!
    @IBOutlet weak var stackViewState: UIStackView!
    
    // MARK: - Overriden Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundDefault.set("Berlin", forKey: "town")
        tableViewWeather.backgroundView = UIImageView(image: UIImage(named: "Background_Weather_Berlin"))
        navigationItem.title = "Berlin"
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.init(red:0.97, green:0.44, blue:0.56, alpha:1.0), NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 19.0)!]
        weatherService.delegate = self
        weatherService.askWeatherState(town: weatherService.berlin)
        repositionCell()
        //self.tableViewWeather.backgroundView?.alpha = 1
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        
        print("didAppear")
        repositionCell()
        setRefreshControl()
        //self.tableViewWeather.backgroundView?.alpha = 1
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return self.view.frame.size.height - (self.navigationController?.navigationBar.frame.size.height)! - (self.tabBarController?.tabBar.frame.size.height)! - 20
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let indexpath = IndexPath(row: 0, section: 0)
        let rowZeroFrame = tableViewWeather.rectForRow(at: indexpath)
        //print("contentOffsety: \(scrollView.contentOffset.y)")
        let contentZeroPosition = scrollView.contentOffset.y
        //        print("contentSize: \(tableViewWeather.contentSize.height)")
        //        print("height: \(rowZeroFrame.height)")
        let offset = (scrollView.contentOffset.y + contentZeroPosition)/(self.tableViewWeather.contentSize.height - rowZeroFrame.height)
        //print("Offset: \(offset)")
        self.tableViewWeather.backgroundView?.alpha = 1-offset
        
    }
}



extension WeatherViewController {
    // MARK: - Public Methods
    // MARK: ** Methods
    
    func didUpdateWeatherData(openWeather: OpenWeather) {
        setStackViewDayState()
        createTodayState()
    }
    func didHappenedError(error: NetworkError) {
        switch error {
        case .clientError: self.alert(title: "Internet Connection",
                                      message: "We cannot etablish an internet connection. Please retry in a moment",
                                      titleAction: "Ok",
                                      actionStyle: .default)
        case .serverError: self.alert(title: "Internet Connection",
                                      message: "Retry please in a moment",
                                      titleAction: "Ok",
                                      actionStyle: .default)
        }
    }
    
    // MARK: ** Handling Screening Days State
    
    func createDayState(number: Int) -> UIView {
        
        let dayWeatherState = DayWeatherState()
        
        dayWeatherState.dayName.text = weatherService.setDayStateName(indexList: number)
        dayWeatherState.imageState.image = setStateImage(indexList: number)
        dayWeatherState.humidityAmount.text = String(weatherService.openWeather!.list[number].main.humidity) + "%"
        dayWeatherState.temp.text =
            String(format:"%.f", weatherService.openWeather!.list[number].main.tempMax.celcius) + "°C"
        return dayWeatherState
    }
    func createTodayState() {
        
        actualDayWeather.weatherDescription.text = weatherService.openWeather!.list[0].weather[0].weatherDescription.rawValue.capitalized
        actualDayWeather.imageActualWeather.image = setStateImage(indexList: 0)
        actualDayWeather.humidyAmount.text = String(weatherService.openWeather!.list[0].main.humidity) + "%"
        actualDayWeather.tempActual.text = String(format:"%.f", weatherService.openWeather!.list[0].main.temp.celcius) + "°C"
    }
    func setStateImage(indexList: Int) -> UIImage {
        var imageStateDay = UIImage()
        let value = weatherService.openWeather?.list[indexList].weather[0].main
        let description = weatherService.openWeather?.list[indexList].weather[0].weatherDescription
        let timestamp = Double(((weatherService.openWeather?.list[indexList].dt)!))
        night = weatherService.checkDayState(timestamp: timestamp)
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
            if description!.rawValue == "light intensity shower rain" || description!.rawValue == "shower rain" ||
                description!.rawValue == "heavy intensity shower rain" || description!.rawValue == "ragged shower rain" {
                imageStateDay = UIImage(named: "09d")!
            } else if night == true {
                imageStateDay = UIImage(named: "10n")!
            } else {
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
    
    // MARK: ** Handling Town Change
    
    func switchTown() {
        let townActual = backgroundDefault.string(forKey: "town")
        switch townActual {
        case "Berlin":
            backgroundDefault.set("NewYork", forKey: "town")
        case "NewYork":
            backgroundDefault.set("Berlin", forKey: "town")
        default:
            print("Something wrong happen")
        }
    }
    func setTown(town: UserDefaults) {
        let townName = backgroundDefault.string(forKey: "town")
        switch townName {
        case "Berlin":
            buttonTown.image = UIImage(named: "tv_tower")
            tableViewWeather.backgroundView = UIImageView(image: UIImage(named: "Background_Weather_Berlin"))
            navigationItem.title = "Berlin"
            self.weatherService.askWeatherState(town: self.weatherService.berlin)
            
        case "NewYork":
            self.buttonTown.image = UIImage(named: "liberty")
            tableViewWeather.backgroundView = UIImageView(image: UIImage(named: "Background_Weather_NewYork"))
            navigationItem.title = "New-York"
            self.weatherService.askWeatherState(town: self.weatherService.newYork)
        default:
            print("erreur")
        }
        tableViewWeather.backgroundView?.contentMode = .scaleAspectFit
        //repositionCell()
        self.tableViewWeather.backgroundView?.alpha = 1
    }
    
    // MARK: ** Action Methods
    
    @IBAction func changeTown(_ sender: Any) {
        
        let changeTownAlert = UIAlertController(title: "Change Town?", message: "Do You want to change the town?", preferredStyle: .alert)
        changeTownAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.switchTown()
            self.setTown(town: self.backgroundDefault)
            self.repositionCell()
            self.tableViewWeather.backgroundView?.alpha = 1
            
        }))
        changeTownAlert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        
        self.present(changeTownAlert, animated: true, completion: nil)
    }
    
    @objc func handleSwipes(_ sender: Any) {
        self.setTown(town: backgroundDefault)
        self.refreshControl?.endRefreshing()
        DispatchQueue.main.async {
            self.tableViewWeather.reloadData()
        }
    }
    
}
// MARK: - Private Methods

// MARK: ** View Manipulation

extension WeatherViewController {
    
    fileprivate func setStackViewDayState() {
        if stackViewState.arrangedSubviews.count != 0 {
            resetStackViewDayState()
        }
        stackViewState.insertArrangedSubview(createDayState(number: 8), at: 0)
        stackViewState.insertArrangedSubview(createDayState(number: 16), at: 1)
        stackViewState.insertArrangedSubview(createDayState(number: 24), at: 2)
        stackViewState.insertArrangedSubview(createDayState(number: 32), at: 3)
        stackViewState.insertArrangedSubview(createDayState(number: 39), at: 4)
    }
    
    fileprivate func resetStackViewDayState() {
        stackViewState.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
    }
    
    fileprivate func repositionCell() {
        let indexPath: IndexPath = IndexPath(row: 0, section: 0)
        self.tableViewWeather.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    fileprivate func setRefreshControl() {
        let titleAttribute = [NSAttributedString.Key.foregroundColor: UIColor.blue,
                              NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)]
        self.refreshControl!.tintColor = UIColor.white
        self.refreshControl!.backgroundColor =  UIColor(displayP3Red: 0.612, green: 0.804, blue: 0.91, alpha: 1)
        self.refreshControl!.attributedTitle = NSAttributedString(string: "Pull down for reloading", attributes: titleAttribute )
        self.refreshControl!.addTarget(self, action: #selector(handleSwipes(_:)), for: .valueChanged)
        self.view.addSubview(refreshControl!)    }
    
}


