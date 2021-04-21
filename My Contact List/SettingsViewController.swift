import UIKit

class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var pckSortField: UIPickerView!
    @IBOutlet weak var swAscending: UISwitch!
    
    let sortOrderItems: Array<String> = ["contactName", "city", "birthday"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad() // this sets this controller as the datasource
        
        //Day any additional setup after loading the view.
        pckSortField.dataSource = self; // this designates a datasource
        pckSortField.delegate = self; // this returns the position of the list of where the item is at

    }
    
    @IBAction func sortDirectionChanged(_ sender: Any) {
        let settings = UserDefaults.standard
        settings.set(swAscending.isOn, forKey: "sortDirectionAscending")
        settings.synchronize()
    }
    
    // MARK: UIPickerViewDelegate Methods
    
    // Returns the number of 'columns' to display
    func numberOfComponents(in pickerView: UIPickerView) -> Int { //this returns the number of columns to display
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { //this returns how many rows to display
        return sortOrderItems.count // we just return the length of the array above
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { // this method actually takes the data from the data source and displays it
        return sortOrderItems[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let sortField = sortOrderItems[row]
        let settings = UserDefaults.standard
        settings.set(sortField, forKey: "sortField")
        settings.synchronize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //set the UI based on values in UserDefuals
        let settings = UserDefaults.standard
        swAscending.setOn(settings.bool(forKey: "sortDirectionAscending"), animated: true) // if swAscending is on, set settings boolean to true
        let sortField = settings.string(forKey: "sortField")
        var i = 0
        for field in sortOrderItems {
            if field == sortField {
                pckSortField.selectRow(i, inComponent: 0, animated: false)
            }
            i += 1
        }
        pckSortField.reloadComponent(0)
    }
}
