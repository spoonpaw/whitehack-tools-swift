import SwiftUI

struct AttributeEditor: View {
    let label: String
    @Binding var value: String
    let range: ClosedRange<Int>
    let maxDigits: Int
    @FocusState private var focusedField: CharacterFormView.Field?
    let field: CharacterFormView.Field
    
    var body: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.title3)
                    .fontWeight(.medium)
                NumericTextField(text: $value, field: field, minValue: 1, maxValue: 20, focusedField: $focusedField)
                    .frame(width: 60)
                    .focused($focusedField, equals: field)
                    .onChange(of: focusedField) { newValue in
                        if newValue != field {  // Field lost focus
                            validateAndFixEmptyInput()
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
            value = String(1)
        } else if let current = Int(value) {
            let clamped = max(1, min(20, current))
            value = String(clamped)
        }
    }
    
    private func decrementValue() {
        if let current = Int(value), current > 1 {
            value = String(current - 1)
        } else {
            value = String(1)
        }
    }
    
    private func incrementValue() {
        if let current = Int(value), current < 20 {
            value = String(current + 1)
        } else {
            value = String(20)
        }
    }
}
