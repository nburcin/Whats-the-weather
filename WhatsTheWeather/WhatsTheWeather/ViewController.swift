//
//  ViewController.swift
//  WhatsTheWeather
//
//  Created by Nicholas Burcin on 10/28/18.
//  Copyright © 2018 Burcin Software. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var resultLbl: UILabel!
    @IBOutlet weak var enterBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLbl.layer.cornerRadius = 10.0
        textField.layer.cornerRadius = 10.0
        enterBtn.layer.cornerRadius = 10.0
        
        
    }

    @IBAction func enterBtn(_ sender: Any) {
        getWeather()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        getWeather()
        return true
    }
    func getWeather() {
        if let url = URL(string: "https://www.weather-forecast.com/locations/" + textField.text!.replacingOccurrences(of: " ", with: "-") + "/forecasts/latest") {
        let request = NSMutableURLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            var message = ""
            if let error = error {
                print(error)
            } else {
                if let unwrappedData = data {
                    let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                    var stringSeparator = "Weather Today </h2>(1&ndash;3 days)</span><p class=\"b-forecast__table-description-content\"><span class=\"phrase\">"
                    if let contentArray = dataString?.components(separatedBy: stringSeparator) {
                        if contentArray.count > 1 {
                            stringSeparator = "</span>"
                            let newContentArray = contentArray[1].components(separatedBy: stringSeparator)
                            if newContentArray.count > 1 {
                                message = newContentArray[0].replacingOccurrences(of: "&deg;", with: "°")
                                print(message)
                            }
                        }
                    }
                }
            }
            if message == "" {
                message = "The weather there could not be found. Please try again."
            }
            DispatchQueue.main.sync(execute: {
                self.resultLbl.text = message
                
            })
        }
        task.resume()
        textField.text = ""
        } else {
            resultLbl.text = "The weather could not be found. Please try again."
        }
    }
}

