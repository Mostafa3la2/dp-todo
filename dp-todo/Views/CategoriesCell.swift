//
//  CategoriesCell.swift
//  dp-todo
//
//  Created by Mostafa Alaa on 10/5/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import UIKit

class CategoriesCell: UITableViewCell {


    @IBOutlet weak var categoryName: UILabel!
    
    
    
    func configureCell(categoryName:String,categoryColour:String){
        self.categoryName.text = categoryName
        
        self.backgroundColor = SystemColor(rawValue: categoryColour)?.uiColor
        
    }
    
}
