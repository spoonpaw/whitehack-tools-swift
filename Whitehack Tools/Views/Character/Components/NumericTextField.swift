import SwiftUI
import UIKit

struct NumericTextField: UIViewRepresentable {
    @Binding var text: String
    let field: CharacterFormView.Field
    @FocusState.Binding var focusedField: CharacterFormView.Field?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.text = text
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
        if focusedField == field {
            uiView.becomeFirstResponder()
        } else {
            uiView.resignFirstResponder()
        }
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: NumericTextField
        
        init(_ textField: NumericTextField) {
            self.parent = textField
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // Allow backspace
            if string.isEmpty {
                let currentText = textField.text ?? ""
                guard let stringRange = Range(range, in: currentText) else { return false }
                let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
                parent.text = updatedText
                return true
            }
            
            // Check if input is numeric
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            guard allowedCharacters.isSuperset(of: characterSet) else {
                return false
            }
            
            // Build the new string
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            // Only allow 2 digits
            guard updatedText.count <= 2 else {
                return false
            }
            
            parent.text = updatedText
            return true
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            // Convert empty to "0"
            if parent.text.isEmpty {
                parent.text = "0"
            }
            
            parent.focusedField = nil
        }
    }
}

#if os(macOS)
extension NumericTextField {
    func makeNSView(context: Context) -> NSTextField {
        let textField = NSTextField()
        textField.delegate = context.coordinator
        textField.isBordered = true
        textField.isEditable = true
        textField.stringValue = text
        return textField
    }
    
    func updateNSView(_ nsView: NSTextField, context: Context) {
        if nsView.stringValue != text {
            nsView.stringValue = text
        }
        if focusedField == field {
            nsView.window?.makeFirstResponder(nsView)
        }
    }
}
#endif
