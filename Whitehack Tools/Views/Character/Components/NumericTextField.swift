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
        print(" [MacNumericTextField] makeCoordinator - maxValue: \(maxValue)")
        return Coordinator(self)
    }
    
    func makeNSView(context: Context) -> NSTextField {
        print(" [MacNumericTextField] makeNSView - maxValue: \(maxValue)")
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
        print(" [MacNumericTextField] updateNSView - current: \(nsView.stringValue), new: \(text), maxValue: \(maxValue)")
        if nsView.stringValue != text {
            print(" [MacNumericTextField] updateNSView - updating to: \(text)")
            nsView.stringValue = text
        }
        
        // Update coordinator's parent to get latest maxValue
        context.coordinator.parent = self
    }
    
    class Coordinator: NSObject, NSTextFieldDelegate {
        var parent: MacNumericTextField
        
        init(_ textField: MacNumericTextField) {
            print(" [Coordinator] init")
            self.parent = textField
        }
        
        func controlTextDidChange(_ obj: Notification) {
            guard let textField = obj.object as? NSTextField else { return }
            let string = textField.stringValue
            
            print("🔴 [controlTextDidChange] START - value: \(string)")
            print("🔴 [controlTextDidChange] minValue: \(parent.minValue), maxValue: \(parent.maxValue)")
            
            // Allow empty string
            if string.isEmpty {
                print("🔴 [controlTextDidChange] Empty string allowed")
                parent.text = string
                return
            }
            
            // Allow single minus during typing
            if parent.allowsNegative && string == "-" {
                print("🔴 [controlTextDidChange] Single minus allowed")
                parent.text = string
                return
            }
            
            // Filter non-numeric characters
            let validCharSet = parent.allowsNegative ? 
                CharacterSet(charactersIn: "-0123456789") :
                CharacterSet.decimalDigits
                
            let filtered = String(string.unicodeScalars.filter { validCharSet.contains($0) })
            
            if filtered != string {
                print("🔴 [controlTextDidChange] Filtered invalid chars: \(string) -> \(filtered)")
                textField.stringValue = filtered
                parent.text = filtered
                return
            }
            
            // Validate numeric value and range immediately
            if let value = Int(filtered) {
                print("🔴 [controlTextDidChange] Parsed value: \(value)")
                let clamped = max(parent.minValue, min(parent.maxValue, value))
                let clampedString = String(clamped)
                if clamped != value {
                    print("🔴 [controlTextDidChange] Clamping value: \(value) -> \(clamped)")
                    textField.stringValue = clampedString
                }
                parent.text = clampedString
            } else {
                print("🔴 [controlTextDidChange] Could not parse value, using filtered: \(filtered)")
                parent.text = filtered
            }
            print("🔴 [controlTextDidChange] END - final value: \(parent.text)")
        }
        
        func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
            print(" [doCommandBy] selector: \(commandSelector)")
            return false
        }
        
        func control(_ control: NSControl, textShouldBeginEditing fieldEditor: NSText) -> Bool {
            print(" [textShouldBeginEditing] current: \(fieldEditor.string)")
            return true
        }
        
        func control(_ control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
            let string = fieldEditor.string
            print(" [textShouldEndEditing] START - value: \(string)")
            print(" [textShouldEndEditing] minValue: \(parent.minValue), maxValue: \(parent.maxValue)")
            
            // Allow empty string during editing
            if string.isEmpty {
                print(" [textShouldEndEditing] Empty string allowed")
                return true
            }
            
            // Validate characters
            let validCharSet = parent.allowsNegative ? 
                CharacterSet(charactersIn: "-0123456789") :
                CharacterSet.decimalDigits
                
            guard CharacterSet(charactersIn: string).isSubset(of: validCharSet) else {
                print(" [textShouldEndEditing] Invalid characters found")
                return false
            }
            
            // Validate range if it's a number
            if let value = Int(string) {
                print(" [textShouldEndEditing] Parsed value: \(value)")
                let isValid = value >= parent.minValue && value <= parent.maxValue
                print(" [textShouldEndEditing] Value valid? \(isValid)")
                return isValid
            }
            
            // Allow minus sign during editing
            print(" [textShouldEndEditing] Allowing minus sign? \(parent.allowsNegative && string == "-")")
            return parent.allowsNegative && string == "-"
        }
        
        func controlTextDidEndEditing(_ obj: Notification) {
            guard let textField = obj.object as? NSTextField else { return }
            print(" [controlTextDidEndEditing] START - value: \(textField.stringValue)")
            print(" [controlTextDidEndEditing] minValue: \(parent.minValue), maxValue: \(parent.maxValue)")
            
            // Handle empty field
            if textField.stringValue.isEmpty {
                let finalText = String(parent.minValue)
                print(" [controlTextDidEndEditing] Empty field, using min: \(finalText)")
                textField.stringValue = finalText
                parent.text = finalText
                return
            }
            
            // Handle minus sign
            if parent.allowsNegative && textField.stringValue == "-" {
                let finalText = String(parent.minValue)
                print(" [controlTextDidEndEditing] Single minus, using min: \(finalText)")
                textField.stringValue = finalText
                parent.text = finalText
                return
            }
            
            // Validate and clamp value
            if let value = Int(textField.stringValue) {
                let clampedValue = max(parent.minValue, min(parent.maxValue, value))
                let finalText = String(clampedValue)
                print(" [controlTextDidEndEditing] Clamping value: \(value) -> \(clampedValue)")
                textField.stringValue = finalText
                parent.text = finalText
            } else {
                let finalText = String(parent.minValue)
                print(" [controlTextDidEndEditing] Invalid value, using min: \(finalText)")
                textField.stringValue = finalText
                parent.text = finalText
            }
            print(" [controlTextDidEndEditing] END - final value: \(textField.stringValue)")
        }
    }
}
#endif
