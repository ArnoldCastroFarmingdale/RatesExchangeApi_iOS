//
//  HistoryDetailsVC.swift
//  EcbCurrencyConverter
//
//  Created by Vassilis Voutsas on 31/07/2018.
//  Copyright © 2018 Vassilis Voutsas. All rights reserved.
//

import UIKit

class HistoryDetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: - Properties
    //------------------
    private let cellId = "cellRate"
    private var historyRates: RatesModel?
    var historyDate: String?
    var currency: Currency?
    
    
    //MARK: - IBOutlets
    //-----------------
    @IBOutlet weak var tblHistoryRates: UITableView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCurrency: UILabel!
    
    
    
    //MARK: - Main methods
    //--------------------
    func getData() {
        guard let currency = currency, let date = historyDate else { return }
        lblDate.text = date
        lblCurrency.text = currency.description
        fetchRatesData(createHistoryDataUri(symbol: currency.symbol, date: date))
    }
    
    func createHistoryDataUri(symbol currency: String, date: String) -> String {
        return "\(Routes.historyRatesForCurrency)&base_currency=\(currency)&date=\(date)"
    }

    func fetchRatesData(_ url: String) {
        let spinner = showLoader(view: self.view)
        ApiService.shared.fetchApiData(urlString: url) { (rates: RatesModel) in
            self.historyRates = rates
            self.tblHistoryRates.reloadData()
            spinner.dismissLoader()
        }
    }
    
    
    
    //MARK: - Table View delegate methods
    //-----------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyRates?.rates.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! RateCell
        guard let data = historyRates?.rates else { return cell }
        let rateData = data[indexPath.row]
        cell.lblCurrencyDescr.text = rateData.currency
        cell.lblCurrencyIso.text = rateData.symbol
        cell.lblAmount.text = String(rateData.value)
        cell.imgCurrency.image = UIImage(named: "\(rateData.symbol.lowercased())")
        return cell
    }
    
    
    
    //MARK: - View Controller Lifecycle
    //---------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Historical Rates (\(currency?.symbol ?? ""))"
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false
        
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
