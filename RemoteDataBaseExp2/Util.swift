//Author: Jamie Chen
import UIKit
import Darwin
import Foundation
import CryptoKit
import CoreData

struct globalVars{
    static var HOST_IP : String = ""
    static var HOST_PORT : String = ""
}
func hashString(clearText: String) -> String {
 
    let inputData = Data(clearText.utf8)
    let hash = SHA256.hash(data: inputData) //hashing with SHA256
    
    return hash.compactMap{ String(format: "%02x", $0)}.joined() //return string of the hash
}


func clearCore(option : String){ // clear all Person entities in core data
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
    let managedObjectContext  = appDelegate.persistentContainer.viewContext
  
    
    if(option != "list"){
        let superfetchRequest = NSFetchRequest <NSFetchRequestResult>(entityName: "LoggedIn")
           do{
             let results = try managedObjectContext.fetch(superfetchRequest)
             for item in results as! [NSManagedObject]{
                 managedObjectContext.delete(item)
             }
           }
           catch{
             print("Failed Deletion")
           }
    }
    let fetchRequest = NSFetchRequest <NSFetchRequestResult>(entityName: "User")
    do{
      let results = try managedObjectContext.fetch(fetchRequest)
      for item in results as! [NSManagedObject]{
          managedObjectContext.delete(item)
      }
    }
    catch{
      print("Failed Deletion")
    }
   
    
}

func getUserList() -> String {
    var data_: Data = Data()
    var resp : String = String()
    print("get Users")

    let url = URL(string:"http://" + globalVars.HOST_IP + ":" + globalVars.HOST_PORT + "/getList")!
     let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
         guard let data = data else { return }
         let r = String(data: data, encoding: .utf8)!
         resp = r
         data_ = data
          //print(r)
     }
     task.resume()
   
     sleep(1)
   
     if(resp != "Login Failed"){
        let json = try? JSONSerialization.jsonObject(with: data_, options: [])
        print(json!)

        if let object = json as? [Any] {
        
            print("try to convert")
            print("list:")
            print(json!)
            for dic in object as! [Dictionary<String, AnyObject>]{
                let name = dic["name"] as? String
                let email = dic["email"] as? String
                let password = dic["password"] as? String
                let birthday = dic["birthday"] as? String
                let timestamp = dic["timestamp"] as? String
                let salary = dic["salary"] as? Double
                let loginNum = dic["login_num"] as? Int
                let is_admin = dic["is_admin"] as? Bool
                print(timestamp! + "got all json")
                
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {print("Error trying to get delegate"); return "Error trying to get delegate"}
                let managedObjectContext  = appDelegate.persistentContainer.viewContext
                //set logged in user info to core data
                let superEntity = NSEntityDescription.entity(forEntityName: "User", in: managedObjectContext)
                let superObject = NSManagedObject(entity: superEntity!, insertInto: managedObjectContext)
                superObject.setValue(name, forKey: "name")
                superObject.setValue(email, forKey: "email")
                superObject.setValue(password, forKey: "password")
                superObject.setValue(timestamp, forKey: "timestamp")
                superObject.setValue(salary, forKey: "salary")
                superObject.setValue(loginNum, forKey: "login_num")
                superObject.setValue(is_admin, forKey: "isAdmin")
                superObject.setValue(birthday, forKey: "birthday")
                do{
                  try managedObjectContext.save()
                   print("done saving list")
                }
                catch let error {
                  print("Error setting core data")
                }
           }
        }
        else{
           print("Response JSON is invalid")
       }
   }
   else{
        print("Login failed")
   }
   return resp
}

