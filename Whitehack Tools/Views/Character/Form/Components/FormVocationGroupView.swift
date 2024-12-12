import SwiftUI

struct FormVocationGroupView: View {
    @Binding var vocationGroup: String
    @Binding var isVocationGroupAdded: Bool
    @Binding var attributeGroupPairs: [AttributeGroupPair]
    @FocusState.Binding var focusedField: CharacterFormView.Field?
    var onRemove: () -> Void
    
    @State private var isAddingVocation = false
    @State private var editingVocation = false
    @State private var tempVocationText = ""
    @State private var newVocationText = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Vocation Group")
                .font(.system(.subheadline, design: .rounded))
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
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
                            .foregroundColor(.secondary)
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
            } else if isVocationGroupAdded {
                HStack {
                    if editingVocation {
                        TextField("Edit Vocation Group", text: $tempVocationText)
                            .textFieldStyle(.roundedBorder)
                            #if os(iOS)
                            .textInputAutocapitalization(.words)
                            #endif
                            .focused($focusedField, equals: .vocationGroup)
                        
                        HStack(spacing: 12) {
                            Button {
                                withAnimation(.easeInOut) {
                                    editingVocation = false
                                    tempVocationText = ""
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
                                    tempVocationText = ""
                                }
                            } label: {
                                Image(systemName: "checkmark.circle.fill")
                                    .imageScale(.large)
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundColor(.green)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    } else {
                        Text(vocationGroup)
                            .font(.title3)
                        Spacer()
                        HStack(spacing: 12) {
                            Button {
                                withAnimation(.easeInOut) {
                                    editingVocation = true
                                    tempVocationText = vocationGroup
                                }
                            } label: {
                                Image(systemName: "pencil.circle.fill")
                                    .imageScale(.large)
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundColor(.blue)
                            }
                            
                            Button {
                                withAnimation(.easeInOut) {
                                    onRemove()
                                }
                            } label: {
                                Image(systemName: "trash.circle.fill")
                                    .imageScale(.large)
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundColor(.red)
                            }
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
            } else {
                Button {
                    withAnimation(.easeInOut) {
                        isAddingVocation = true
                        newVocationText = ""
                    }
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                            .symbolRenderingMode(.hierarchical)
                        Text("Add Vocation Group")
                    }
                    .foregroundColor(.blue)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
        }
    }
}
