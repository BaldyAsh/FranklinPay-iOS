//
//  AddContactController+TextFieldDelegate.swift
//  Franklin
//
//  Created by Anton on 20/02/2019.
//  Copyright © 2019 Matter Inc. All rights reserved.
//

import UIKit

extension AddContactController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text ?? "") as NSString
        let futureString = currentText.replacingCharacters(in: range, with: string) as String
        
        isEnterButtonEnabled(afterChanging: textField, with: futureString)
        
        updateEnterButtonAlpha()
        
        textField.returnKeyType = enterButton.isEnabled ? UIReturnKeyType.done : .next
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == TextFieldsTags.name.rawValue && !enterButton.isEnabled {
            addressTextField.becomeFirstResponder()
            return false
        } else if textField.tag == TextFieldsTags.address.rawValue && !enterButton.isEnabled {
            nameTextField.becomeFirstResponder()
            return false
        } else if enterButton.isEnabled {
            textField.resignFirstResponder()
            return true
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.showLabels(false)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.showLabels(true)
    }
}
