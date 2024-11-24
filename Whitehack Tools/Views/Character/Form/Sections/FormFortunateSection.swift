import SwiftUI
import PhosphorSwift

struct FormFortunateSection: View {
    let characterClass: CharacterClass
    let level: Int
    @Binding var fortunateOptions: FortunateOptions
    @Environment(\.colorScheme) var colorScheme
    
    private var availableRetainers: Int {
        guard characterClass == .fortunate else { return 0 }
        let stats = AdvancementTables.shared.stats(for: characterClass, at: level)
        return stats.slots
    }
    
    private func initializeRetainersIfNeeded() {
        // Ensure we have the correct number of retainers
        while fortunateOptions.retainers.count < availableRetainers {
            fortunateOptions.retainers.append(Retainer())
        }
        while fortunateOptions.retainers.count > availableRetainers {
            fortunateOptions.retainers.removeLast()
        }
    }

    var body: some View {
        if characterClass == .fortunate {
            Section {
                VStack(spacing: 16) {
                    // MARK: - Standing & Fortune
                    VStack(alignment: .leading, spacing: 20) {
                        // Header
                        HStack {
                            Text("Daily Power")
                                .font(.title3)
                                .fontWeight(.medium)
                            Spacer()
                            ZStack {
                                Circle()
                                    .fill(Color.purple.opacity(0.2))
                                    .frame(width: 44, height: 44)
                                Image(systemName: "sparkles")
                                    .foregroundColor(.purple)
                                    .font(.system(size: 20))
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                        
                        Toggle(isOn: $fortunateOptions.hasUsedFortune) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Good Fortune")
                                    .fontWeight(.medium)
                                Text("Daily power to reroll any roll")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .tint(.purple)
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(colorScheme == .dark ? Color(.systemGray6) : .white)
                            .shadow(color: Color(.systemGray4).opacity(0.3), radius: 8, x: 0, y: 2)
                    )
                    .padding(.horizontal, 4)
                    
                    // MARK: - Standing
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Text("Noble Standing")
                                .font(.title3)
                                .fontWeight(.medium)
                            Spacer()
                            ZStack {
                                Circle()
                                    .fill(Color.purple.opacity(0.2))
                                    .frame(width: 44, height: 44)
                                Image(systemName: "crown.fill")
                                    .foregroundColor(.purple)
                                    .font(.system(size: 20))
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            TextField("e.g., Reincarnated Master, Royal Heir", text: $fortunateOptions.standing)
                                .textFieldStyle(FormFortunateCustomTextFieldStyle())
                                .padding(.horizontal, 4)
                            Text("Your noble standing grants you special privileges and responsibilities")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(colorScheme == .dark ? Color(.systemGray6) : .white)
                            .shadow(color: Color(.systemGray4).opacity(0.3), radius: 8, x: 0, y: 2)
                    )
                    .padding(.horizontal, 4)
                    
                    // MARK: - Signature Object
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Text("Signature Object")
                                .font(.title3)
                                .fontWeight(.medium)
                            Spacer()
                            ZStack {
                                Circle()
                                    .fill(Color.purple.opacity(0.2))
                                    .frame(width: 44, height: 44)
                                Image(systemName: "star.fill")
                                    .foregroundColor(.purple)
                                    .font(.system(size: 20))
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            TextField("Enter signature object name", text: $fortunateOptions.signatureObject.name)
                                .textFieldStyle(FormFortunateCustomTextFieldStyle())
                                .padding(.horizontal, 4)
                            Text("Your signature object has plot immunity and cannot be lost or destroyed without your consent")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(colorScheme == .dark ? Color(.systemGray6) : .white)
                            .shadow(color: Color(.systemGray4).opacity(0.3), radius: 8, x: 0, y: 2)
                    )
                    .padding(.horizontal, 4)
                    
                    // MARK: - Retainers
                    ForEach(0..<fortunateOptions.retainers.count, id: \.self) { index in
                        FormFortunateRetainerFormView(retainer: binding(for: index))
                            .transition(.scale.combined(with: .opacity))
                    }
                }
            } header: {
                Label {
                    Text("Fortunate Features")
                        .font(.headline)
                        .foregroundColor(.primary)
                } icon: {
                    Image(systemName: "crown.fill")
                        .foregroundStyle(.purple)
                }
            }
            .onAppear {
                initializeRetainersIfNeeded()
            }
        }
    }
    
    private func binding(for index: Int) -> Binding<Retainer> {
        Binding(
            get: { fortunateOptions.retainers[index] },
            set: { fortunateOptions.retainers[index] = $0 }
        )
    }
}

struct FormFortunateRetainerFormView: View {
    @Binding var retainer: Retainer
    @State private var isAddingKeyword = false
    @State private var editingKeywordIndex: Int? = nil
    @State private var tempKeywordText = ""
    @State private var newKeywordText = ""
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(retainer.name.isEmpty ? "Unnamed Retainer" : retainer.name)
                        .font(.title3)
                        .fontWeight(.bold)
                    Text(retainer.type.isEmpty ? "Type Undefined" : retainer.type)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "person.fill")
                    .font(.title2)
                    .foregroundColor(.purple)
            }
            .padding()
            .background(Color(.systemBackground))
            
