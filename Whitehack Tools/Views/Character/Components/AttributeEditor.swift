import SwiftUI

struct AttributeEditor: View {
    let label: String
    @Binding var value: String
    let range: ClosedRange<Int>
    let focusedField: CharacterFormView.Field?
    let field: CharacterFormView.Field
    let focusBinding: FocusState<CharacterFormView.Field?>.Binding
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            TextField("Enter \(label.lowercased())", text: $value)
                .keyboardType(.numberPad)
                .onReceive(value.publisher.collect()) { newValue in
                    let filtered = newValue.filter { "0123456789".contains($0) }
                    if filtered != newValue {
                        self.value = String(filtered)
                    }
                }
                .focused(focusBinding, equals: field)
                .textFieldStyle(.roundedBorder)
        }
    }
}
