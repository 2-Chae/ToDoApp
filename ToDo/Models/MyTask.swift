//
//  MyTask.swift
//  ToDo
//
//  Created by Chaehyeon Lee on 03/09/2019.
//  Copyright © 2019  Chaehyeon Lee. All rights reserved.
//

import Foundation

struct MyTask {
    var taskName : String = ""
    var deadline : String?
    var content : String?
    var priority : Int = 0
    var isComplete : Bool = false
    
    init(taskName: String, deadline: String?, content: String?, priority: Int, isComplete: Bool) {
        self.taskName = taskName
        self.deadline = deadline
        self.content = content
        self.priority = priority
        self.isComplete = isComplete
    }
}
