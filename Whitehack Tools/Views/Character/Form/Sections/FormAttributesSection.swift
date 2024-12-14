import SwiftUI
import PhosphorSwift

struct IconPicker: View {
    @Binding var selectedIcon: CustomAttributeIcon
    @Environment(\.dismiss) private var dismiss
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 6)
    
    var body: some View {
        #if os(iOS)
        NavigationView {
            iconGrid
        }
        #else
        VStack(spacing: 8) {
            iconGrid
            
            Button("Cancel") {
                dismiss()
            }
            .keyboardShortcut(.escape)
            .padding(.bottom, 8)
        }
        .frame(minWidth: 400, minHeight: 300)
        .padding()
        #endif
    }
    
    private var iconGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(CustomAttributeIcon.allCases, id: \.self) { icon in
                    Button {
                        print(" [ICON PICKER] Selecting icon: \(icon)")
                        selectedIcon = icon
                        dismiss()
                    } label: {
                        icon.iconView
                            .font(.system(size: 24))
                            .frame(width: 44, height: 44)
                            .background(systemFillColor)
                            .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        #if os(iOS)
        .navigationTitle("Select Icon")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    print(" [ICON PICKER] Cancel button tapped")
                    dismiss()
                }
            }
        }
        #endif
    }
    
    private var systemFillColor: Color {
        #if os(iOS)
        return Color(uiColor: .secondarySystemBackground)
        #else
        if #available(macOS 14.0, *) {
            return Color(nsColor: .tertiarySystemFill)
        } else {
            return Color(nsColor: .controlBackgroundColor)
        }
        #endif
    }
}

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
    let attribute: CustomAttribute
    let onDelete: () -> Void
    let onUpdate: (CustomAttribute) -> Void
    @State private var showIconPicker = false
    @State private var localAttribute: CustomAttribute
    @State private var textValue: String
    @FocusState private var isFocused: Bool
    
    init(attribute: CustomAttribute, onDelete: @escaping () -> Void, onUpdate: @escaping (CustomAttribute) -> Void) {
        print(" [CUSTOM ATTRIBUTE EDITOR] Initializing editor for attribute: \(attribute.id)")
        self.attribute = attribute
        self.onDelete = onDelete
        self.onUpdate = onUpdate
        self._localAttribute = State(initialValue: attribute)
        self._textValue = State(initialValue: String(attribute.value))
    }
    
    private let attributeRange = 3...18
    
    var body: some View {
        VStack(spacing: 16) {
            // Delete button in its own container
            HStack {
                Spacer()
                Button(action: {
                    print(" [CUSTOM ATTRIBUTE EDITOR] Delete button tapped for attribute: \(attribute.id)")
                    onDelete()
                }) {
                    Ph.trash.bold
                        .font(.system(size: 16))
                        .frame(width: 24, height: 24)
                        .foregroundColor(.red)
                }
                .buttonStyle(.plain)
            }
            .padding(.bottom, -8)
            
            // Main content in a non-interactive container
            VStack(spacing: 20) {
                // Icon section
                VStack(spacing: 4) {
                    Text("Icon")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Button {
                        print(" [CUSTOM ATTRIBUTE EDITOR] Icon picker button tapped for attribute: \(attribute.id)")
                        showIconPicker = true
                    } label: {
                        localAttribute.icon.iconView
                            .font(.system(size: 32))
                            .frame(width: 60, height: 60)
                            .background(systemFillColor)
                            .cornerRadius(12)
                    }
                    .buttonStyle(.plain)
                    #if os(macOS)
                    .sheet(isPresented: $showIconPicker) {
                        IconPicker(selectedIcon: Binding(
                            get: { localAttribute.icon },
                            set: { newIcon in
                                localAttribute.icon = newIcon
                                onUpdate(localAttribute)
                            }
                        ))
                        .frame(width: 400, height: 300)
                    }
                    #else
                    .sheet(isPresented: $showIconPicker) {
                        IconPicker(selectedIcon: Binding(
                            get: { localAttribute.icon },
                            set: { newIcon in
                                localAttribute.icon = newIcon
                                onUpdate(localAttribute)
                            }
                        ))
                    }
                    #endif
                }
                
                // Name section
                VStack(spacing: 4) {
                    Text("Name")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    TextField("Enter name", text: Binding(
                        get: { 
                            print(" [CUSTOM ATTRIBUTE EDITOR] Getting name for attribute: \(attribute.id)")
                            return localAttribute.name 
                        },
                        set: { newValue in
                            print(" [CUSTOM ATTRIBUTE EDITOR] Setting name for attribute: \(attribute.id) to: \(newValue)")
                            localAttribute.name = newValue
                            onUpdate(localAttribute)
                        }
                    ))
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.center)
                }
                
                // Value section
                VStack(spacing: 4) {
                    Text("Value")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    HStack {
                        TextField("", text: $textValue)
                        .onChange(of: textValue) { newValue in
                            // Only allow numeric characters
                            let filtered = newValue.filter { $0.isNumber }
                            if filtered != newValue {
                                textValue = filtered
                            }
                            // Update the actual value if we have a valid number
                            if let value = Int(filtered) {
                                localAttribute.value = value
                                onUpdate(localAttribute)
                            }
                        }
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 60)
                        #if os(iOS)
                        .keyboardType(.numberPad)
                        #endif
                        .multilineTextAlignment(.center)
                        .font(.title3)
                        .fontWeight(.medium)
                        .focused($isFocused)
                        
                        Stepper("", value: Binding(
                            get: { 
                                print(" [CUSTOM ATTRIBUTE EDITOR] Getting value for attribute: \(attribute.id)")
                                return localAttribute.value 
                            },
                            set: { newValue in
                                print(" [CUSTOM ATTRIBUTE EDITOR] Setting value for attribute: \(attribute.id) to: \(newValue)")
                                let clamped = max(attributeRange.lowerBound, min(attributeRange.upperBound, newValue))
                                localAttribute.value = clamped
                                textValue = String(clamped)
                                onUpdate(localAttribute)
                            }
                        ), in: attributeRange)
                        .labelsHidden()
                    }
                    .frame(maxWidth: 120)
                }
            }
        }
        .padding()
        .background(
            systemFillColor
                .cornerRadius(12)
                .allowsHitTesting(false) // Make background non-interactive
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(separatorColor, lineWidth: 0.5)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        .onAppear {
            validateAndFixEmptyInput()
        }
    }
    
    private func validateAndFixEmptyInput() {
        if localAttribute.value < attributeRange.lowerBound || localAttribute.value > attributeRange.upperBound {
            localAttribute.value = attributeRange.lowerBound
            textValue = String(attributeRange.lowerBound)
            onUpdate(localAttribute)
        }
    }
    
    private var systemFillColor: Color {
        #if os(iOS)
        return Color(uiColor: .secondarySystemBackground)
        #else
        if #available(macOS 14.0, *) {
            return Color(nsColor: .tertiarySystemFill)
        } else {
            return Color(nsColor: .controlBackgroundColor)
        }
        #endif
    }
    
    private var separatorColor: Color {
        #if os(iOS)
        return Color(uiColor: .separator)
        #else
        return Color(nsColor: .separatorColor)
        #endif
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
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            SectionHeader(title: "Attributes", icon: Ph.chartBar.bold)
            
            // Content
            VStack(spacing: 16) {
                Picker("", selection: $useCustomAttributes) {
                    Text("Standard").tag(false)
                    Text("Custom").tag(true)
                }
                .pickerStyle(.segmented)
                .labelsHidden()
                
                if useCustomAttributes {
                    VStack(spacing: 16) {
                        LazyVGrid(columns: [GridItem(.flexible())], spacing: 16) {
                            ForEach(customAttributes) { attribute in
                                CustomAttributeEditor(
                                    attribute: attribute,
                                    onDelete: {
                                        print(" [FORM ATTRIBUTES SECTION] Deleting attribute with id: \(attribute.id)")
                                        if let index = customAttributes.firstIndex(where: { $0.id == attribute.id }) {
                                            customAttributes.remove(at: index)
                                            print(" [FORM ATTRIBUTES SECTION] Attribute deleted successfully")
                                            print(" [FORM ATTRIBUTES SECTION] Remaining attributes: \(customAttributes.map { $0.id })")
                                        }
                                    },
                                    onUpdate: { updatedAttribute in
                                        print(" [FORM ATTRIBUTES SECTION] Updating attribute with id: \(attribute.id)")
                                        if let index = customAttributes.firstIndex(where: { $0.id == attribute.id }) {
                                            customAttributes[index] = updatedAttribute
                                            print(" [FORM ATTRIBUTES SECTION] Attribute updated successfully")
                                        }
                                    }
                                )
                            }
                        }
                        
                        Button {
                            print(" [FORM ATTRIBUTES] Add Custom Attribute button tapped")
                            withAnimation {
                                let newAttribute = CustomAttribute(
                                    id: UUID(),
                                    name: "",
                                    value: 10,
                                    icon: .star
                                )
                                customAttributes.append(newAttribute)
                            }
                        } label: {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Add Attribute")
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .padding(.horizontal)
                    }
                } else {
                    VStack(spacing: 16) {
                        AttributeEditor(
                            label: "Strength",
                            value: $strength,
                            range: 3...18,
                            field: .strength
                        )
                        .frame(maxWidth: .infinity)
                        
                        AttributeEditor(
                            label: "Agility",
                            value: $agility,
                            range: 3...18,
                            field: .agility
                        )
                        .frame(maxWidth: .infinity)
                        
                        AttributeEditor(
                            label: "Toughness",
                            value: $toughness,
                            range: 3...18,
                            field: .toughness
                        )
                        .frame(maxWidth: .infinity)
                        
                        AttributeEditor(
                            label: "Intelligence",
                            value: $intelligence,
                            range: 3...18,
                            field: .intelligence
                        )
                        .frame(maxWidth: .infinity)
                        
                        AttributeEditor(
                            label: "Willpower",
                            value: $willpower,
                            range: 3...18,
                            field: .willpower
                        )
                        .frame(maxWidth: .infinity)
                        
                        AttributeEditor(
                            label: "Charisma",
                            value: $charisma,
                            range: 3...18,
                            field: .charisma
                        )
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(systemFillColor)
            .cornerRadius(10)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var systemFillColor: Color {
        #if os(iOS)
        return Color(uiColor: .secondarySystemBackground)
        #else
        return Color(NSColor.windowBackgroundColor)
        #endif
    }
    
    private var separatorColor: Color {
        #if os(iOS)
        return Color(uiColor: .separator)
        #else
        return Color(NSColor.separatorColor)
        #endif
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
