//
//  Utilities.swift
//  EthnicityApp
//
//  Created by Aaron Kao on 2022-03-10.
//

import Foundation
import UIKit

class FormStyles {
    static func styleFilledButton(_ button:UIButton) {
        
        // Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 72/255, green: 202/255, blue: 228/255, alpha: 1)
        button.layer.cornerRadius = 5
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton(_ button:UIButton) {
        
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
    }
}
