import SwiftUI
import UIKit

struct NumericTextField: UIViewRepresentable {
    @Binding var text: String
    let field: CharacterFormView.Field
    let minValue: Int
    let maxValue: Int
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
        // Only update if the external value changed
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
            if string.isEmpty { return true }
            
            // Only allow numbers
            guard CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) else {
                return false
            }
            
            // Get the new text if we allow the change
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            // Check if the new value would be valid
            if let intValue = Int(updatedText) {
                return intValue >= parent.minValue && intValue <= parent.maxValue
            }
            
            return true
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            let newValue = Int(textField.text ?? "") ?? parent.minValue
            let clampedValue = max(parent.minValue, min(parent.maxValue, newValue))
            
            // Update both the field and binding
            textField.text = String(clampedValue)
            DispatchQueue.main.async {
                self.parent.text = String(clampedValue)
            }
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
