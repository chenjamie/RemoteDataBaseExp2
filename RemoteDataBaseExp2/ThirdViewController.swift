//Author: Jamie Chen

import UIKit
import CoreData

// arrays for displaying data in UITableVIew
var nameArray : [String] = [String]()
var emailArray :  [String] = [String]()
var passArray : [String] = [String]()
var birthdayArray :  [String] = [String]()
var salaryArray : [Double] = [Double]()
var loginNumArray :  [Int] = [Int]()
var isAdminArray: [Bool] = [Bool]()
var timeStampArray : [String] = [String]()


var super_email: String = ""
var super_admin: Bool = false

var selectionIndex = 0;


class ThirdViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //IBOutlets
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet var successLabel: UILabel!
    @IBOutlet var refresh: UIButton!
    
    
    var response : String = String()
    var data: Data = Data()

    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.reloadData()
        
    }
    override func viewWillAppear(_ animated: Bool) { // reload tableview with new data
        resetArrays()
        setUsers()
        myTableView.reloadData()
    }
    @IBAction func refresh(_ sender: UIButton){ // reset coredata, get current data, refresh tableview
        resetArrays()
        clearCore(option: "list")
        self.response = getUserList()
        setUsers()
        myTableView.reloadData()
    }
    func setUsers(){ // populate display arrays with data from core data
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedObjectContext  = appDelegate.persistentContainer.viewContext
        let fetchRequest_super = NSFetchRequest <NSFetchRequestResult>(entityName: "LoggedIn")
        
        do{
            let super_results = try managedObjectContext.fetch(fetchRequest_super)
            for item in super_results as! [NSManagedObject] {
                super_admin = item.value(forKey: "isAdmin") as! Bool
                super_email = item.value(forKey: "email") as! String
            }
        }
        catch {
           print("Failed")
       }
        if(super_admin){
            print("getting all info from coredata")
            let fetchRequest = NSFetchRequest <NSFetchRequestResult>(entityName: "User")
            
             do{
                 let results = try managedObjectContext.fetch(fetchRequest)
                 for item in results as! [NSManagedObject] {
                     nameArray.append(item.value(forKey: "name") as! String)
                     print(item.value(forKey: "name") as! String)
                     emailArray.append(item.value(forKey: "email") as! String)
                     passArray.append(item.value(forKey: "password") as! String)
                     let b = item.value(forKey: "birthday")
                     if(b == nil){
                        birthdayArray.append("None")

                     }
                     else{
                        birthdayArray.append(b as! String)
                     }
                     salaryArray.append(item.value(forKey: "salary") as! Double)
                     loginNumArray.append(item.value(forKey: "login_num") as! Int)
                     timeStampArray.append(item.value(forKey: "timestamp") as! String)
                     isAdminArray.append(item.value(forKey: "isAdmin") as! Bool)
                 }
             }
             catch {
                 print("Failed")
             }
        }
        
        else{
            print("getting superuser info from coredata")
            do{
                
                 let super_results = try managedObjectContext.fetch(fetchRequest_super)
                 for item in super_results as! [NSManagedObject] {
                     nameArray.append(item.value(forKey: "name") as! String)
                     emailArray.append(item.value(forKey: "email") as! String)
                     passArray.append(item.value(forKey: "password") as! String)
                     birthdayArray.append(item.value(forKey: "birthday") as! String)
                     salaryArray.append(item.value(forKey: "salary") as! Double)
                     loginNumArray.append(item.value(forKey: "login_num") as! Int)
                     timeStampArray.append(item.value(forKey: "timestamp") as! String)
                     isAdminArray.append(item.value(forKey: "isAdmin") as! Bool)
                 }
             }
             catch {
                print("Failed")
            }
        }
        
        
        print(nameArray)
        print(emailArray)
        print(passArray)
    }
    
    func resetArrays(){ //clear arrays for display in tableview
        nameArray = [String]()
        emailArray = [String]()
        passArray = [String]()
        birthdayArray = [String]()
        salaryArray = [Double]()
        loginNumArray = [Int]()
        timeStampArray = [String]()
        isAdminArray = [Bool]()
        
    }
    
    //functions required for tableView functionality
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        cell.textLabel?.text = "Email: " + emailArray[indexPath.row] + " Name: " + nameArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectionIndex = indexPath.row
        performSegue(withIdentifier: "edit", sender: self)
    }

}



