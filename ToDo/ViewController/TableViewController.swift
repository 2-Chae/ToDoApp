//
//  TableViewController.swift
//  ToDo
//
//  Created by Chaehyeon Lee on 02/09/2019.
//  Copyright © 2019  Chaehyeon Lee. All rights reserved.
//

import UIKit

// save the data to this var. list
var list = helpList

class TableViewController: UITableViewController {
    @IBOutlet var tvListView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAllData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        self.tvListView.dataSource = self
        self.tvListView.delegate = self
        self.tvListView.estimatedRowHeight = 50
        self.tvListView.rowHeight = UITableView.automaticDimension
    }

    // 뷰가 전환될때 호출되는 함수
    override func viewWillAppear(_ animated: Bool) {
        saveAllData()
        self.tvListView.reloadData()
    }
    
    // 마감기한을 지났는지 체크.
    func isMissedtheDeadline(deadlineStr: String, today: NSDate) -> Bool {
        var isMissed = false
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm EEE"
        
        let deadline = formatter.date(from: deadlineStr)
        if today.compare(deadline!) == ComparisonResult.orderedDescending {
            isMissed = true
        }
        
        return isMissed
    }
    

    func getLevelofLaziness() -> Int {
        // get current Time
        let today = NSDate()
    
        var lazinessCount = 0;
        var index = 0
        
        while index < list.count {
            if list[index].isComplete == false && list[index].deadline != "None" {
                if isMissedtheDeadline(deadlineStr: list[index].deadline!, today: today) == true {
                    lazinessCount += 1
                }
            }
            index += 1
        }
        
        return lazinessCount
    }
    
    // 제일 처음 실행할때 한번.
    // 마감기한 지난 일에 대해 알림! 지난 일이 없으면 알림 X
    override func loadView() {
        super.loadView()
        loadAllData()
        
        let num = getLevelofLaziness()
        if num != 0 {
            let alert = UIAlertController(title: "Warning", message: "You have " + String(num) + " tasks that you missed the deadline.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
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
                "priority": $0.priority,
                "isComplete": $0.isComplete
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
            var priority = $0["priority"] as? Int
            var isComplete = $0["isComplete"] as? Bool
            
            return MyTask(taskName: taskName!, deadline: deadline!, content: content, priority: priority!, isComplete: isComplete ?? false)
        }
    }
    
        // cell 보여지는 모습 설정
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! CustomTableViewCell
    
            // color
            cell.lblTaskName.textColor = UIColor.black
            cell.lblDeadline.textColor = UIColor.black
            cell.lblContent.textColor = UIColor.black
            
            
            // Configure the cell...
            cell.lblTaskName?.text = list[(indexPath as NSIndexPath).row].taskName
            cell.lblContent.text = list[(indexPath as NSIndexPath).row].content
            
            // deadline이 없으면 deadline 표시 안함.
            if list[(indexPath as NSIndexPath).row].deadline == "None" {
                cell.lblDeadline.text = "No deadline"
                cell.lblDeadline.textColor = UIColor.lightGray
            }else {
                let today = NSDate()
                cell.lblDeadline?.text = list[(indexPath as NSIndexPath).row].deadline
                // deadline 넘겼으면 빨간색으로 deadline 표시.
                if isMissedtheDeadline(deadlineStr: list[(indexPath as NSIndexPath).row].deadline!, today: today) == true {
                    cell.lblDeadline?.textColor = UIColor.red
                }
            }
            
            
            // checkbox image 설정 (click event)
            let image = list[(indexPath as NSIndexPath).row].isComplete ? UIImage(named:"ic_check.png") : UIImage(named:"ic_uncheck.png")
            cell.completeCheckBtn.setImage(image, for: UIControl.State.normal)
            cell.completeCheckBtn.tag = (indexPath as NSIndexPath).row
            cell.completeCheckBtn.addTarget(self, action: #selector(self.clickCompleteBtn(_:)), for: .touchUpInside)
            
            
            // priority에 따라서 ! 추가.
            let priority = list[(indexPath as NSIndexPath).row].priority
            let fontSize = UIFont.boldSystemFont(ofSize: cell.lblTaskName.font.pointSize)
            
            var tempIndex = 0;
            var excla = ""
            while tempIndex < priority {
                excla += "!"
                tempIndex += 1
            }
            if priority != 0 {
                excla += " "
            }
            cell.lblTaskName?.text = excla + cell.lblTaskName!.text!
            
            // ! 빨간색으로 표시
            let attributedStr = NSMutableAttributedString(string: cell.lblTaskName!.text!)
            attributedStr.addAttribute(NSAttributedString.Key(rawValue: kCTFontAttributeName as String as String), value: fontSize, range: NSMakeRange(0, priority))
            attributedStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSMakeRange(0, priority))
            cell.lblTaskName.attributedText = attributedStr
            
            
            // complete 항목에 대해서 줄 긋고 회색으로 변경
            if list[(indexPath as NSIndexPath).row].isComplete == true {
                // 완료되었으면 줄 긋기(strike)
                attributedStr.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedStr.length))
                cell.lblTaskName.attributedText = attributedStr
                
                cell.lblTaskName.textColor = UIColor.lightGray
                cell.lblDeadline.textColor = UIColor.lightGray
                cell.lblContent.textColor = UIColor.lightGray
            }
            
            return cell
        }

    
    // 체크박스 클릭하면 isComplete 를 반전 시킴.
    @objc func clickCompleteBtn(_ sender: UIButton) {
        list[sender.tag].isComplete = !list[sender.tag].isComplete
        saveAllData()
        self.tvListView.reloadData()
    }
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
//    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            list.remove(at : (indexPath as NSIndexPath).row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//        saveAllData()
//    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title:  "Delete") { (action, view, completion) in
            list.remove(at :(indexPath as NSIndexPath).row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
            self.saveAllData()
        }
        deleteAction.backgroundColor = UIColor(red: 225/255, green: 43/255, blue: 83/255, alpha: 1)
        return UISwipeActionsConfiguration(actions:[deleteAction])
    }


    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let doneAction = UIContextualAction(style: .normal, title:  "Done") { (action, view, completion) in
            list[(indexPath as NSIndexPath).row].isComplete = !list[(indexPath as NSIndexPath).row].isComplete
            completion(true)
            self.saveAllData()
            self.tvListView.reloadData()
        }
        
        // compelte에 대해서는 undo button을 보여줌.
        if list[(indexPath as NSIndexPath).row].isComplete == true {
            doneAction.backgroundColor = UIColor.gray
            doneAction.title = "Undo"
        } else {
            doneAction.backgroundColor = UIColor(red: 83/255, green: 204/255, blue: 122/255, alpha: 1)
        }
        return UISwipeActionsConfiguration(actions:[doneAction])
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
            detailView.receiveItem(myTask, indexPath!)
        }
    }
 

}
