import SwiftUI
import UIKit

struct NumericTextField: UIViewRepresentable {
    @Binding var text: String
    let field: CharacterFormView.Field
    let minValue: Int
    let maxValue: Int
    @FocusState.Binding var focusedField: CharacterFormView.Field?
    
    private var allowsNegative: Bool {
        minValue < 0
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.borderStyle = .roundedRect
        textField.keyboardType = allowsNegative ? .numbersAndPunctuation : .numberPad
        textField.textAlignment = .center
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
    
    // Add a function to commit the current value
    func commitValue(_ uiView: UITextField) {
        if let currentText = uiView.text {
            if let intValue = Int(currentText) {
                let clampedValue = max(minValue, min(maxValue, intValue))
                text = "\(clampedValue)"
            } else if currentText.isEmpty {
                text = "\(minValue)"
            }
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
            
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            // Handle negative numbers
            if parent.allowsNegative {
                // Allow minus sign only at the start
                if string == "-" {
                    return range.location == 0 && !currentText.contains("-")
                }
                
                // Validate the full string including minus sign
                let validCharSet = CharacterSet(charactersIn: "-0123456789")
                guard CharacterSet(charactersIn: updatedText).isSubset(of: validCharSet) else {
                    return false
                }
                
                // Only one minus sign at the start
                let minusCount = updatedText.filter { $0 == "-" }.count
                if minusCount > 1 || (minusCount == 1 && !updatedText.hasPrefix("-")) {
                    return false
                }
            } else {
                // Positive numbers only
                guard CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) else {
                    return false
                }
            }
            
            // Validate the numeric value
            if let intValue = Int(updatedText) {
                let isValid = intValue >= parent.minValue && intValue <= parent.maxValue
                if isValid {
                    // Update the binding immediately
                    parent.text = updatedText
                }
                return isValid
            } else if updatedText == "-" {
                // Allow single minus sign during typing
                return parent.allowsNegative
            }
            
            return false
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            var finalValue: Int
            
            if let enteredValue = Int(textField.text ?? "") {
                finalValue = max(parent.minValue, min(parent.maxValue, enteredValue))
            } else {
                // Default to minValue for empty or invalid input
                finalValue = parent.minValue
            }
            
            // Update both the field and binding
            let finalText = String(finalValue)
            textField.text = finalText
            DispatchQueue.main.async {
                self.parent.text = finalText
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
