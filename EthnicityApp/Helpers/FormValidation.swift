//
//  FormStyles.swift
//  EthnicityApp
//
//  Created by Aaron Kao on 2022-03-10.
//

import Foundation
import UIKit

class FormValidation {
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
}
