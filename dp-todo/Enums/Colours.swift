//
//  Colours.swift
//  dp-todo
//
//  Created by Mostafa Alaa on 10/5/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import Foundation
import UIKit

//this enum is created to facilitate the way of dealing with colors as Strings as core data doesn't save colors directly
enum SystemColor:String {
    
    case red = "Red"
    case orange = "Orange"
    case yellow = "Yellow"
    case green = "Green"
    case tealBlue = "TealBlue"
    case blue = "Blue"
    case purple = "Purple"
    case pink = "Pink"
    
    var uiColor: UIColor {
        switch self {
        case .red:
            return UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1)
        case .orange:
            return UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1)
        case .yellow:
            return UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1)
        case .green:
            return UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        case .tealBlue:
            return UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1)
        case .blue:
            return UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        case .purple:
            return UIColor(red: 88/255, green: 86/255, blue: 214/255, alpha: 1)
        case .pink:
            return UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1)
        }
    }
    
}
