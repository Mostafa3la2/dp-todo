//
//  TasksCell.swift
//  dp-todo
//
//  Created by Mostafa Alaa on 10/4/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import UIKit

class TasksCell: UITableViewCell {

 
    @IBOutlet weak var taskTitleLbl: UILabel!
    
    @IBOutlet weak var taskCategoryLbl: UILabel!
    
    @IBOutlet weak var completionDateLbl: UILabel!
    
    @IBOutlet weak var categoryColourView: UIView!
    
    @IBOutlet weak var doneView: UIView!
    func configCell(title:String,date:String?,categoryTitle:String,categoryColour:String,completed:Bool){
        self.taskTitleLbl.text = title
        if date != nil{
            print(date!)
            self.completionDateLbl.text = date!}
        else{
            self.completionDateLbl.text = ""
        }
        self.taskCategoryLbl.text = categoryTitle
        //notice here the usage of the enum to ease the use of strings to assign system colours
        self.categoryColourView.backgroundColor = SystemColor(rawValue: categoryColour)?.uiColor
        doneView.isHidden = !completed
    }
   
    
}
