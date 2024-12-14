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
                    .onChange(of: value) { newValue in
                        // Only allow numeric input
                        let filtered = newValue.filter { $0.isNumber }
                        if filtered != newValue {
                            value = filtered
                        }
                        // Validate range
                        if let intValue = Int(filtered) {
                            let clamped = max(range.lowerBound, min(range.upperBound, intValue))
                            if String(clamped) != filtered {
                                value = String(clamped)
                            }
                        }
                    }
                    .font(.title2)
                    .fontWeight(.bold)
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
    }
    
    private func decrementValue() {
        if let current = Int(value), current > range.lowerBound {
            value = String(current - 1)
        }
    }
    
    private func incrementValue() {
        if let current = Int(value), current < range.upperBound {
            value = String(current + 1)
        }
    }
}
