import SwiftUI
import PhosphorSwift

struct IconPicker: View {
    @Binding var selectedIcon: CustomAttributeIcon
    @Environment(\.dismiss) private var dismiss
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 4)
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(CustomAttributeIcon.allCases, id: \.self) { icon in
                        Button {
                            print(" [ICON PICKER] Selecting icon: \(icon)")
                            selectedIcon = icon
                            dismiss()
                        } label: {
                            icon.iconView
                                .font(.system(size: 24))
                                .frame(width: 44, height: 44)
                                .background(Color(.tertiarySystemFill))
                                .cornerRadius(8)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
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
        }
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
    
    init(attribute: CustomAttribute, onDelete: @escaping () -> Void, onUpdate: @escaping (CustomAttribute) -> Void) {
        print(" [CUSTOM ATTRIBUTE EDITOR] Initializing editor for attribute: \(attribute.id)")
        self.attribute = attribute
        self.onDelete = onDelete
        self.onUpdate = onUpdate
        self._localAttribute = State(initialValue: attribute)
    }
    
    private let attributeRange = 1...20
    
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
                            .background(Color(.tertiarySystemFill))
                            .cornerRadius(12)
                    }
                    .buttonStyle(.plain)
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
                        Text("\(localAttribute.value)")
                            .font(.title3)
                            .fontWeight(.medium)
                            .frame(minWidth: 32)
                        
                        Stepper("", value: Binding(
                            get: { 
                                print(" [CUSTOM ATTRIBUTE EDITOR] Getting value for attribute: \(attribute.id)")
                                return localAttribute.value 
                            },
                            set: { newValue in
                                print(" [CUSTOM ATTRIBUTE EDITOR] Setting value for attribute: \(attribute.id) to: \(newValue)")
                                localAttribute.value = newValue
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
            Color(.secondarySystemGroupedBackground)
                .cornerRadius(12)
                .allowsHitTesting(false) // Make background non-interactive
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.separator), lineWidth: 0.5)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        .sheet(isPresented: $showIconPicker) {
            IconPicker(selectedIcon: Binding(
                get: { 
                    print(" [CUSTOM ATTRIBUTE EDITOR] Getting icon for attribute: \(attribute.id)")
                    return localAttribute.icon 
                },
                set: { newValue in
                    print(" [CUSTOM ATTRIBUTE EDITOR] Setting icon for attribute: \(attribute.id) to: \(newValue)")
                    localAttribute.icon = newValue
                    onUpdate(localAttribute)
                }
            ))
        }
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
        Section {
            VStack(spacing: 16) {
                VStack(alignment: .center, spacing: 5) {
                    Text("Attribute Type")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Picker("Attribute Type", selection: $useCustomAttributes) {
                        Text("Default").tag(false)
                        Text("Custom").tag(true)
                    }
                    .pickerStyle(.segmented)
                }
                
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
                            print(" [FORM ATTRIBUTES SECTION] Adding new attribute")
                            let newAttribute = CustomAttribute(
                                name: "",
                                value: 10,
                                icon: .barbell
                            )
                            customAttributes.append(newAttribute)
                            print(" [FORM ATTRIBUTES SECTION] New attribute added with id: \(newAttribute.id)")
                            print(" [FORM ATTRIBUTES SECTION] Current attributes: \(customAttributes.map { $0.id })")
                        } label: {
                            HStack(spacing: 4) {
                                Ph.plus.bold
                                    .frame(width: 16, height: 16)
                                Text("Add Attribute")
                            }
                            .font(.body)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(Color(.tertiarySystemFill))
                            .cornerRadius(8)
                        }
                        .buttonStyle(.plain)
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
        }
        .onAppear {
            print(" [FORM ATTRIBUTES SECTION] Appearing")
            print(" [FORM ATTRIBUTES SECTION] Current attributes count: \(customAttributes.count)")
            print(" [FORM ATTRIBUTES SECTION] Current attributes: \(customAttributes.map { $0.id })")
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
