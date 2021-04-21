//
//  DateViewController.swift
//  My Contact List
//
//  Created by Jose Cabral on 4/14/21.
//  Copyright © 2021 Learning Mobile Apps. All rights reserved.
//

import UIKit

protocol DateControllerDelegate: class {
    func dateChanged(date: Date)
}

class DateViewController: UIViewController {
    
    @IBOutlet weak var dtpDate: UIDatePicker!
    weak var delegate: DateControllerDelegate? // this will get reference to the delegate (Contacts View)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let saveButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save, target: self, action: #selector(saveDate))
        
        self.navigationItem.rightBarButtonItem = saveButton
        self.title = "Pick Birtdate"
    }
    
    @objc func saveDate() {
        self.delegate?.dateChanged(date: dtpDate.date)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
