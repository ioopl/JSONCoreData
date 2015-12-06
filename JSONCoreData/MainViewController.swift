//
//  MainViewController.swift
//  JSONCoreData
//
//  Created by UHS on 05/12/2015.
//  Copyright © 2015 Apkia. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData

class MainViewController: UITableViewController {
    
    // MARK: - Variables
    var id:Int = 0
    var firstName = ""
    var surName = ""
    var address = ""
    var phoneNumber = ""
    var email = ""
    var createdAt = ""
    var updatedAt = ""
    var results:NSArray = []

    // MARK: - Constants
    let tableName = "TableUsers"
    let customCell:String = "Cell"
    let segueIdentifier = "goToDetailViewFromMainView"
    
    // MARK: - Class Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        refreshData()
    }
    
    
    func setupUI() {
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.registerNib(UINib(nibName: "MainViewControllerTableViewCell", bundle: nil), forCellReuseIdentifier: customCell)

        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: Selector("refreshData"))
        
        let deleteButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Trash, target: self, action: Selector("deleteAllEntriesInDataBaseForTable"))
        
        navigationItem.leftBarButtonItem = deleteButton
        navigationItem.rightBarButtonItem = refreshButton
        
    }
    
    
    func refreshData() {
        do{
            try loadData()
            tableView.reloadData()
        } catch {
            errorMessage()
        }
    }
    
    // MARK: - Display Data
    func loadData() throws {
        
        let appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        
        let request = NSFetchRequest(entityName: tableName)
        request.returnsObjectsAsFaults = false
        request.returnsDistinctResults = true
        
        results = try context.executeFetchRequest(request)
        
        if results.count > 0 {
            tableView.reloadData()
        } else {
        
            fetchData()
            tableView.reloadData()
        }
    }
    
    // MARK: - Fecth and Store Data
    func fetchData() {
        let apiURL = "http://fast-gorge.herokuapp.com/contacts"
        getDataFromAPI(apiURL)
    }
    
    // MARK: - API Call to Fetch JSON Data
    func getDataFromAPI(apiURL:String) {
        
        let path = apiURL
        let url = NSURL(string: path)
        let session = NSURLSession.sharedSession() // The singleton shared session
        // Data tasks send and receive data using NSData objects.
        let task =
        session.dataTaskWithURL(url!) { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            
            if let jsonData = data {
                let json = JSON(data: jsonData)
                
                for var i = 0; i < json.count; i++ {
                    if let id = json[i]["id"].int, fn = json[i]["first_name"].string, sn = json[i]["surname"].string, ad = json[i]["address"].string, pn = json[i]["phone_number"].string,  em = json[i]["email"].string, ca = json[i]["createdAt"].string, ua = json[i]["updatedAt"].string  {
                        
                        self.id = id
                        self.firstName = fn
                        self.surName = sn
                        self.address = ad
                        self.phoneNumber = pn
                        self.email = em
                        self.createdAt = ca
                        self.updatedAt = ua
                    }
                    self.insertValuesInDataStore(self.id, fn: self.firstName, sn: self.surName, add: self.address, pn: self.phoneNumber, em: self.email, ca: self.createdAt, ua: self.updatedAt)
                    
                    // Could add a closure to the main queue(thread), if we access any UIKit classes.
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        // Any UI Updates would have been here! & Sent Back to Main Queue
                    })
                }
            }
            if (error != nil) {
                self.errorMessage()
            }
        }
        task.resume()
    }
    
    // MARK: - Save Data Function
    func insertValuesInDataStore(id:Int,fn:String,sn:String,add:String, pn:String,em:String,ca:String,ua:String) {
        
        let appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        let newEntry = NSEntityDescription.insertNewObjectForEntityForName(tableName, inManagedObjectContext: context) as NSManagedObject
        
        do {
            newEntry.setValue(id, forKey: "id")
            newEntry.setValue(fn, forKey: "first_name")
            newEntry.setValue(sn, forKey: "surname")
            newEntry.setValue(add, forKey: "address")
            newEntry.setValue(pn, forKey: "phone_number")
            newEntry.setValue(em, forKey: "email")
            newEntry.setValue(ca, forKey: "createdAt")
            newEntry.setValue(ua, forKey: "updatedAt")
            try context.save()
        }
        catch {
            
            errorMessage()
        }
    }
    

    // MARK: - Delete Data Function
    func deleteAllEntriesInDataBaseForTable() {
        
        let appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        let entityDescription = NSEntityDescription.entityForName(tableName, inManagedObjectContext: context)
        let request = NSFetchRequest()
        request.entity = entityDescription
        
        do {
            let fetchedEntities = try context.executeFetchRequest(request)
            
            for entity in fetchedEntities {
                context.deleteObject(entity as! NSManagedObject)
            }
            try  context.save()
        }
        catch {
            
            errorMessage()
         }
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:MainViewControllerTableViewCell = tableView.dequeueReusableCellWithIdentifier(customCell) as! MainViewControllerTableViewCell
        
        let firstName = results.valueForKey("first_name")[indexPath.row] as! String
        let surName = results.valueForKey("surname")[indexPath.row] as! String
        let cellObjectID = results.valueForKey("id")[indexPath.row] as! Int
        
        cell.lblFirstName.text = firstName
        cell.lblSurName.text = surName
        cell.lblObjectID.text = "\(cellObjectID)"
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell:MainViewControllerTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! MainViewControllerTableViewCell
        if let objID:Int = Int(cell.lblObjectID.text!) {
            objectID = objID
        self.performSegueWithIdentifier(segueIdentifier, sender: self)
        }
    }

    // MARK: - Error Handling
    func errorMessage() {
        let alertController = UIAlertController(title: "Something went wrong!", message: "Please try later in few moments", preferredStyle: UIAlertControllerStyle.Alert)
        
        let oKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action) -> Void in
            
        }
        alertController.addAction(oKAction)
        presentViewController(alertController, animated: true) {
        }
    }
    
}
