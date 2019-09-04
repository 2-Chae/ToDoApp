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
    var indexPath: IndexPath!
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var contentTextView: UITextView!
    @IBOutlet var deadlineSwitch: UISwitch!
    @IBOutlet var prioritySC: UISegmentedControl!
    @IBOutlet var datePickerView: UIView!
    @IBOutlet var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // hide the keyboard when touch the screen
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
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
        prioritySC.selectedSegmentIndex = receivedTask.priority
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
        
        //prioritySC.select(receivedTask.priority)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func receiveItem(_ item: MyTask , _ index:IndexPath){
        receivedTask = item
        indexPath = index
    }
    
    // Deadline 존재하는지 여부에 따라 datePicker 활성화 처리.
    @IBAction func existDeadline(_ sender: UISwitch) {
        if sender.isOn {
            datePickerView.isHidden = false;
            
        }else{
            datePickerView.isHidden = true;
        }
    }
    
    // Task Name 입력하지 않으면 Done 비활성화
    @IBAction func editChanged(_ sender: UITextField) {
        if sender.text?.isEmpty == true {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }else{
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    @IBAction func btnAddItem(_ sender: UIBarButtonItem) {
        
        var dateString = "None"
        if deadlineSwitch.isOn == true {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm EEE"
            dateString = formatter.string(from: datePicker.date)
        }
        
        let item: MyTask = MyTask(taskName: nameTextField.text!, deadline: dateString, content: contentTextView.text, priority: prioritySC.selectedSegmentIndex, isComplete: false)
        list[((indexPath as NSIndexPath?)?.row)!] = item
        
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
