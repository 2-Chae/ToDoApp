//
//  Data.swift
//  ToDo
//
//  Created by Chaehyeon Lee on 05/09/2019.
//  Copyright © 2019  Chaehyeon Lee. All rights reserved.
//

import Foundation

// save the data to this var. list
var list = [helpAdd, helpDetail, helpCheck, helpDelete, helpEdit]

// userdefault 저장
func saveAllData() {
    let data = list.map {
        [
            "taskName": $0.taskName,  // $0 : 0번부터
            "deadline": $0.deadline!,
            "content": $0.content ?? "",
            "priority": $0.priority,
            "isComplete": $0.isComplete
        ]
    }
    
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
    
    // save the data into the list
    list = data.map {
        let taskName = $0["taskName"] as? String
        let deadline = $0["deadline"] as? String
        let content = $0["content"] as? String
        let priority = $0["priority"] as? Int
        let isComplete = $0["isComplete"] as? Bool
        
        return MyTask(taskName: taskName!, deadline: deadline!, content: content, priority: priority!, isComplete: isComplete ?? false)
    }
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

// deadline 지난 task 개수 반환.
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


// Manual data
let helpAdd = MyTask(taskName: "Press + button to add new task", deadline: "None", content: "", priority: 0, isComplete: false)
let helpDelete = MyTask(taskName: "Swipe 👈 to delete", deadline: "None", content: "", priority: 0, isComplete: false)
let helpCheck = MyTask(taskName: "Swipe 👉 to Done/Undo", deadline: "None", content: "Or you can click the list or the checkbox", priority: 0, isComplete: false)
let helpDetail = MyTask(taskName: "Click ℹ️ to view/edit the details", deadline: "2019-09-04 12:00 Wed", content: "", priority: 0, isComplete: false)
let helpEdit = MyTask(taskName: "Press \"Edit\" button to rearrange", deadline: "None", content: "", priority: 0, isComplete: false)

