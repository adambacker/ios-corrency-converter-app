//
//  ChartViewController.swift
//  Steem Converter
//
//  Created by mac-772 on 11/23/16.
//  Copyright © 2016 mac-772. All rights reserved.
//

import UIKit
import CoreData
import Charts
import GoogleMobileAds

class ChartViewController: UIViewController {
    
//    var options:NSArray!
    var priceusdArr:[Double] = []
    var pricebtcArr:[Double] = []
    var dateArr:[String] = []
        
    @IBOutlet weak var lineChartView: LineChartView!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var GoogleBannerView: GADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        ///This is your id!!!!
        GoogleBannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        GoogleBannerView.rootViewController = self
        GoogleBannerView.load(GADRequest())

        getData()
        if priceusdArr.count > 0 {
            priceLabel.text = String(format: "$%.5f", priceusdArr.last!)
            appDelegate.price_usd = priceusdArr.last!
        }
      
        print(priceusdArr)
        print(dateArr)
        setChart(dataPoints: dateArr, values: priceusdArr)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        setChart(dataPoints: dateArr, values: priceusdArr)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        
        var yValues : [ChartDataEntry] = [ChartDataEntry]()
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i + 1), y: Double(values[i]))
            
            yValues.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(values: yValues, label: "price usd")
        
        
        lineChartDataSet.axisDependency = .left
        lineChartDataSet.setColor(UIColor.init(red: 36/255.0, green: 110/255.0, blue: 185/255.0, alpha: 255/255.0))
        lineChartDataSet.setCircleColor(UIColor.init(red: 36/255.0, green: 110/255.0, blue: 185/255.0, alpha: 255/255.0))
        lineChartDataSet.lineWidth = 2.0
        lineChartDataSet.circleRadius = 1.0 // the radius of the node circle
        lineChartDataSet.highlightColor = UIColor.init(red: 52/255.0, green: 180/255.0, blue: 180/255.0, alpha: 255/255.0)
        
        
        let lineChartData = LineChartData()
        
        lineChartData.addDataSet(lineChartDataSet)
        lineChartData.setDrawValues(false)
        lineChartView.data = lineChartData
        lineChartView.animate(xAxisDuration: 1.0)
        lineChartView.backgroundColor = UIColor.init(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 255/255.0)
        lineChartView.xAxis.drawLabelsEnabled = true
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.drawAxisLineEnabled = true
        lineChartView.xAxis.labelPosition = .bottom
        
//        let priceFormatter = NumberFormatter()
//        priceFormatter.numberStyle = .percent
//        let formatter = DefaultValueFormatter(formatter: priceFormatter)
//        lineChartView.leftAxis.valueFormatter = (formatter as? IAxisValueFormatter)
        lineChartView.xAxis.axisLineColor = UIColor.black
        lineChartView.leftAxis.drawAxisLineEnabled = true
        lineChartView.leftAxis.drawLabelsEnabled = true
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.axisLineColor = UIColor.black
        
        
        lineChartView.rightAxis.drawAxisLineEnabled = false
        lineChartView.rightAxis.drawLabelsEnabled = false
        lineChartView.rightAxis.drawGridLinesEnabled = false
        lineChartView.legend.enabled = false
        lineChartView.descriptionText = ""
    }
    
    func getData() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Datas")
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            priceusdArr = []
            pricebtcArr = []
            dateArr = []
            if results.count > 0
            {
                for result in results as! [NSManagedObject]
                {
                    if let priceusd = result.value(forKey: "price_usd") as? Double
                    {
                        priceusdArr.append(priceusd)
                    }
                    if let pricebtc = result.value(forKey: "price_btc") as? Double
                    {
                        pricebtcArr.append(pricebtc)
                    }
                    if let date = result.value(forKey: "date") as? String
                    {
                        dateArr.append(date)
                    }
                }
                
            }
        } catch {
            //PROCESS ERROR
        }
    }
    
    func saveData() {
        // Get json data from URL
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newData = NSEntityDescription.insertNewObject(forEntityName: "Datas", into: context)
        
        var price_usd = 0.1136
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStr = dateFormatter.string(from: date)
        
        let url = URL(string: "https://api.coinmarketcap.com/v1/ticker/steem/")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil
            {
                print ("ERROR")
            }
            else
            {
                
                if let content = data
                {
                    
                    do
                    {
                        let myJsonArray = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        let myJson = myJsonArray[0] as AnyObject
                        let price_usd_str = myJson["price_usd"] as! String
                        
                        price_usd = (NumberFormatter().number(from: price_usd_str)?.doubleValue)!
                        
                        newData.setValue( price_usd, forKey: "price")
                        newData.setValue( dateStr, forKey: "date")
                        
                        do {
                            try context.save()
                            print("SAVE")
//                            print(price_usd)
                        } catch {
                            //PROCESS ERROR
                        }
                                            }
                    catch
                    {
                        
                    }
                }
            }
            //            self.pickerView.reloadAllComponents()
        }
        task.resume()
        
    }
    
    
}
