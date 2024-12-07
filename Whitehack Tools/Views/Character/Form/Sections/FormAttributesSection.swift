import SwiftUI
import PhosphorSwift

struct FormSectionHeader: View {
    let title: String
    let icon: Image
    
    var body: some View {
        HStack(spacing: 8) {
            icon
                .frame(width: 20, height: 20)
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 4)
    }
}

struct CustomAttributeEditor: View {
    @Binding var attribute: CustomAttribute
    let attributeRange: ClosedRange<Int>
    let onRemove: () -> Void
    
    private var backgroundColor: Color {
        #if os(iOS)
        return Color(.secondarySystemBackground)
        #else
        return Color(NSColor.windowBackgroundColor)
        #endif
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                TextField("", text: $attribute.name)
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.center)
                    .placeholder(when: attribute.name.isEmpty) {
                        Text("Attribute Name")
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                
                Button(action: onRemove) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                        .font(.title3)
                }
                .buttonStyle(.borderless)
            }
            
            HStack {
                Button(action: {
                    if attribute.value > attributeRange.lowerBound {
                        attribute.value -= 1
                    }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.red)
                }
                .buttonStyle(.borderless)
                
                Text(String(attribute.value))
                    .font(.headline)
                    .frame(width: 40)
                    .multilineTextAlignment(.center)
                
                Button(action: {
                    if attribute.value < attributeRange.upperBound {
                        attribute.value += 1
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.green)
                }
                .buttonStyle(.borderless)
            }
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(10)
    }
}

struct FormAttributesSection: View {
    @Binding var useCustomAttributes: Bool
    @Binding var customAttributes: [CustomAttribute]
    @Binding var strength: String
    @Binding var agility: String
    @Binding var toughness: String
    @Binding var intelligence: String
    @Binding var willpower: String
    @Binding var charisma: String
    @FocusState private var focusedField: CharacterFormView.Field?
    
    private let attributeRange = 3...18
    
    private var backgroundColor: Color {
        #if os(iOS)
        return Color(.secondarySystemBackground)
        #else
        return Color(NSColor.windowBackgroundColor)
        #endif
    }
    
    var body: some View {
        Section {
            VStack(spacing: 16) {
                // Toggle for custom attributes
                VStack(alignment: .center, spacing: 5) {
                    Text("Attribute Type")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Picker("", selection: $useCustomAttributes) {
                        Text("Default").tag(false)
                        Text("Custom").tag(true)
                    }
                    .pickerStyle(.segmented)
                    .frame(maxWidth: .infinity)
                }
                
                if useCustomAttributes {
                    // Custom Attributes Editor
                    VStack(spacing: 16) {
                        ForEach(customAttributes) { attribute in
                            let index = customAttributes.firstIndex(where: { $0.id == attribute.id })!
                            CustomAttributeEditor(
                                attribute: $customAttributes[index],
                                attributeRange: attributeRange,
                                onRemove: {
                                    withAnimation {
                                        customAttributes.removeAll(where: { $0.id == attribute.id })
                                    }
                                }
                            )
                        }
                        
                        Button(action: {
                            withAnimation {
                                customAttributes.append(CustomAttribute())
                            }
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Add Attribute")
                            }
                            .font(.headline)
                            .foregroundColor(.accentColor)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(Color.accentColor, lineWidth: 2)
                                    .background(backgroundColor)
                            )
                        }
                        .buttonStyle(.borderless)
                    }
                } else {
                    // Default Attributes
                    AttributeEditor(
                        label: "Strength",
                        value: $strength,
                        range: attributeRange,
                        field: .strength
                    )
                    .frame(maxWidth: .infinity)
                    
                    AttributeEditor(
                        label: "Agility",
                        value: $agility,
                        range: attributeRange,
                        field: .agility
                    )
                    .frame(maxWidth: .infinity)
                    
                    AttributeEditor(
                        label: "Toughness",
                        value: $toughness,
                        range: attributeRange,
                        field: .toughness
                    )
                    .frame(maxWidth: .infinity)
                    
                    AttributeEditor(
                        label: "Intelligence",
                        value: $intelligence,
                        range: attributeRange,
                        field: .intelligence
                    )
                    .frame(maxWidth: .infinity)
                    
                    AttributeEditor(
                        label: "Willpower",
                        value: $willpower,
                        range: attributeRange,
                        field: .willpower
                    )
                    .frame(maxWidth: .infinity)
                    
                    AttributeEditor(
                        label: "Charisma",
                        value: $charisma,
                        range: attributeRange,
                        field: .charisma
                    )
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
        } header: {
            HStack(spacing: 8) {
                Ph.barbell.bold
                    .frame(width: 20, height: 20)
                Text("Attributes")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 4)
        }
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
