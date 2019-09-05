//
//  DetailViewController.swift
//  ToDo
//
//  Created by Chaehyeon Lee on 02/09/2019.
//  Copyright © 2019  Chaehyeon Lee. All rights reserved.
//

import UIKit

class DetailViewController: AddViewController {
    var receivedTask: MyTask!
    var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem?.isEnabled = true
        
        // set the value to the label
        nameTextField.text = receivedTask.taskName
        contentTextView.text = receivedTask.content
       super.prioritySC.selectedSegmentIndex = receivedTask.priority
        if receivedTask.deadline == "None" {
            deadlineSwitch.isOn = false;
            datePickerView.isHidden = true;
        }else{
            deadlineSwitch.isOn = true;
            datePickerView.isHidden = false;
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm EEE"
            datePicker.setDate(formatter.date(from: receivedTask.deadline!)!, animated: true)
        }
    }
    
    func receiveItem(_ item: MyTask , _ indexx:Int){
        receivedTask = item
        index = indexx
    }
    
    @IBAction override func btnAddItem(_ sender: UIBarButtonItem) {
        var dateString = "None"
        if deadlineSwitch.isOn == true {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm EEE"
            dateString = formatter.string(from: datePicker.date)
        }
        
        let item: MyTask = MyTask(taskName: nameTextField.text!, deadline: dateString, content: contentTextView.text, priority: prioritySC.selectedSegmentIndex, isComplete: receivedTask.isComplete)
        list[index] = item
        
        self.navigationController?.popViewController(animated: true)
    }

}
