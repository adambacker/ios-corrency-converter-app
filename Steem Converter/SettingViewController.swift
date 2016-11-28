//
//  SettingViewController.swift
//  Steem Converter
//
//  Created by mac-772 on 11/23/16.
//  Copyright © 2016 mac-772. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    
    var price_kind = "USD"
    var rate = 1.0
    
    var pickerViewSource = ["USD", "EUR", "GBP", "RUB", "CNY", "YEN", "CHF", "AUD"]
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var steemLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var steemTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    
 
    @IBAction func btnCliecked(_ sender: Any) {
        
    }
    
    @IBAction func changeSteemTextField(_ sender: UITextField) {
        let str = steemTextField.text
        if (str?.isEmpty)! {
            return
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let steem = NumberFormatter().number(from: str!)?.doubleValue
        priceTextField.text = String(format: "%.4f", steem! * appDelegate.price_usd * rate)
    }
    
    @IBAction func changePriceTextField(_ sender: UITextField) {
        let str = priceTextField.text
        if (str?.isEmpty)! {
            return
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let price = NumberFormatter().number(from: str!)?.doubleValue
        steemTextField.text = String(format: "%.0f", price! / appDelegate.price_usd / rate)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        steemLabel.layer.masksToBounds = true
        steemLabel.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        pickerView.dataSource = self
        pickerView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //CREATING PICKER VIEW
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return pickerViewSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return pickerViewSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        price_kind = pickerViewSource[row]
        switch price_kind {
        case "USD":
            label.text = "$  " + price_kind
            rate = 1.0
        case "EUR":
            label.text = "€  " + price_kind
            rate = 0.9461
        case "GBP":
            label.text = "£  " + price_kind
            rate = 0.8017
        case "RUB":
            label.text = "₽  " + price_kind
            rate = 64.3435
        case "CNY":
            label.text = "¥  " + price_kind
            rate = 6.9137
        case "YEN":
            label.text = "¥  " + price_kind
            rate = 6.26
        case "AUD":
            label.text = "$  " + price_kind
            rate = 1.3498
        case "CAD":
            label.text = "$  " + price_kind
            rate = 1.3483
        default:
            label.text = "$  " + price_kind
            rate = 1.0
        }
        
        if steemTextField.isEditing {
            let str = steemTextField.text
            if (str?.isEmpty)! {
                return
            }
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let steem = NumberFormatter().number(from: str!)?.doubleValue
            priceTextField.text = String(format: "%.4f", steem! * appDelegate.price_usd * rate)
        }
        if priceTextField.isEditing {
            let str = priceTextField.text
            if (str?.isEmpty)! {
                return
            }
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let price = NumberFormatter().number(from: str!)?.doubleValue
            steemTextField.text = String(format: "%.0f", price! / appDelegate.price_usd / rate)
        }
  
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
