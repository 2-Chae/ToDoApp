//
//  DetailViewController.swift
//  ToDo
//
//  Created by Chaehyeon Lee on 02/09/2019.
//  Copyright © 2019  Chaehyeon Lee. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var receivedName = ""
    var receivedDate = ""
    @IBOutlet var taskName: UILabel!
    @IBOutlet var deadline: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        taskName.text = receivedName
        deadline.text = receivedDate
    }
    
    func receiveItem(_ item: MyTask ){
        receivedName = item.taskName
        receivedDate = item.deadline ?? "Deadline : None"
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