            Divider()
            
            // Content
            VStack(spacing: 20) {
                // Basic Info
                VStack(alignment: .leading, spacing: 12) {
                    FormFortunateSectionHeader(title: "Basic Information", icon: Image(systemName: "person.text.rectangle.fill"))
                    
                    HStack(spacing: 12) {
                        FormFortunateCustomTextField(title: "Name", text: $retainer.name, icon: "person.fill")
                        FormFortunateCustomTextField(title: "Type", text: $retainer.type, icon: "tag.fill")
                    }
                }
                
                // Stats
                VStack(alignment: .leading, spacing: 12) {
                    FormFortunateSectionHeader(title: "Combat Stats", icon: Image(systemName: "shield.lefthalf.filled"))
                    
                    HStack(spacing: 16) {
                        FormFortunateStatField(label: "HD", value: $retainer.hitDice, systemImage: "heart.fill", color: .red)
                        FormFortunateStatField(label: "DF", value: $retainer.defenseFactor, systemImage: "shield.fill", color: .blue)
                        FormFortunateStatField(label: "MV", value: $retainer.movement, systemImage: "figure.walk", color: .green)
                    }
                }
                
                // Notes
                VStack(alignment: .leading, spacing: 12) {
                    FormFortunateSectionHeader(title: "Notes", icon: Image(systemName: "note.text"))
                    
                    TextEditor(text: $retainer.notes)
                        .frame(height: 60)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                
                // Keywords
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        FormFortunateSectionHeader(title: "Keywords", icon: Image(systemName: "tag.fill"))
                        Spacer()
                        if !isAddingKeyword {
                            FormFortunateAddButton {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    isAddingKeyword = true
                                    newKeywordText = ""
                                }
                            }
                        }
                    }
                    
                    if isAddingKeyword {
                        FormFortunateKeywordInputField(
                            text: $newKeywordText,
                            onCancel: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    isAddingKeyword = false
                                }
                            },
                            onSave: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    let trimmed = newKeywordText.trimmingCharacters(in: .whitespaces)
                                    if !trimmed.isEmpty {
                                        retainer.keywords.append(trimmed)
                                    }
                                    newKeywordText = ""
                                    isAddingKeyword = false
                                }
                            }
                        )
                    }
                    
                    if !retainer.keywords.isEmpty {
                        TagFlowView(data: retainer.keywords, spacing: 8) { keyword in
                            KeywordTag(keyword: keyword) {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    retainer.keywords.removeAll { $0 == keyword }
                                }
                            }
                        }
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color(.systemGray4).opacity(0.3), radius: 10, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.purple.opacity(0.3), lineWidth: 1)
            )
        }
    }
}

// MARK: - Supporting Views

struct FormFortunateSectionHeader: View {
    let title: String
    let icon: Image
    
    var body: some View {
        HStack(spacing: 8) {
            icon
                .frame(width: 20, height: 20)
            Text(title)
        }
        .font(.headline)
    }
}

struct FormFortunateCustomTextField: View {
    let title: String
    @Binding var text: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Label(title, systemImage: icon)
                .font(.caption)
                .foregroundColor(.secondary)
            TextField(title, text: $text)
                .textFieldStyle(FormFortunateCustomTextFieldStyle())
        }
    }
}

struct FormFortunateCustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.purple.opacity(0.3), lineWidth: 1)
            )
    }
}

struct FormFortunateStatField: View {
    let label: String
    @Binding var value: Int
    let systemImage: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Label(label, systemImage: systemImage)
                .font(.caption)
                .foregroundColor(color)
            
