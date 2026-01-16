//
//  PolicyTextField.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 20/12/25.
//

import Foundation
import SwiftUI

struct PolicyTextField: UIViewRepresentable {
    
    
    
    @Binding var text: String
        let placeholder: String
    
    
    func makeUIView(context :Context) -> PolicyUITextField {
        
        
        
        let tf = PolicyUITextField()
        
        tf.placeholder = placeholder
        tf.autocapitalizationType = .allCharacters
        
        tf.onTextChange = { value in
            
            self.text = value
            
        }
        return tf
        
    }
    
    func updateUIView(_ uiView: PolicyUITextField, context: Context) {
        
        if uiView.text != text {
         
            uiView.text = text
        }
    }
    
    
}


final class PolicyUITextField: UITextField {

    var onTextChange: ((String) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        delegate = self
        autocapitalizationType = .allCharacters
    }
}


extension PolicyUITextField: UITextFieldDelegate {

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {

        guard let current = text,
              let range = Range(range, in: current)
        else { return false }

        let updated = current.replacingCharacters(in: range, with: string)
        let sanitized = PolicyValidator.sanitize(updated)

        text = sanitized
        onTextChange?(sanitized)

        // 🔥 Dynamic keyboard switching
        keyboardType = sanitized.count < 3
            ? .asciiCapable
            : .numberPad

        reloadInputViews()

        return false // we manually update text
    }
}



struct PolicyValidator {

    static func sanitize(_ input: String) -> String {
        let upper = input.uppercased()

        let letters = upper.prefix(3).filter { $0.isLetter }
        let digits = upper.dropFirst(3).filter { $0.isNumber }

        return String(letters + digits.prefix(4))
    }

    static func isValid(_ value: String) -> Bool {
        let regex = #"^[A-Z]{3}[0-9]{4}$"#
        return value.range(of: regex, options: .regularExpression) != nil
    }
}
