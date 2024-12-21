import SwiftUI
#if os(macOS)
import AppKit
#endif

struct NumericTextField: View {
    @Binding var text: String
    let field: CharacterFormView.Field
    let minValue: Int
    let maxValue: Int
    @FocusState.Binding var focusedField: CharacterFormView.Field?
    
    private var allowsNegative: Bool {
        minValue < 0
    }
    
    var body: some View {
        #if os(iOS)
        TextField("", text: $text)
            .textFieldStyle(.roundedBorder)
            .multilineTextAlignment(.center)
            .focused($focusedField, equals: field)
            .keyboardType(allowsNegative ? .numbersAndPunctuation : .numberPad)
            .onChange(of: text) { newValue in
                handleTextChange(newValue)
            }
        #else
        MacNumericTextField(
            text: $text,
            allowsNegative: allowsNegative,
            minValue: minValue,
            maxValue: maxValue
        )
        .frame(height: 22)
        .focused($focusedField, equals: field)
        #endif
    }
    
    private func handleTextChange(_ newValue: String) {
        // Allow empty field during editing
        if newValue.isEmpty {
            return
        }
        
        // Handle negative numbers
        if allowsNegative && newValue == "-" {
            return
        }
        
        // Filter non-numeric characters
        let validCharSet = allowsNegative ? 
            CharacterSet(charactersIn: "-0123456789") :
            CharacterSet.decimalDigits
            
        let filtered = String(newValue.unicodeScalars.filter { validCharSet.contains($0) })
        
        if filtered != newValue {
            text = filtered
            return
        }
        
        // Validate numeric value
        if let value = Int(filtered) {
            if value >= minValue && value <= maxValue {
                text = filtered
            } else {
                text = String(max(minValue, min(maxValue, value)))
            }
        }
    }
}

#if os(macOS)
struct MacNumericTextField: NSViewRepresentable {
    @Binding var text: String
    let allowsNegative: Bool
    let minValue: Int
    let maxValue: Int
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeNSView(context: Context) -> NSTextField {
        let textField = NSTextField()
        textField.delegate = context.coordinator
        textField.isBordered = true
        textField.isEditable = true
        textField.alignment = .center
        textField.stringValue = text
        textField.focusRingType = .none
        return textField
    }
    
    func updateNSView(_ nsView: NSTextField, context: Context) {
        if nsView.stringValue != text {
            nsView.stringValue = text
        }
    }
    
    class Coordinator: NSObject, NSTextFieldDelegate {
        var parent: MacNumericTextField
        
        init(_ textField: MacNumericTextField) {
            self.parent = textField
        }
        
        func controlTextDidChange(_ obj: Notification) {
            guard let textField = obj.object as? NSTextField else { return }
            let string = textField.stringValue
            
            // Allow empty string
            if string.isEmpty {
                parent.text = string
                return
            }
            
            // Allow single minus during typing
            if parent.allowsNegative && string == "-" {
                parent.text = string
                return
            }
            
            // Filter non-numeric characters
            let validCharSet = parent.allowsNegative ? 
                CharacterSet(charactersIn: "-0123456789") :
                CharacterSet.decimalDigits
                
            let filtered = String(string.unicodeScalars.filter { validCharSet.contains($0) })
            
            if filtered != string {
                textField.stringValue = filtered
                parent.text = filtered
                return
            }
            
            // Validate numeric value
            if let value = Int(filtered) {
                if value >= parent.minValue && value <= parent.maxValue {
                    parent.text = filtered
                } else {
                    let clamped = String(max(parent.minValue, min(parent.maxValue, value)))
                    textField.stringValue = clamped
                    parent.text = clamped
                }
            } else {
                parent.text = filtered
            }
        }
        
        func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
            return false
        }
        
        func control(_ control: NSControl, textShouldBeginEditing fieldEditor: NSText) -> Bool {
            return true
        }
        
        func control(_ control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
            let string = fieldEditor.string
            
            // Allow empty string during editing
            if string.isEmpty {
                return true
            }
            
            // Validate characters
            let validCharSet = parent.allowsNegative ? 
                CharacterSet(charactersIn: "-0123456789") :
                CharacterSet.decimalDigits
                
            guard CharacterSet(charactersIn: string).isSubset(of: validCharSet) else {
                return false
            }
            
            // Validate range if it's a number
            if let value = Int(string) {
                return value >= parent.minValue && value <= parent.maxValue
            }
            
            // Allow minus sign during editing
            return parent.allowsNegative && string == "-"
        }
        
        func controlTextDidEndEditing(_ obj: Notification) {
            guard let textField = obj.object as? NSTextField else { return }
            
            // Handle empty field
            if textField.stringValue.isEmpty {
                let finalText = String(parent.minValue)
                textField.stringValue = finalText
                parent.text = finalText
                return
            }
            
            // Handle minus sign
            if parent.allowsNegative && textField.stringValue == "-" {
                let finalText = String(parent.minValue)
                textField.stringValue = finalText
                parent.text = finalText
                return
            }
            
            // Validate and clamp value
            if let value = Int(textField.stringValue) {
                let clampedValue = max(parent.minValue, min(parent.maxValue, value))
                let finalText = String(clampedValue)
                textField.stringValue = finalText
                parent.text = finalText
            } else {
                let finalText = String(parent.minValue)
                textField.stringValue = finalText
                parent.text = finalText
            }
        }
    }
}
#endif
