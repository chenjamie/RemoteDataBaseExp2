//Author: Jamie Chen
import UIKit
import Darwin
import Foundation
import CoreData

class FourthViewController: UIViewController, UITextFieldDelegate{
     @IBOutlet var emailTxtfield: UITextField!
     @IBOutlet var passwordTxtfield: UITextField!
     @IBOutlet var nameTxtfield: UITextField!
     @IBOutlet var salaryTxtfield: UITextField!
     //@IBOutlet var yearTxtfield: UITextField!
     //@IBOutlet var monthTxtfield: UITextField!
     //@IBOutlet var dayTxtfield: UITextField!
     @IBOutlet var successLabel: UILabel!
     @IBOutlet var emailLabel: UILabel!
     @IBOutlet var nameLabel: UILabel!
     @IBOutlet var passwordLabel: UILabel!
     @IBOutlet var salaryLabel: UILabel!
     @IBOutlet var birthdayLabel: UILabel!
     @IBOutlet var loginNumLabel: UILabel!
     @IBOutlet var adminLabel: UILabel!
     @IBOutlet var tsLabel: UILabel!
     @IBOutlet weak var datePicker: UIDatePicker!
    
     var response = ""
     var is_Admin = false;
     var year = ""
     var month = ""
     var day = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        emailTxtfield.delegate = self
        passwordTxtfield.delegate = self
        nameTxtfield.delegate = self
        salaryTxtfield.delegate = self
        //yearTxtfield.delegate = self
        //monthTxtfield.delegate = self
        //dayTxtfield.delegate = self
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(FirstViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        successLabel.text = ""
        
        emailLabel.text = emailArray[selectionIndex]
        nameLabel.text = nameArray[selectionIndex]
        passwordLabel.text = passArray[selectionIndex]
        salaryLabel.text = String(salaryArray[selectionIndex])
        birthdayLabel.text = birthdayArray[selectionIndex]
        loginNumLabel.text = String(loginNumArray[selectionIndex])
        adminLabel.text = String(isAdminArray[selectionIndex])
        tsLabel.text = timeStampArray[selectionIndex]
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTxtfield.resignFirstResponder()
        passwordTxtfield.resignFirstResponder()
        nameTxtfield.resignFirstResponder()
        salaryTxtfield.resignFirstResponder()
        //yearTxtfield.resignFirstResponder()
        //monthTxtfield.resignFirstResponder()
        //dayTxtfield.resignFirstResponder()

        return true;
    }
    @IBAction func dismiss(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeValue(_ sender: UIButton){
        var failure = ""
        if(nameTxtfield.text != ""){
            changeValueName()
            if(response != "Success"){
                failure += "Name "
            }
        }
        if(passwordTxtfield.text != ""){
            changeValuePassword()
            if(response != "Success"){
                failure += "Password "
            }
        }
        if(emailTxtfield.text != ""){
            changeValueEmail()
            if(response != "Success"){
                failure += "Email "
            }
        }
        if(salaryTxtfield.text != ""){
            changeValueSalary()
            if(response != "Success"){
                failure += "Salary "
            }
        }
        if(year != ""){
            changeValueBirthday()
            if(response != "Success"){
                failure += "Birthday "
            }
        }
        if(failure != ""){
            successLabel.text = "Failed in updating the following fields: " + failure
        }
        else{
            successLabel.text = "Success"
        }
        
    }
    
    func changeValueName(){
        print("update name: " + nameTxtfield.text!)
        changeValue(email: emailArray[selectionIndex], field: "name", value1: nameTxtfield.text!, value2: "", value3: "")
       
        if (response == "Success"){
            nameArray[selectionIndex] = nameTxtfield.text!
            nameLabel.text = nameTxtfield.text!
        }
    }
    func changeValueEmail(){
        print("update email: " + emailTxtfield.text!)
        changeValue(email: emailArray[selectionIndex], field: "email", value1: emailTxtfield.text!, value2: "", value3: "")
        if (response == "Success"){
            emailArray[selectionIndex] = emailTxtfield.text!
            emailLabel.text = emailTxtfield.text!
        }
    }
    func changeValuePassword(){
        let encryptPass = hashString(clearText: passwordTxtfield.text!)
        print("update hashed pass: " + encryptPass + " | " + passwordTxtfield.text!)
        
        changeValue(email: emailArray[selectionIndex], field: "password", value1: encryptPass, value2: "", value3: "")
        if (response == "Success"){
            passArray[selectionIndex] = passwordTxtfield.text!
            passwordLabel.text = passwordTxtfield.text!
        }
    }
   func changeValueSalary(){
        print("update salary: " + nameTxtfield.text!)

        changeValue(email: emailArray[selectionIndex], field: "salary", value1: salaryTxtfield.text!, value2: "", value3: "")
        if (response == "Success"){
            salaryArray[selectionIndex] = (salaryTxtfield.text! as NSString).doubleValue
            salaryLabel.text = salaryTxtfield.text!
        }
    }
   func changeValueBirthday(){
        print("update birthday " + year + "-" + month + "-" + day)
        changeValue(email: emailArray[selectionIndex], field: "birthday", value1: year, value2: month, value3: day)
        if (response == "Success"){
            birthdayArray[selectionIndex] = year + "-" + month + "-" + day
            birthdayLabel.text = birthdayArray[selectionIndex]
        }
    }
    func changeAdmin(){
        print("update user admin: " + adminLabel.text!)
        changeValue(email: emailArray[selectionIndex], field: "admin", value1: "", value2: "", value3: "")
        if (response == "Success"){
            isAdminArray[selectionIndex] = !isAdminArray[selectionIndex]
            adminLabel.text = String(isAdminArray[selectionIndex])
            super_admin = isAdminArray[selectionIndex]
        }
    }
    
    func changeValue(email: String, field: String, value1: String, value2: String, value3: String){
        var url = ""
        if(field == "birthday"){
            url = ("http://" + globalVars.HOST_IP + ":" + globalVars.HOST_PORT + "/changeValue" + "?email=" + email + "&field=" + field + "&year=" + value1 + "&month=" + value2 + "&day=" + value3)
        }
        else{
             url = "http://" + globalVars.HOST_IP + ":" + globalVars.HOST_PORT + "/changeValue" + "?email=" + email + "&field=" + field + "&value=" + value1
        }
        let superUrl = URL(string: url)!
        let task = URLSession.shared.dataTask(with: superUrl) { (data, response, error) in
           guard let data = data else { return }
            let r = String(data: data, encoding: .utf8)!
            
            self.response = r
          
        }
        task.resume()
        sleep(1)

        
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
