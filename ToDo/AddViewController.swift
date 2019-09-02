//
//  AddViewController.swift
//  ToDo
//
//  Created by Chaehyeon Lee on 02/09/2019.
//  Copyright © 2019  Chaehyeon Lee. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.z
        nameTextField.layer.borderColor = UIColor(displayP3Red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0).cgColor
        nameTextField.layer.borderWidth = 1.1
        nameTextField.clipsToBounds = true
        
        contentTextView.layer.borderColor = UIColor(displayP3Red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0).cgColor
        contentTextView.layer.borderWidth = 1.1
        contentTextView.clipsToBounds = true
        
        
    }
    
    @IBAction func btnAddItem(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCancelItem(_ sender: UIBarButtonItem) {
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
