//
//  DetailsViewController.swift
//  JSONCoreData
//
//  Created by UHS on 06/12/2015.
//  Copyright © 2015 Apkia. All rights reserved.
//

import UIKit
import CoreData

// MARK: - Global Variable
var objectID:Int = 0

// MARK: - Constants

let tableName = "TableUsers"


class DetailsViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblSurName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblCreatedAt: UILabel!
    @IBOutlet weak var lblUpdatedAt: UILabel!
    
    // MARK: - Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        do {
        try loadData()
        } catch {
        // Error
        }
        
    }
    
    
    // MARK: - Display Data
    func loadData() throws {
        
        let appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        
        let request = NSFetchRequest(entityName: tableName)
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "id = %@", String(objectID))
        
        let results:NSArray = try context.executeFetchRequest(request)
        
        if results.count > 0 {
        
            let cellObjectID = results.valueForKey("id")[0] as! Int
            let firstName = results.valueForKey("first_name")[0] as! String
            let surName = results.valueForKey("surname")[0] as! String
            let address = results.valueForKey("address")[0] as! String
            let phoneNumber = results.valueForKey("phone_number")[0] as! String
            let email = results.valueForKey("email")[0] as! String
            let createdAt = results.valueForKey("createdAt")[0] as! String
            let updatedAt = results.valueForKey("updatedAt")[0] as! String
            
            navigationController?.topViewController?.title = "\(cellObjectID)"
            lblFirstName.text = firstName
            lblSurName.text = surName
            lblAddress.text = address
            lblPhoneNumber.text = phoneNumber
            lblEmail.text = email
            lblCreatedAt.text = createdAt
            lblUpdatedAt.text = updatedAt
        }
    }


}
