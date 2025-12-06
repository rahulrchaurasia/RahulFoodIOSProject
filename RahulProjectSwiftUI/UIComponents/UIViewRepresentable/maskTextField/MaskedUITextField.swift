//
//  InputMaskTextField.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 24/11/25.
//

import SwiftUI
import UIKit




struct MaskedUITextField: UIViewRepresentable {
    @Binding var text: String

    let placeholder: String
    let maskPattern: String
    let keyboardType: UIKeyboardType
    let isSecure: Bool
    let textColor: UIColor
    let font: UIFont
    
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        let maskPattern: String

        init(text: Binding<String>, maskPattern: String) {
            _text = text
            self.maskPattern = maskPattern
        }

        func textField(_ textField: UITextField,
                       shouldChangeCharactersIn range: NSRange,
                       replacementString string: String) -> Bool {

            // If backspace → allow
            if string.isEmpty { return true }

            let current = textField.text ?? ""
            let newText = (current as NSString).replacingCharacters(in: range, with: string)

            let masked = applyMask(to: newText, mask: maskPattern)

            text = masked
            textField.text = masked

            return false // we handled the update
        }

        // MARK: Mask formatter
        func applyMask(to text: String, mask: String) -> String {
            let digits = text.filter { $0.isNumber }
            var result = ""
            var index = digits.startIndex

            for ch in mask {
                if index == digits.endIndex { break }

                if ch == "#" {
                    result.append(digits[index])
                    index = digits.index(after: index)
                } else {
                    result.append(ch)
                }
            }
            return result
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, maskPattern: maskPattern)
    }

    func makeUIView(context: Context) -> UITextField {
        let tf = UITextField()
        tf.delegate = context.coordinator
        tf.keyboardType = keyboardType
        tf.textColor = textColor
        tf.font = font
        tf.placeholder = placeholder
        tf.isSecureTextEntry = isSecure
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.returnKeyType = .done
        return tf
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
}


struct MaskedUITextDemo: View {
    
    @State var dob : String = ""
    var body: some View {
        
        VStack{
            
            Text ("Input Mask Text Demo")
                .font(.title)
            
            MaskedUITextField(text: $dob,
                              placeholder: "DD/MM/YYYY", maskPattern: "##/##/####", keyboardType: .numberPad, isSecure: false, textColor: .appBlackcolor, font: .systemFont(ofSize: 17))
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(30, corner: .allCorners)
            .frame(width: .infinity,height: 50)
            .padding(.horizontal,10)
            
            
        }
    }
    
}

#Preview {
                
    MaskedUITextDemo()
}
