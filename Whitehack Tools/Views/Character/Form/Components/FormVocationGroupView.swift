import SwiftUI

struct FormVocationGroupView: View {
    @Binding var vocationGroup: String
    @Binding var isVocationGroupAdded: Bool
    @Binding var attributeGroupPairs: [AttributeGroupPair]
    @FocusState.Binding var focusedField: CharacterFormView.Field?
    
    @State private var isAddingVocation = false
    @State private var editingVocation = false
    @State private var tempVocationText = ""
    @State private var newVocationText = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Vocation Group")
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                Spacer()
                if !isVocationGroupAdded && !isAddingVocation {
                    Button {
                        withAnimation(.easeInOut) {
                            isAddingVocation = true
                            newVocationText = ""
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            
            if isAddingVocation {
                HStack {
                    TextField("Add Vocation Group", text: $newVocationText)
                        .textFieldStyle(.roundedBorder)
                        #if os(iOS)
                        .textInputAutocapitalization(.words)
                        #endif
                        .focused($focusedField, equals: .vocationGroup)
                    
                    Button {
                        withAnimation(.easeInOut) {
                            newVocationText = ""
                            isAddingVocation = false
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .imageScale(.large)
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.red)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    
                    Button {
                        withAnimation(.easeInOut) {
                            let trimmed = newVocationText.trimmingCharacters(in: .whitespaces)
                            if !trimmed.isEmpty {
                                vocationGroup = trimmed
                                isVocationGroupAdded = true
                            }
                            newVocationText = ""
                            isAddingVocation = false
                        }
                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                            .imageScale(.large)
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.green)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            
            if isVocationGroupAdded {
                HStack {
                    if editingVocation {
                        TextField("Edit Vocation Group", text: $tempVocationText)
                            .textFieldStyle(.roundedBorder)
                            .onAppear { tempVocationText = vocationGroup }
                        Button {
                            withAnimation(.easeInOut) {
                                editingVocation = false
                            }
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.medium)
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(.red)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        Button {
                            withAnimation(.easeInOut) {
                                let trimmed = tempVocationText.trimmingCharacters(in: .whitespaces)
                                if !trimmed.isEmpty {
                                    // Update any attribute pairs that were using the old group name
                                    attributeGroupPairs = attributeGroupPairs.map { pair in
                                        if pair.group == vocationGroup {
                                            return AttributeGroupPair(attribute: pair.attribute, group: trimmed)
                                        }
                                        return pair
                                    }
                                    vocationGroup = trimmed
                                }
                                editingVocation = false
                            }
                        } label: {
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.medium)
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(.green)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    } else {
                        Text(vocationGroup)
                            .foregroundColor(.primary)
                        Spacer()
                        Button {
                            withAnimation(.easeInOut) {
                                editingVocation = true
                            }
                        } label: {
                            Image(systemName: "pencil.circle.fill")
                                .imageScale(.medium)
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(.blue)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        Button {
                            withAnimation(.easeInOut) {
                                // Remove any attribute pairs associated with this group
                                attributeGroupPairs.removeAll { $0.group == vocationGroup }
                                vocationGroup = ""
                                isVocationGroupAdded = false
                            }
                        } label: {
                            Image(systemName: "trash.circle.fill")
                                .imageScale(.medium)
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(.red)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
                .padding()
                #if os(iOS)
                .background(Color(uiColor: .systemGray6))
                #else
                .background(Color(nsColor: .controlBackgroundColor))
                #endif
                .cornerRadius(8)
            }
        }
    }
}
