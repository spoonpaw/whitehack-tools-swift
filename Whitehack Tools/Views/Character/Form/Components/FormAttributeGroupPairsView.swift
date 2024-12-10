import SwiftUI
import PhosphorSwift

struct AttributeGroupPairEditView: View {
    let pair: AttributeGroupPair
    let attributes: [String]
    let availableGroups: [String]
    @Binding var attributeGroupPairs: [AttributeGroupPair]
    @Binding var editingPairId: UUID?
    @State private var tempAttribute = ""
    @State private var tempGroup = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Attribute")
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.secondary)
                
                Menu {
                    ForEach(attributes, id: \.self) { attribute in
                        Button(action: {
                            tempAttribute = attribute
                        }) {
                            Text(attribute)
                        }
                    }
                } label: {
                    HStack {
                        Text(tempAttribute.isEmpty ? "Select Attribute" : tempAttribute)
                            .foregroundColor(tempAttribute.isEmpty ? .secondary : .primary)
                        Spacer()
                        Image(systemName: "chevron.up.chevron.down")
                            .imageScale(.small)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background({
                        #if os(iOS)
                        Color(uiColor: .systemGray6)
                        #else
                        Color(nsColor: .windowBackgroundColor)
                        #endif
                    }())
                    .cornerRadius(8)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Group")
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.secondary)
                
                Menu {
                    ForEach(availableGroups, id: \.self) { group in
                        Button(action: {
                            tempGroup = group
                        }) {
                            Text(group)
                        }
                    }
                } label: {
                    HStack {
                        Text(tempGroup.isEmpty ? "Select Group" : tempGroup)
                            .foregroundColor(tempGroup.isEmpty ? .secondary : .primary)
                        Spacer()
                        Image(systemName: "chevron.up.chevron.down")
                            .imageScale(.small)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background({
                        #if os(iOS)
                        Color(uiColor: .systemGray6)
                        #else
                        Color(nsColor: .windowBackgroundColor)
                        #endif
                    }())
                    .cornerRadius(8)
                }
            }
            
            HStack {
                Spacer()
                
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
                        if let index = attributeGroupPairs.firstIndex(where: { $0.id == pair.id }) {
                            attributeGroupPairs[index].attribute = tempAttribute
                            attributeGroupPairs[index].group = tempGroup
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
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.background)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        .onAppear {
            tempAttribute = pair.attribute
            tempGroup = pair.group
        }
    }
}

struct AttributeGroupPairDisplayView: View {
    let pair: AttributeGroupPair
    @Binding var attributeGroupPairs: [AttributeGroupPair]
    @Binding var editingPairId: UUID?
    @Binding var tempAttribute: String
    @Binding var tempGroup: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Attribute")
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(.secondary)
                    Text(pair.attribute)
                        .font(.system(.body, design: .rounded))
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                HStack(spacing: 12) {
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
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Group")
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.secondary)
                Text(pair.group)
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(.primary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.background)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

struct AddAttributeGroupView: View {
    let attributes: [String]
    let availableGroups: [String]
    @Binding var selectedAttribute: String
    @Binding var newAttributeGroup: String
    @Binding var isAddingAttributeGroup: Bool
    @Binding var attributeGroupPairs: [AttributeGroupPair]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("New Attribute-Group Pair")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Attribute")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Picker("", selection: $selectedAttribute) {
                    Text("Select Attribute").tag("")
                    ForEach(attributes, id: \.self) { attribute in
                        Text(attribute).tag(attribute)
                    }
                }
                .labelsHidden()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Group")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Picker("", selection: $newAttributeGroup) {
                    Text("Select Group").tag("")
                    ForEach(availableGroups, id: \.self) { group in
                        Text(group).tag(group)
                    }
                }
                .labelsHidden()
            }
            
            Divider()
            
            HStack {
                Spacer()
                
                Button("Cancel") {
                    isAddingAttributeGroup = false
                    selectedAttribute = ""
                    newAttributeGroup = ""
                }
                .keyboardShortcut(.escape, modifiers: [])
                
                Button("Add") {
                    if !selectedAttribute.isEmpty && !newAttributeGroup.isEmpty {
                        attributeGroupPairs.append(AttributeGroupPair(attribute: selectedAttribute, group: newAttributeGroup))
                        selectedAttribute = ""
                        newAttributeGroup = ""
                        isAddingAttributeGroup = false
                    }
                }
                .keyboardShortcut(.return, modifiers: [])
                .disabled(selectedAttribute.isEmpty || newAttributeGroup.isEmpty)
            }
        }
    }
}

struct FormAttributeGroupPairsView: View {
    let attributes: [String]
    @Binding var attributeGroupPairs: [AttributeGroupPair]
    let availableGroups: [String]
    let displayedPairs: [AttributeGroupPair]
    @Binding var selectedAttribute: String
    @Binding var newAttributeGroup: String
    @State private var editingPairId: UUID?
    @State private var tempAttribute = ""
    @State private var tempGroup = ""
    @State private var isShowingAddPopover = false
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack(spacing: 8) {
                Ph.usersThree.bold
                    .frame(width: 20, height: 20)
                Text("Attribute-Group Pairs")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button {
                    isShowingAddPopover = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .imageScale(.large)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.blue)
                }
                .buttonStyle(BorderlessButtonStyle())
                .popover(isPresented: $isShowingAddPopover, arrowEdge: .top) {
                    AddAttributeGroupView(
                        attributes: attributes,
                        availableGroups: availableGroups,
                        selectedAttribute: $selectedAttribute,
                        newAttributeGroup: $newAttributeGroup,
                        isAddingAttributeGroup: $isShowingAddPopover,
                        attributeGroupPairs: $attributeGroupPairs
                    )
                    .frame(width: 300)
                    .padding()
                }
            }
            .padding(.vertical, 4)
            
            // Pairs List
            VStack(spacing: 12) {
                ForEach(displayedPairs) { pair in
                    if editingPairId == pair.id {
                        AttributeGroupPairEditView(
                            pair: pair,
                            attributes: attributes,
                            availableGroups: availableGroups,
                            attributeGroupPairs: $attributeGroupPairs,
                            editingPairId: $editingPairId
                        )
                        .transition(.opacity)
                        .padding()
                        .background(.background)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                    } else {
                        AttributeGroupPairDisplayView(
                            pair: pair,
                            attributeGroupPairs: $attributeGroupPairs,
                            editingPairId: $editingPairId,
                            tempAttribute: $tempAttribute,
                            tempGroup: $tempGroup
                        )
                        .transition(.opacity)
                        .padding()
                        .background(.background)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                    }
                }
            }
        }
    }
}
