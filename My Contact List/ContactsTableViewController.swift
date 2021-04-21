//
//  ContactsTableViewController.swift
//  My Contact List
//
//  Created by Jose Cabral on 4/19/21.
//  Copyright © 2021 Learning Mobile Apps. All rights reserved.
//
import UIKit
import CoreData

class ContactsTableViewController: UITableViewController {
    
    //let contacts = ["Jim", "John", "Dana", "Rosie", "Justin", "Jeremy", "Sarah", "Matt", "Joe", "Donald", "Jeff"]
    var contacts:[NSManagedObject] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        super.viewDidLoad()
        //loadDataFromDatabase()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadDataFromDatabase()
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 //this returns the number of sections or columns
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return contacts.count //this returns the number of rows
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsCell", for: indexPath) // this is the actual cell being used

        // configuring cell
        let contact = contacts[indexPath.row] as? Contact // we are configuring the cell to contain the contact name
        cell.textLabel?.text = contact?.contactName
        cell.detailTextLabel?.text = contact?.city
        cell.accessoryType = UITableViewCell.AccessoryType.detailDisclosureButton //this adds the button to each cell so that it can selected
        
        

        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadDataFromDatabase() {
        let settings = UserDefaults.standard
        let sortField = settings.string(forKey: Constants.kSortField)
        let sortAscending = settings.bool(forKey: Constants.kSortDirectionAscending)
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "Contact")
        let sortDescriptor = NSSortDescriptor(key: sortField, ascending: sortAscending)
        let sortDescriptorArray = [sortDescriptor]
        request.sortDescriptors = sortDescriptorArray
        do {
            contacts = try context.fetch(request)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedContact = contacts[indexPath.row] as? Contact
        let name = selectedContact!.contactName!
        let actionHandler = {(action: UIAlertAction) -> Void in
            self.performSegue(withIdentifier: "EditContact", sender: tableView.cellForRow(at: indexPath))
        }
        
        let alertController = UIAlertController(title: "Contact selected",
                                                message: "Selected row: \(indexPath.row) \(name)",
                                                preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let actionDetails = UIAlertAction(title: "Show Details", style: .default, handler: actionHandler)
        alertController.addAction(actionCancel)
        alertController.addAction(actionDetails)
        present(alertController, animated: true, completion: nil)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // thend delte the row from data source
            let contact = contacts[indexPath.row] as? Contact
            let context = appDelegate.persistentContainer.viewContext
            context.delete(contact!)
            do {
                try context.save()
            }
            catch {
                fatalError("Error saving context: \(error)")
            }
            loadDataFromDatabase()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditContact" {
            let contactController = segue.destination as? ContactsViewController
            let selectedRow = self.tableView.indexPath(for: sender as! UITableViewCell)?.row
            let selectedContact = contacts[selectedRow!] as? Contact
            contactController?.currentContact = selectedContact! //this is the part that sets the selectedContact as currentContact so when it's passed through contactsViewController
        }
    }
    

}
