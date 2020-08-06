//Author: Jamie Chen

import UIKit
import Darwin
import Foundation
import CoreData


class SecondViewController: UIViewController, UITextFieldDelegate{
    //IBoutlets
    @IBOutlet var emailTxtfield: UITextField!
    @IBOutlet var passwordTxtfield: UITextField!
    @IBOutlet var successLabel: UILabel!
    
    //global variables
    var response = ""
    var is_Admin = false;
    var super_email : String = "";
    var super_name : String = "";
    var super_password : String = "";
    var super_birthday : String = "";
    var super_salary : Double = -1.0;
    var super_login : Int = -1;
    var super_admin : Bool = false;
    var super_ts : String = "";
    var data : Data = Data()

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTxtfield.delegate = self
        passwordTxtfield.delegate = self
        successLabel.text = ""
        // Do any additional setup after loading the view.
    }
    @IBAction func login(_ sender: UIButton){
        clearCore(option: "all")
        successLabel.text = ""
        let email_: String = emailTxtfield.text!
        let pass_: String = passwordTxtfield.text!
        print("login with "  + email_ + " | " + pass_)
        let hashed = hashString(clearText: pass_)
        loginRequest(email: email_, pass: hashed, option: "login")
        sleep(1)
        
        print("start saving in coredata")
         guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
         let managedObjectContext  = appDelegate.persistentContainer.viewContext
         //set logged in user info to core data
         let superEntity = NSEntityDescription.entity(forEntityName: "LoggedIn", in: managedObjectContext)
         let superObject = NSManagedObject(entity: superEntity!, insertInto: managedObjectContext)
        superObject.setValue(self.super_name, forKey: "name")
         superObject.setValue(self.super_email, forKey: "email")
         superObject.setValue(self.super_password, forKey: "password")
         superObject.setValue(self.super_ts, forKey: "timestamp")
         superObject.setValue(self.super_salary, forKey: "salary")
         superObject.setValue(self.super_login, forKey: "login_num")
         superObject.setValue(self.super_admin, forKey: "isAdmin")
         superObject.setValue(self.super_birthday, forKey: "birthday")
         self.is_Admin = self.super_admin
         do{
             try managedObjectContext.save()
             print("done saving with " + String(is_Admin) + " " + String(self.super_admin ))
         }
         catch let error {
             print("Error setting core data")
         }
        
        if(is_Admin){
            print("is admin")
            self.response = getUserList()
        }
        if(response == "Error with server"){
            successLabel.text = response
        }
        else{
            successLabel.text = "Success"
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTxtfield.resignFirstResponder()
        passwordTxtfield.resignFirstResponder()
        return true;
    }
     func loginRequest(email: String, pass: String, option: String){
          
           let url = URL(string:"http://" + globalVars.HOST_IP + ":" + globalVars.HOST_PORT + "/" + option + "?email=" + email + "&password=" + pass)!
           let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
               guard let data = data else { return }
                let r = String(data: data, encoding: .utf8)!
                print(r)
                if(r == "Error with server"){
                    self.response = r
                }
                else if(r != "Login Failed"){
                    let json = try? JSONSerialization.jsonObject(with: data, options: [])
                    guard let jsonArray = json as? [String: Any] else {
                        return
                    }
                    print("got person info:")
                    //print(jsonArray)
                    guard let name = jsonArray["name"] as? String else {return}
                    self.super_name = name
                    print(self.super_name)
                    guard let email = jsonArray["email"] as? String else {return}
                    self.super_email = email

                    print(email)
                    guard let password = jsonArray["password"] as? String else {return}
                    self.super_password = password

                    print(password)
                    
                    guard let birthday = jsonArray["birthday"] as? String else {return}
                    self.super_birthday = birthday
                    print(birthday)
                    
                    guard let timestamp = jsonArray["timestamp"] as? String else {return}
                    self.super_ts = timestamp

                    print(timestamp)
                    guard let salary = jsonArray["salary"] as? Double else {return}
                    self.super_salary = salary

                    print(salary)
                    guard let loginNum = jsonArray["login_num"] as? Int else {return}
                    self.super_login = loginNum

                    print(loginNum)
                    guard let is_admin = jsonArray["is_admin"] as? Bool else {return}
                    self.super_admin = is_admin

                    print(String(is_admin))
                    self.response = "Success"
                }
                else{
                    self.response = r
                }
           }
           task.resume()
        
         
       }
   

 
}
