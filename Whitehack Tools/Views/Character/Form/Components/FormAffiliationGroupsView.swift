import SwiftUI

struct FormAffiliationGroupsView: View {
    @Binding var affiliationGroups: [String]
    @Binding var newAffiliationGroup: String
    @Binding var attributeGroupPairs: [AttributeGroupPair]
    @FocusState.Binding var focusedField: CharacterFormView.Field?
    
    @State private var isAddingAffiliation = false
    @State private var editingAffiliationIndex: Int? = nil
    @State private var tempAffiliationText = ""
    @State private var newAffiliationText = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Affiliation Groups")
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                Spacer()
                if !isAddingAffiliation {
                    Button {
                        withAnimation(.easeInOut) {
                            isAddingAffiliation = true
                            newAffiliationText = ""
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
            
            if isAddingAffiliation {
                HStack {
                    TextField("Add Affiliation Group", text: $newAffiliationText)
                        .textInputAutocapitalization(.words)
                        .focused($focusedField, equals: .newAffiliationGroup)
                        .textFieldStyle(.roundedBorder)
                    
                    Button {
                        withAnimation(.easeInOut) {
                            newAffiliationText = ""
                            isAddingAffiliation = false
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
                            let trimmed = newAffiliationText.trimmingCharacters(in: .whitespaces)
                            if !trimmed.isEmpty {
                                affiliationGroups.append(trimmed)
                            }
                            newAffiliationText = ""
                            isAddingAffiliation = false
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
            
            if !affiliationGroups.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(Array(affiliationGroups.enumerated()), id: \.element) { index, group in
                        HStack {
                            if editingAffiliationIndex == index {
                                TextField("Edit Affiliation Group", text: $tempAffiliationText)
                                    .textFieldStyle(.roundedBorder)
                                    .onAppear { tempAffiliationText = group }
                                Button {
                                    withAnimation(.easeInOut) {
                                        editingAffiliationIndex = nil
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
                                        let trimmed = tempAffiliationText.trimmingCharacters(in: .whitespaces)
                                        if !trimmed.isEmpty {
                                            affiliationGroups[index] = trimmed
                                            // Update any attribute pairs that were using the old group name
                                            attributeGroupPairs = attributeGroupPairs.map { pair in
                                                if pair.group == group {
                                                    return AttributeGroupPair(attribute: pair.attribute, group: trimmed)
                                                }
                                                return pair
                                            }
                                        }
                                        editingAffiliationIndex = nil
                                    }
                                } label: {
                                    Image(systemName: "checkmark.circle.fill")
                                        .imageScale(.medium)
                                        .symbolRenderingMode(.hierarchical)
                                        .foregroundColor(.green)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            } else {
                                Text(group)
                                    .foregroundColor(.primary)
                                Spacer()
                                Button {
                                    withAnimation(.easeInOut) {
                                        editingAffiliationIndex = index
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
                                        attributeGroupPairs.removeAll { $0.group == group }
                                        affiliationGroups.removeAll { $0 == group }
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
                .frame(maxHeight: affiliationGroups.count > 3 ? 150 : nil)
                .animation(.easeInOut, value: affiliationGroups)
            }
        }
    }
}
