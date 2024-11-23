import SwiftUI

struct FormAttributeGroupPairsView: View {
    @Binding var attributeGroupPairs: [AttributeGroupPair]
    @Binding var selectedAttribute: String
    @Binding var newAttributeGroup: String
    let availableGroups: [String]
    @FocusState.Binding var focusedField: CharacterFormView.Field?
    
    @State private var isAddingAttributeGroup = false
    @State private var editingPairId: UUID? = nil
    @State private var tempAttribute = ""
    @State private var tempGroup = ""
    
    private let attributes = ["Strength", "Agility", "Toughness", "Intelligence", "Willpower", "Charisma"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Attribute-Group Pairs")
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                Spacer()
                if !availableGroups.isEmpty && !isAddingAttributeGroup {
                    Button {
                        withAnimation(.easeInOut) {
                            isAddingAttributeGroup = true
                            selectedAttribute = ""
                            newAttributeGroup = ""
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
            
            if !attributeGroupPairs.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(attributeGroupPairs) { pair in
                        HStack {
                            if editingPairId == pair.id {
                                HStack(spacing: 8) {
                                    Menu {
                                        ForEach(attributes.filter { attribute in
                                            !attributeGroupPairs.contains { $0.attribute == attribute && $0.id != pair.id }
                                        }, id: \.self) { attribute in
                                            Button(attribute) {
                                                withAnimation(.easeInOut) {
                                                    tempAttribute = attribute
                                                }
                                            }
                                        }
                                    } label: {
                                        HStack {
                                            Text(tempAttribute.isEmpty ? "Select Attribute" : tempAttribute)
                                                .foregroundColor(tempAttribute.isEmpty ? .secondary : .primary)
                                                .frame(minWidth: 100, alignment: .leading)
                                            Image(systemName: "chevron.up.chevron.down")
                                                .imageScale(.small)
                                                .foregroundColor(.secondary)
                                        }
                                        .frame(maxWidth: 120)
                                    }
                                    
                                    Menu {
                                        ForEach(availableGroups, id: \.self) { group in
                                            Button(group) {
                                                withAnimation(.easeInOut) {
                                                    tempGroup = group
                                                }
                                            }
                                        }
                                    } label: {
                                        HStack {
                                            Text(tempGroup.isEmpty ? "Select Group" : tempGroup)
                                                .foregroundColor(tempGroup.isEmpty ? .secondary : .primary)
                                            Image(systemName: "chevron.up.chevron.down")
                                                .imageScale(.small)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    HStack(spacing: 8) {
                                        Button {
                                            withAnimation(.easeInOut) {
                                                editingPairId = nil
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
                                                if !tempAttribute.isEmpty && !tempGroup.isEmpty {
                                                    if let index = attributeGroupPairs.firstIndex(where: { $0.id == pair.id }) {
                                                        attributeGroupPairs[index] = AttributeGroupPair(attribute: tempAttribute, group: tempGroup)
                                                    }
                                                }
                                                editingPairId = nil
                                            }
                                        } label: {
                                            Image(systemName: "checkmark.circle.fill")
                                                .imageScale(.medium)
                                                .symbolRenderingMode(.hierarchical)
                                                .foregroundColor(.green)
                                        }
                                        .buttonStyle(BorderlessButtonStyle())
                                        .disabled(tempAttribute.isEmpty || tempGroup.isEmpty)
                                    }
                                }
                            } else {
                                Text(pair.attribute)
                                    .font(.system(.body, design: .rounded))
                                    .frame(minWidth: 100, alignment: .leading)
                                Text(pair.group)
                                    .foregroundColor(.primary)
                                Spacer()
                                Button {
                                    withAnimation(.easeInOut) {
                                        editingPairId = pair.id
                                        tempAttribute = pair.attribute
                                        tempGroup = pair.group
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
                                        attributeGroupPairs.removeAll { $0.id == pair.id }
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
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                }
                .animation(.easeInOut, value: attributeGroupPairs)
            }
            
            if isAddingAttributeGroup {
                VStack(alignment: .leading, spacing: 12) {
                    Menu {
                        ForEach(attributes.filter { attribute in
                            !attributeGroupPairs.contains { $0.attribute == attribute }
                        }, id: \.self) { attribute in
                            Button(attribute) {
                                withAnimation(.easeInOut) {
                                    selectedAttribute = attribute
                                }
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedAttribute.isEmpty ? "Select Attribute" : selectedAttribute)
                                .foregroundColor(selectedAttribute.isEmpty ? .secondary : .primary)
                            Spacer()
                            Image(systemName: "chevron.up.chevron.down")
                                .imageScale(.small)
                                .foregroundColor(.secondary)
                        }
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                    
                    Menu {
                        ForEach(availableGroups, id: \.self) { group in
                            Button(group) {
                                withAnimation(.easeInOut) {
                                    newAttributeGroup = group
                                }
                            }
                        }
                    } label: {
                        HStack {
                            Text(newAttributeGroup.isEmpty ? "Select Group" : newAttributeGroup)
                                .foregroundColor(newAttributeGroup.isEmpty ? .secondary : .primary)
                            Spacer()
                            Image(systemName: "chevron.up.chevron.down")
                                .imageScale(.small)
                                .foregroundColor(.secondary)
                        }
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                    
                    HStack {
                        Spacer()
                        Button {
                            withAnimation(.easeInOut) {
                                newAttributeGroup = ""
                                selectedAttribute = ""
                                isAddingAttributeGroup = false
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
                                if !selectedAttribute.isEmpty && !newAttributeGroup.isEmpty {
                                    attributeGroupPairs.append(AttributeGroupPair(attribute: selectedAttribute, group: newAttributeGroup))
                                    newAttributeGroup = ""
                                    selectedAttribute = ""
                                    isAddingAttributeGroup = false
                                }
                            }
                        } label: {
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(.green)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .disabled(selectedAttribute.isEmpty || newAttributeGroup.isEmpty)
                    }
                }
                .transition(.opacity)
            }
        }
    }
}
