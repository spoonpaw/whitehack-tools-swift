import SwiftUI

struct AttributeEditor: View {
    let label: String
    @Binding var value: String
    let range: ClosedRange<Int>
    @FocusState private var focusedField: CharacterFormView.Field?
    let field: CharacterFormView.Field
    
    var body: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.title3)
                    .fontWeight(.medium)
                TextField("", text: $value)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 60)
                    #if os(iOS)
                    .keyboardType(.numberPad)
                    #endif
                    .focused($focusedField, equals: field)
                    .onChange(of: focusedField) { newValue in
                        if newValue != field {  // Field lost focus
                            validateAndFixEmptyInput()
                        }
                    }
                    .onChange(of: value) { newValue in
                        // Only filter non-numeric while typing
                        let filtered = newValue.filter { $0.isNumber }
                        if filtered != newValue {
                            value = filtered
                        }
                    }
                    .font(.title2)
                    #if os(iOS)
                    .font(Font.system(.title2).weight(.bold))
                    #else
                    .fontWeight(.bold)
                    #endif
            }
            
            Spacer()
            
            HStack(spacing: 20) {
                // Minus Button
                Button {
                    decrementValue()
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.red)
                        .font(.title)
                }
                .buttonStyle(.borderless)
                
                // Plus Button
                Button {
                    incrementValue()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.green)
                        .font(.title)
                }
                .buttonStyle(.borderless)
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
        .onAppear {
            validateAndFixEmptyInput()
        }
    }
    
    private func validateAndFixEmptyInput() {
        if value.isEmpty || Int(value) == nil {
            value = String(range.lowerBound)
        } else if let current = Int(value) {
            let clamped = max(range.lowerBound, min(range.upperBound, current))
            value = String(clamped)
        }
    }
    
    private func decrementValue() {
        if let current = Int(value), current > range.lowerBound {
            value = String(current - 1)
        } else {
            value = String(range.lowerBound)
        }
    }
    
    private func incrementValue() {
        if let current = Int(value), current < range.upperBound {
            value = String(current + 1)
        } else {
            value = String(range.upperBound)
        }
    }
}
