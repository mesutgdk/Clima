
import UIKit
import CoreLocation

class WeatherViewController: UIViewController{
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
  
    var weatherManager = WeatherManager ()
    let locantionManager = CLLocationManager ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        locantionManager.delegate = self
        locantionManager.requestWhenInUseAuthorization()
        locantionManager.requestLocation()
        
       
        weatherManager.delegate = self
        searchTextField.delegate = self
    }
}
//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print (searchTextField.text!)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
      //  print(searchTextField.text!)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {textField.placeholder = "Type something"
        return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Use searchTextFieldçtext to get weather for that city
        if let city = searchTextField.text {
         
            weatherManager.fetchWeather(cityName: city)
         // print(city)
        }
        searchTextField.text = ""
    }
}
    //MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate{
    
    
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async { [self] in
            self.temperatureLabel.text = weather.temperatureString
    
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
            //print(String(describing: conditionImageView.image))
        }
    
    }
    func didFailWithError(error: Error) {
        print(error)
    }
    
}
//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locantionManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
        
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        
        locantionManager.requestLocation()
    }
    }
    



