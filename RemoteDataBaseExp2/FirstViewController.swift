//Author: Jamie Chen

import UIKit
import Darwin
import Foundation

class FirstViewController: UIViewController, UITextFieldDelegate{
    @IBOutlet var emailTxtfield: UITextField!
    @IBOutlet var passwordTxtfield: UITextField!
    @IBOutlet var nameTxtfield: UITextField!
    @IBOutlet var salaryTxtfield: UITextField!
  
    
    
    @IBOutlet var successLabel: UILabel!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
        
    var response = ""
    var year = ""
    var month = ""
    var day = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTxtfield.delegate = self
        passwordTxtfield.delegate = self
        nameTxtfield.delegate = self
        salaryTxtfield.delegate = self
 
        
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(FirstViewController.dateChanged(datePicker:)), for: .valueChanged)
        
       successLabel.text = ""
        // Do any additional setup after loading the view.
    }
    @IBAction func register(_ sender: UIButton){
        successLabel.text = ""
        let email_: String = emailTxtfield.text!
        let pass_: String = passwordTxtfield.text!
        let name_: String = nameTxtfield.text!
        var salary_: String = salaryTxtfield.text!
        if(salary_ == ""){
            salary_ = "";
        }
     
        
        let bdate = (year + "-" + month + "-" + day)
        print(hashString(clearText: pass_))
        let hashedPass: String = hashString(clearText: pass_)
        print("Register with "  + email_ + " | " + hashedPass + " + " + salary_ + " " + bdate + "  " + name_)
        registerRequest(email: email_, pass: hashedPass, name: name_, day: day, month: month, year: year, salary: salary_, option: "register")
        sleep(1)
        
        successLabel.text = response
        print(response)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTxtfield.resignFirstResponder()
        passwordTxtfield.resignFirstResponder()
        nameTxtfield.resignFirstResponder()
        salaryTxtfield.resignFirstResponder()
 
        return true;
    }
    func registerRequest(email: String, pass: String, name: String, day: String, month: String, year: String, salary: String, option: String){

        let url = URL(string: "http://" + globalVars.HOST_IP + ":" + globalVars.HOST_PORT + "/" + option + "?email=" + email + "&password=" + pass + "&salary=" + salary + "&day=" + day + "&month=" + month + "&year=" + year + "&name=" + name)!
        var r = "Error in message"
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            r = String(data: data, encoding: .utf8)!
            
            self.response = r
            
        }
        task.resume()
        
       
    }
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        let currentDate = Date()
        dateFormatter.dateFormat = "dd"
        day = dateFormatter.string(from: datePicker.date)
        let currentDay = dateFormatter.string(from: currentDate)
        dateFormatter.dateFormat = "MM"
        month = dateFormatter.string(from: datePicker.date)
        let currentMonth = dateFormatter.string(from: currentDate)
        dateFormatter.dateFormat = "yyyy"
        year = dateFormatter.string(from: datePicker.date)
        let currentYear = dateFormatter.string(from: currentDate)
        print(year + " " + month + " " + day)
        if(year == currentYear && month == currentMonth && day == currentDay){
            year = ""
            month = ""
            day = ""
        }
        view.endEditing(true)
    }
}

