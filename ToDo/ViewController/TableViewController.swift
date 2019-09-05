//
//  TableViewController_.swift
//  ToDo
//
//  Created by Chaehyeon Lee on 05/09/2019.
//  Copyright © 2019  Chaehyeon Lee. All rights reserved.
//

import UIKit



class TableViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tvListView: UITableView!
    @IBOutlet var rmButtonView: UIView!
    @IBOutlet var rmCompletedBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadAllData()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        self.tvListView.dataSource = self
        self.tvListView.delegate = self
        self.tvListView.estimatedRowHeight = 50
        self.tvListView.rowHeight = UITableView.automaticDimension
        
        // setting for the rmCompletedBtn
        rmCompletedBtn.layer.cornerRadius = 7
        rmCompletedBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        rmCompletedBtn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        rmCompletedBtn.layer.shadowOpacity = 1.0
    }
    
    
    // 뷰가 전환될때 호출되는 함수
    override func viewWillAppear(_ animated: Bool) {
        saveAllData()
        self.tvListView.reloadData()
    }
    
    
    // 제일 처음 실행할때 한번.
    // 마감기한 지난 일에 대해 알림! 지난 일이 없으면 알림 X
    override func loadView() {
        super.loadView()
        loadAllData()
        
        let num = getLevelofLaziness()
        if num != 0 {
            let alert = UIAlertController(title: "Don't be late!", message: "You have " + String(num) + " tasks that you missed the deadline.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    // enable edit mode with navigation left bar button
    override func setEditing(_ editing: Bool, animated: Bool) {
        let status = navigationItem.leftBarButtonItem?.title
        if status == "Edit" {
            self.tvListView.isEditing = true
            navigationItem.leftBarButtonItem?.title = "Done"
        } else {
            self.tvListView.isEditing = false
            navigationItem.leftBarButtonItem?.title = "Edit"
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    
    /*
        tableView functions
     */
    // cell 보여지는 모습 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! CustomTableViewCell
        
        // color
        cell.lblTaskName.textColor = UIColor.black
        cell.lblDeadline.textColor = UIColor.darkGray
        cell.lblContent.textColor = UIColor.darkGray
        
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
        
        // detailsButton click event 를 위해 tag로 index를 줌.
        cell.detailsButton.tag = (indexPath as NSIndexPath).row
        
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
    
    
    // Cell click event --> isComplete 반전시킴.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        list[(indexPath as NSIndexPath).row].isComplete  = !list[(indexPath as NSIndexPath).row].isComplete
        saveAllData()
        self.tvListView.reloadData()
    }
    
    
    // Swipe right -> left : Delete Action 정의
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title:  "Delete") { (action, view, completion) in
            list.remove(at :(indexPath as NSIndexPath).row)
            self.tvListView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
            saveAllData()
        }
        deleteAction.backgroundColor = UIColor(red: 252/255, green: 54/255, blue: 53/255, alpha: 1)
        return UISwipeActionsConfiguration(actions:[deleteAction])
    }
    
    
    // Swipe left -> right : Done/Undo Action 정의
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doneAction = UIContextualAction(style: .normal, title:  "Done") { (action, view, completion) in
            list[(indexPath as NSIndexPath).row].isComplete = !list[(indexPath as NSIndexPath).row].isComplete
            completion(true)
            saveAllData()
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
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let itemToMove = list[(fromIndexPath as NSIndexPath).row]
        list.remove(at : (fromIndexPath as NSIndexPath).row)
        list.insert(itemToMove, at : (to as NSIndexPath).row)
        saveAllData()
    }
    

    // rmCompletedBtn Action 정의
    @IBAction func removeAllCompleted(_ sender: UIButton) {
        var index = 0
        while index < list.count {
            if list[index].isComplete == true {
                list.remove(at :index)
                index -= 1
            }
            index += 1
        }
        saveAllData()
        self.tvListView.reloadData()
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    // 세그로 다음페이지에 데이터 전달!
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "sgDetail"{
            let btn = sender as! UIButton
            let item = list[btn.tag]
            
            let detailView = segue.destination as! DetailViewController
            let myTask = MyTask(taskName: item.taskName ,deadline: item.deadline, content: item.content, priority: item.priority, isComplete: item.isComplete)
            detailView.receiveItem(myTask, btn.tag)
        }
    }
    
    
}
