//
//  DetailViewController.swift
//  ToDo
//
//  Created by Chaehyeon Lee on 02/09/2019.
//  Copyright © 2019  Chaehyeon Lee. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var receivedTask: MyTask!
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var contentTextView: UITextView!
    @IBOutlet var deadlineSwitch: UISwitch!
    @IBOutlet var prioritySC: UISegmentedControl!
    @IBOutlet var datePickerView: UIView!
    @IBOutlet var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // setting the textview layer
        nameTextField.layer.borderColor = UIColor(displayP3Red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0).cgColor
        nameTextField.layer.borderWidth = 1.1
        nameTextField.clipsToBounds = true
       
        contentTextView.layer.borderColor = UIColor(displayP3Red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0).cgColor
        contentTextView.layer.borderWidth = 1.1
        contentTextView.clipsToBounds = true
        
        // set the value to the label
        nameTextField.text = receivedTask.taskName
        contentTextView.text = receivedTask.content
        
        
        //prioritySC.select(receivedTask.priority)
    }
    
    func receiveItem(_ item: MyTask ){
        receivedTask = item
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
