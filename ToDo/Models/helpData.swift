//
//  helpData.swift
//  ToDo
//
//  Created by Chaehyeon Lee on 04/09/2019.
//  Copyright © 2019  Chaehyeon Lee. All rights reserved.
//

import Foundation

let helpAdd = MyTask(taskName: "Press + button to add new task", deadline: "None", content: "", priority: 0, isComplete: false)
let helpDelete = MyTask(taskName: "Swipe from right to left to delete", deadline: "None", content: "", priority: 0, isComplete: false)
let helpCheck = MyTask(taskName: "Swipe from left to right to Done/Undo", deadline: "None", content: "Or you can just click the checkbox", priority: 0, isComplete: false)
let helpDetail = MyTask(taskName: "Click the list to view the details", deadline: "None", content: "", priority: 0, isComplete: false)
let helpEdit = MyTask(taskName: "Press Edit button to rearrange the list", deadline: "None", content: "", priority: 0, isComplete: false)


var helpList = [helpAdd, helpDetail, helpCheck, helpDelete, helpEdit]
