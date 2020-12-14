//
//  ViewController.swift
//  Stocks
//
//  Created by Влад Динеев on 13.12.2020.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    private let companies: [String: String] = ["Apple":"AAPL",
                                               "Microsoft":"MSFT",
                                               "Google":"GOOG",
                                               "Amazon":"AMZN",
                                               "Facbook":"FB"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.companies.keys.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array(self.companies.keys)[row]
    }
    
    private func requestLogo(for symbol: String){
        let url = URL(string: "https://cloud.iexapis.com/v1/stock/\(symbol)/logo?token=pk_6a5a6cd113194921a2905cb98fc95cdf")!
        let dataTask = URLSession.shared.dataTask(with: url){ data, response, error in
            guard
                error == nil,
                (response as? HTTPURLResponse)?.statusCode == 200,
                let data = data
            else{
                print("Network error!")
                return
            }
            
            self.parseLogoUrl(data: data)
        }
        
        dataTask.resume()
    }
    
    private func parseLogoUrl(data: Data){
        do{
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            
            guard
                let json = jsonObject as? [String:Any],
                let url = json["url"] as? String
            else {
                print("Invalid JSON format!")
                return
            }
            DispatchQueue.main.async {
                self.renewLogo(urlString: url)
            }
        }
        catch{
            print("JSON parsing error: " + error.localizedDescription)
        }
    }
    
    private func renewLogo(urlString:String){
        let url = URL(string: urlString)!
        let dataTask = URLSession.shared.dataTask(with: url){ data, response, error in
            guard
                error == nil,
                (response as? HTTPURLResponse)?.statusCode == 200,
                let data = data
            else{
                print("Network error!")
                return
            }
            
            self.parseLogo(data: data)
        }
        
        dataTask.resume()
    }
    
    private func parseLogo(data: Data){
        DispatchQueue.main.async {
            self.companyLogo.image = UIImage(data: data)
        }
    }
    
    public func requestQuote(for symbol: String){
        let url = URL(string: "https://cloud.iexapis.com/v1/stock/\(symbol)/quote?token=pk_6a5a6cd113194921a2905cb98fc95cdf")!
        let dataTask = URLSession.shared.dataTask(with: url){ data, response, error in
            guard
                error == nil,
                (response as? HTTPURLResponse)?.statusCode == 200,
                let data = data
            else{
                print("Network error!")
                return
            }
            
            self.parseQuote(data: data)
        }
        
        dataTask.resume()
    }
    
    private func parseQuote(data: Data){
        do{
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            
            guard
                let json = jsonObject as? [String:Any],
                let companyName = json["companyName"] as? String,
                let companySymbol = json["symbol"] as? String,
                let price = json["latestPrice"] as? Double,
                let priceChange = json["change"] as? Double
            else {
                print("Invalid JSON format!")
                return
            }
            DispatchQueue.main.async {
                self.displayStockInfo(companyName: companyName,
                                      symbol: companySymbol,
                                      price: price,
                                      priceChange: priceChange)
            }
        }
        catch{
            print("JSON parsing error: " + error.localizedDescription)
        }
    }
    
    private func displayStockInfo(companyName: String, symbol: String, price: Double, priceChange: Double){
        self.activityIndicator.stopAnimating()
        self.companyNameLabel.text = companyName
        self.companySymbolLabel.text = symbol
        self.priceLabel.text = "\(price)"
        self.priceChangeLabel.text = "\(priceChange)"
        self.priceChangeLabel.textColor = priceChange > 0 ? UIColor.green : priceChange < 0 ? UIColor.red : UIColor.black
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.requestQuoteUpdate()
    }
    
    private func requestQuoteUpdate(){
        self.activityIndicator.startAnimating()
        self.companyNameLabel.text = "-"
        self.companySymbolLabel.text = "-"
        self.priceLabel.text = "-"
        self.priceChangeLabel.text = "-"
        self.priceChangeLabel.textColor = UIColor.black
        self.companyLogo.image = nil
        
        let selectedRow = self.companyPickerView.selectedRow(inComponent: 0)
        let selectedSymbol = Array(self.companies.values)[selectedRow]
        self.requestQuote(for: selectedSymbol)
        self.requestLogo(for: selectedSymbol)
    }
    
    @IBOutlet weak var companyLogo: UIImageView!
    @IBOutlet weak var priceChangeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var companySymbolLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var companyPickerView: UIPickerView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.companyNameLabel.text = "Tinkoff"
        self.companyPickerView.dataSource = self
        self.companyPickerView.delegate = self
        self.activityIndicator.hidesWhenStopped = true
        
        self.requestQuoteUpdate()
    }


}