            TextField(label, value: $value, format: .number)
                .textFieldStyle(FormFortunateCustomTextFieldStyle())
                .keyboardType(.numberPad)
                .frame(maxWidth: 80)
        }
    }
}

struct FormFortunateKeywordInputField: View {
    @Binding var text: String
    let onCancel: () -> Void
    let onSave: () -> Void
    
    var body: some View {
        HStack {
            TextField("Add Keyword", text: $text)
                .textFieldStyle(FormFortunateCustomTextFieldStyle())
            
            Button(action: onCancel) {
                Image(systemName: "xmark.circle.fill")
                    .imageScale(.large)
                    .foregroundColor(.red)
            }
            
            Button(action: onSave) {
                Image(systemName: "checkmark.circle.fill")
                    .imageScale(.large)
                    .foregroundColor(.green)
            }
        }
    }
}

struct FormFortunateKeywordRow: View {
    let keyword: String
    let isEditing: Bool
    @Binding var tempText: String
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onSave: (String) -> Void
    let onCancel: () -> Void
    
    var body: some View {
        HStack {
            if isEditing {
                TextField("Edit Keyword", text: $tempText)
                    .textFieldStyle(FormFortunateCustomTextFieldStyle())
                
                Button(action: onCancel) {
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.medium)
                        .foregroundColor(.red)
                }
                
                Button {
                    let trimmed = tempText.trimmingCharacters(in: .whitespaces)
                    if !trimmed.isEmpty {
                        onSave(trimmed)
                    }
                } label: {
                    Image(systemName: "checkmark.circle.fill")
                        .imageScale(.medium)
                        .foregroundColor(.green)
                }
            } else {
                Text(keyword)
                    .foregroundColor(.primary)
                Spacer()
                
                Button(action: onEdit) {
                    Image(systemName: "pencil.circle.fill")
                        .imageScale(.medium)
                        .foregroundColor(.blue)
                }
                
                Button(action: onDelete) {
                    Image(systemName: "trash.circle.fill")
                        .imageScale(.medium)
                        .foregroundColor(.red)
                }
            }
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

struct FormFortunateAddButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "plus.circle.fill")
                .imageScale(.large)
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.blue)
        }
    }
}

struct FormFortunateEmptyRetainerSlot: View {
    let index: Int
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                Image(systemName: "person.badge.plus")
                    .font(.title)
                    .foregroundColor(.secondary)
                Text("Add Retainer")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Layout Components
struct TagSizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

extension View {
    func measureTagSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: TagSizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(TagSizePreferenceKey.self, perform: onChange)
    }
}

struct TagFlowView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let data: Data
    let spacing: CGFloat
    let content: (Data.Element) -> Content
    @State private var availableWidth: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.clear
                .frame(height: 1)
                .measureTagSize { size in
                    availableWidth = size.width
                }
            
            TagFlowLayoutView(
                availableWidth: availableWidth,
                data: data,
                spacing: spacing,
                content: content
            )
        }
    }
}

private struct TagFlowLayoutView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let availableWidth: CGFloat
    let data: Data
    let spacing: CGFloat
    let content: (Data.Element) -> Content
    
    var body: some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        var lastRowHeight = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(Array(data.enumerated()), id: \.element) { index, element in
                content(element)
                    .alignmentGuide(.leading) { dimension in
                        if abs(width - dimension.width) > availableWidth {
                            width = 0
                            height -= lastRowHeight + spacing
                            lastRowHeight = 0
                        }
                        let result = width
                        if index == data.count - 1 {
                            width = 0
                        } else {
                            width += dimension.width + spacing
                        }
                        return result
                    }
                    .alignmentGuide(.top) { dimension in
                        let result = height
                        if index == data.count - 1 {
                            height = 0
                        }
                        lastRowHeight = max(lastRowHeight, dimension.height)
                        return result
                    }
            }
        }
    }
}

struct KeywordTag: View {
    let keyword: String
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 6) {
            Text(keyword)
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.secondary)
                    .imageScale(.small)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color(.systemGray6))
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(Color.purple.opacity(0.3), lineWidth: 1)
        )
    }
}

extension View {
    func cardStyle() -> some View {
        self
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color(.systemGray4).opacity(0.3), radius: 10, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.purple.opacity(0.3), lineWidth: 1)
            )
    }
}