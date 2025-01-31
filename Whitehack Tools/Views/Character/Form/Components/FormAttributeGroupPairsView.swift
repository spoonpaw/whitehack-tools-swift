import SwiftUI
import PhosphorSwift

struct FormAttributeGroupPairsView: View {
    let attributes: [String]
    @Binding var attributeGroupPairs: [AttributeGroupPair]
    let availableGroups: [String]
    let displayedPairs: [AttributeGroupPair]
    
    @State private var isAddingPair = false
    @State private var editingPairId: UUID?
    @State private var tempAttribute = ""
    @State private var tempGroup = ""
    
    var body: some View {
        VStack(spacing: 16) {
            // Add new pair button
            if !isAddingPair {
                Button {
                    withAnimation(.easeInOut) {
                        isAddingPair = true
                    }
                } label: {
                    HStack {
                        Text("Add Attribute-Group Pair")
                            .foregroundColor(.blue)
                        Spacer()
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.medium)
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.blue)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(.background)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            
            // Active editing card
            if isAddingPair {
                VStack(spacing: 12) {
                    Text("New Attribute-Group Pair")
                        .font(.system(.subheadline, design: .rounded))
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    VStack(spacing: 8) {
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
                            .frame(maxWidth: .infinity)
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
                        .id(attributes.joined())
                        .onChange(of: attributes) { newAttributes in
                            // Clear the selected attribute if it's no longer available
                            if !tempAttribute.isEmpty && !newAttributes.contains(tempAttribute) {
                                tempAttribute = ""
                            }
                        }
                        
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
                            .frame(maxWidth: .infinity)
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
                        .id(availableGroups.joined())
                        .onChange(of: availableGroups) { newGroups in
                            // If the selected group is no longer available, clear it
                            if !tempGroup.isEmpty && !newGroups.contains(tempGroup) {
                                tempGroup = ""
                            }
                        }
                    }
                    
                    HStack {
                        Spacer()
                        Button {
                            withAnimation(.easeInOut) {
                                tempAttribute = ""
                                tempGroup = ""
                                isAddingPair = false
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
                                if !tempAttribute.isEmpty && !tempGroup.isEmpty {
                                    let newPair = AttributeGroupPair(
                                        attribute: tempAttribute,
                                        group: tempGroup
                                    )
                                    attributeGroupPairs.append(newPair)
                                    tempAttribute = ""
                                    tempGroup = ""
                                    isAddingPair = false
                                }
                            }
                        } label: {
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(.green)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .disabled(tempAttribute.isEmpty || tempGroup.isEmpty)
                    }
                }
                .padding(12)
                .background(.background)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
            }
            
            // Existing pairs
            ForEach(Array(displayedPairs.enumerated()), id: \.element.id) { index, pair in
                if editingPairId == pair.id {
                    // Edit mode card
                    VStack(spacing: 12) {
                        Text("Edit Attribute-Group Pair")
                            .font(.system(.subheadline, design: .rounded))
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                        VStack(spacing: 8) {
                            Menu {
                                ForEach(attributes, id: \.self) { attribute in
                                    Button(action: {
                                        var updatedPair = pair
                                        updatedPair.attribute = attribute
                                        let index = attributeGroupPairs.firstIndex { $0.id == pair.id }!
                                        attributeGroupPairs[index] = updatedPair
                                    }) {
                                        Text(attribute)
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(pair.attribute)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.up.chevron.down")
                                        .imageScale(.small)
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity)
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
                            .id(attributes.joined())
                            .onChange(of: attributes) { newAttributes in
                                // Remove the pair if its attribute is no longer available
                                if !pair.attribute.isEmpty && !newAttributes.contains(pair.attribute) {
                                    attributeGroupPairs.removeAll { $0.id == pair.id }
                                }
                            }
                            
                            Menu {
                                ForEach(availableGroups, id: \.self) { group in
                                    Button(action: {
                                        var updatedPair = pair
                                        updatedPair.group = group
                                        if let index = attributeGroupPairs.firstIndex(where: { $0.id == pair.id }) {
                                            attributeGroupPairs[index] = updatedPair
                                        }
                                    }) {
                                        Text(group)
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(pair.group)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.up.chevron.down")
                                        .imageScale(.small)
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity)
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
                            .id(availableGroups.joined())
                            .onChange(of: availableGroups) { newGroups in
                                // Update pair's group if it was renamed
                                if !pair.group.isEmpty && !newGroups.contains(pair.group) {
                                    // Try to find the new name by comparing with old groups
                                    if let oldGroupIndex = availableGroups.firstIndex(of: pair.group),
                                       oldGroupIndex < newGroups.count {
                                        var updatedPair = pair
                                        updatedPair.group = newGroups[oldGroupIndex]
                                        if let index = attributeGroupPairs.firstIndex(where: { $0.id == pair.id }) {
                                            attributeGroupPairs[index] = updatedPair
                                        }
                                    }
                                }
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
                                    if !tempAttribute.isEmpty && !tempGroup.isEmpty {
                                        if let index = attributeGroupPairs.firstIndex(where: { $0.id == pair.id }) {
                                            attributeGroupPairs[index].attribute = tempAttribute
                                            attributeGroupPairs[index].group = tempGroup
                                        }
                                        editingPairId = nil
                                    }
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
                    .padding(12)
                    .background(.background)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                } else {
                    // Display mode card
                    HStack {
                        Text(pair.attribute)
                            .foregroundColor(.primary)
                        
                        Image(systemName: "arrow.right")
                            .imageScale(.small)
                            .foregroundColor(.secondary)
                        
                        Text(pair.group)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Button {
                            withAnimation(.easeInOut) {
                                tempAttribute = pair.attribute
                                tempGroup = pair.group
                                editingPairId = pair.id
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
                    .padding(12)
                    .background(.background)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                }
            }
        }
    }
}
