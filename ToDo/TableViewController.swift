//
//  TableViewController.swift
//  ToDo
//
//  Created by Chaehyeon Lee on 02/09/2019.
//  Copyright © 2019  Chaehyeon Lee. All rights reserved.
//

import UIKit

// save the data to this var. list
var list = [MyTask]()

class TableViewController: UITableViewController {
    @IBOutlet var tvListView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAllData()
       // print(list.description)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        self.tvListView.dataSource = self
        self.tvListView.delegate = self
        self.tvListView.estimatedRowHeight = 50
        self.tvListView.rowHeight = UITableView.automaticDimension
        self.tvListView.contentInset = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0);

        
    }

    // 뷰가 전환될때 호출되는 함수
    override func viewWillAppear(_ animated: Bool) {
        saveAllData()
       // loadAllData()
        self.tvListView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return list.count
    }

    
    // userdefault 저장
    func saveAllData() {
        let data = list.map {
            [
                "taskName": $0.taskName,  // $0 : 0번부터
                "deadline": $0.deadline!,
                "content": $0.content,
                "priority": $0.priority
            ]
        }
        
       // print(type(of: data))
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "items")
        userDefaults.synchronize()
    }
    
    
    // userDefault 데이터 불러오기
    func loadAllData() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "items") as? [[String: AnyObject]] else {
            return
        }
        
       // print(data.description)
        
        // list 배열에 저장하기
       // print(type(of: data))
        list = data.map {
            var taskName = $0["taskName"] as? String
            var deadline = $0["deadline"] as? String
            var content = $0["content"] as? String
            var priority = $0["priority"] as? String
            var isComplete = $0["isComplete"] as? Bool
            
            return MyTask(taskName: taskName!, deadline: deadline!, content: content, priority: priority!, isComplete: isComplete ?? false)
        }
    }
    

//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! CustomTableViewCell
//
//        // Configure the cell...
//        cell.tfTaskName?.text = names[(indexPath as NSIndexPath).row]
//
//        // deadline 없애깅.
//        if dates[(indexPath as NSIndexPath).row] == "Deadline : None" {
//            cell.tfDeadline.isHidden = true;
//        }else {
//            cell.tfDeadline?.text = dates[(indexPath as NSIndexPath).row]
//        }
//        return cell
//    }
    
        // cell 보여지는 모습 설정
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! CustomTableViewCell
    
            // Configure the cell...
            cell.lblTaskName?.text = list[(indexPath as NSIndexPath).row].taskName
            cell.lblContent.text = list[(indexPath as NSIndexPath).row].content
            
            // deadline이 없으면 deadline 표시 안함.
            if list[(indexPath as NSIndexPath).row].deadline == "None" {
                cell.lblDeadline.text = "No deadline"
                cell.lblDeadline.textColor = UIColor.lightGray
            }else {
                cell.lblDeadline?.text = list[(indexPath as NSIndexPath).row].deadline
            }
            
            
            // priority에 따라서 ! 추가.
            let priority = list[(indexPath as NSIndexPath).row].priority
            
            if priority == "None" {
                return cell
            }
            
            var exclaCount = 0
            let fontSize = UIFont.boldSystemFont(ofSize: cell.lblTaskName.font.pointSize)
            if priority == "Low" {
                cell.lblTaskName?.text = "! " + cell.lblTaskName!.text!
                exclaCount = 1
            }else if priority == "Medium" {
                cell.lblTaskName?.text = "!! " + cell.lblTaskName!.text!
                exclaCount = 2
            }else if priority == "High" {
                cell.lblTaskName?.text = "!!! " + cell.lblTaskName!.text!
                exclaCount = 3
            }
            
            let attributedStr = NSMutableAttributedString(string: cell.lblTaskName!.text!)
            attributedStr.addAttribute(NSAttributedString.Key(rawValue: kCTFontAttributeName as String as String), value: fontSize, range: NSMakeRange(0, exclaCount))
            attributedStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSMakeRange(0, exclaCount))
            cell.lblTaskName.attributedText = attributedStr
            
            return cell
        }

    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    
    
//    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            list.remove(at : (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        saveAllData()
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let itemToMove = list[(fromIndexPath as NSIndexPath).row]
        list.remove(at : (fromIndexPath as NSIndexPath).row)
        list.insert(itemToMove, at : (to as NSIndexPath).row)
        saveAllData()
    }
    

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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "sgDetail"{
            let cell = sender as! UITableViewCell
            let indexPath = self.tvListView.indexPath(for: cell)
            let item = list[((indexPath as NSIndexPath?)?.row)!]
            
            let detailView = segue.destination as! DetailViewController
            let myTask = MyTask(taskName: item.taskName ,deadline: item.deadline, content: item.content, priority: item.priority, isComplete: item.isComplete)
            detailView.receiveItem(myTask)
        }
    }
 

}
