import SwiftUI
import PhosphorSwift

// MARK: - Standing & Fortune Card
struct FormFortunateStandingCard: View {
    @Binding var standing: String
    @Binding var hasUsedFortune: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            HStack {
                Text("Standing & Fortune")
                    .font(.title3)
                    .fontWeight(.medium)
                Spacer()
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.2))
                        .frame(width: 44, height: 44)
                    Image(systemName: "star.fill")
                        .foregroundColor(.blue)
                        .font(.system(size: 20))
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            // Standing
            VStack(alignment: .leading, spacing: 12) {
                Text("Standing")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                TextField("Enter standing", text: $standing)
                    #if os(iOS)
                    .keyboardType(.numberPad)
                    #endif
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.horizontal)
            
            // Fortune Usage
            VStack(alignment: .leading, spacing: 12) {
                Toggle(isOn: $hasUsedFortune) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Good Fortune")
                            .fontWeight(.medium)
                        Text("Daily power to reroll any roll")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .tint(.blue)
                
                HStack {
                    Image(systemName: hasUsedFortune ? "exclamationmark.triangle.fill" : "checkmark.circle.fill")
                    Text(hasUsedFortune ? "Power has been used today" : "Power is available to use")
                        .font(.caption)
                }
                .foregroundColor(hasUsedFortune ? .red : .green)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.primary.opacity(0.05), radius: 2, x: 0, y: 1)
        .listRowInsets(EdgeInsets())
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .padding(.vertical, 8)
    }
}

// MARK: - Signature Object Card
struct FormFortunateSignatureObjectCard: View {
    @Binding var signatureObject: SignatureObject
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            HStack {
                Text("Signature Object")
                    .font(.title3)
                    .fontWeight(.medium)
                Spacer()
                ZStack {
                    Circle()
                        .fill(Color.orange.opacity(0.2))
                        .frame(width: 44, height: 44)
                    Image(systemName: "crown.fill")
                        .foregroundColor(.orange)
                        .font(.system(size: 20))
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Description")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                TextField("Enter signature object name", text: $signatureObject.name)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.primary.opacity(0.05), radius: 2, x: 0, y: 1)
        .listRowInsets(EdgeInsets())
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .padding(.vertical, 8)
    }
}

// MARK: - Main Form Section
struct FormFortunateSection: View {
    let characterClass: CharacterClass
    let level: Int
    @Binding var fortunateOptions: FortunateOptions
    
    private var stats: CharacterStats {
        AdvancementTables.shared.stats(for: characterClass, at: level)
    }
    
    private var availableSlots: Int {
        guard characterClass == .fortunate else { return 0 }
        return stats.slots
    }
    
    private var displayedRetainers: [Retainer] {
        if fortunateOptions.retainers.count < availableSlots {
            var retainers = fortunateOptions.retainers
            retainers.append(contentsOf: (retainers.count..<availableSlots).map { _ in Retainer() })
            return retainers
        } else {
            return Array(fortunateOptions.retainers.prefix(availableSlots))
        }
    }
    
    var body: some View {
        if characterClass == .fortunate {
            Section {
                VStack(spacing: 16) {
                    // Standing & Fortune Card
                    FormFortunateStandingCard(
                        standing: $fortunateOptions.standing,
                        hasUsedFortune: $fortunateOptions.hasUsedFortune
                    )
                    
                    // Signature Object Card
                    FormFortunateSignatureObjectCard(
                        signatureObject: $fortunateOptions.signatureObject
                    )
                    
                    // Show retainer forms
                    ForEach(Array(displayedRetainers.enumerated()), id: \.element.id) { index, retainer in
                        RetainerView(slotNumber: index + 1, retainer: binding(for: index))
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .padding(.vertical, 8)
                    }
                }
                .padding(20)
                .background(Color.purple.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.purple.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: Color.primary.opacity(0.05), radius: 2, x: 0, y: 1)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .padding(.vertical, 8)
            } header: {
                SectionHeader(title: "The Fortunate", icon: Ph.crown.bold)
            }
            .onChange(of: level) { _ in
                // Update the actual retainers array when level changes
                fortunateOptions.retainers = displayedRetainers
            }
        }
    }
    
    private func binding(for index: Int) -> Binding<Retainer> {
        Binding(
            get: { 
                // Always use displayedRetainers to ensure we have the right number
                displayedRetainers[index]
            },
            set: { newValue in
                var updated = displayedRetainers
                updated[index] = newValue
                fortunateOptions.retainers = updated
            }
        )
    }
}

// MARK: - Supporting Views

struct RetainerHPControl: View {
    @Binding var currentHP: Int
    @Binding var maxHP: Int
    @FocusState private var focusedField: CharacterFormView.Field?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Hit Points")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack(spacing: 8) {
                // Current HP
                VStack(alignment: .leading, spacing: 5) {
                    Text("Current")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    HStack(spacing: 8) {
                        Button(action: {
                            currentHP = max(-9999, currentHP - 1)
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.red)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        
                        NumericTextField(
                            text: Binding(
                                get: { String(currentHP) },
                                set: { 
                                    let newValue = Int($0) ?? 0
                                    // Don't allow current HP to exceed max HP
                                    if newValue > maxHP {
                                        currentHP = maxHP
                                    } else {
                                        currentHP = newValue
                                    }
                                }
                            ),
                            field: .currentHP,
                            minValue: -9999,
                            maxValue: maxHP,
                            focusedField: $focusedField
                        )
                        .frame(maxWidth: .infinity)
                        
                        Button(action: {
                            let newValue = currentHP + 1
                            if newValue <= maxHP {
                                currentHP = min(9999, newValue)
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.green)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
                
                // Max HP
                VStack(alignment: .leading, spacing: 5) {
                    Text("Maximum")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    HStack(spacing: 8) {
                        Button(action: {
                            maxHP = max(1, maxHP - 1)
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.red)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        
                        NumericTextField(
                            text: Binding(
                                get: { String(maxHP) },
                                set: { 
                                    let newValue = max(1, Int($0) ?? 1)
                                    maxHP = newValue
                                    // If current HP is higher than new max HP, reduce it
                                    if currentHP > newValue {
                                        currentHP = newValue
                                    }
                                }
                            ),
                            field: .maxHP,
                            minValue: 1,
                            maxValue: 9999,
                            focusedField: $focusedField
                        )
                        .frame(maxWidth: .infinity)
                        
                        Button(action: {
                            maxHP = min(9999, maxHP + 1)
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.green)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
            }
        }
    }
}

struct RetainerBasicInfo: View {
    @Binding var retainer: Retainer
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            FormFortunateSectionHeader(title: "Basic Information", icon: Image(systemName: "person.text.rectangle.fill"))
            
            HStack(spacing: 12) {
                FormFortunateCustomTextField(title: "Name", text: $retainer.name, icon: "person.fill")
                FormFortunateCustomTextField(title: "Type", text: $retainer.type, icon: "tag.fill")
            }
        }
    }
}

struct RetainerCombatStats: View {
    @Binding var retainer: Retainer
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            FormFortunateSectionHeader(title: "Combat Stats", icon: Image(systemName: "shield.lefthalf.filled"))
            
            RetainerHPControl(currentHP: $retainer.currentHP, maxHP: $retainer.maxHP)
            
            HStack(spacing: 16) {
                FormFortunateStatField(label: "HD", value: $retainer.hitDice, systemImage: "heart.fill", color: .red)
                FormFortunateStatField(label: "DF", value: $retainer.defenseFactor, systemImage: "shield.fill", color: .blue)
                FormFortunateStatField(label: "MV", value: $retainer.movement, systemImage: "figure.walk", color: .green)
            }
        }
    }
}

struct RetainerKeywords: View {
    @Binding var retainer: Retainer
    @Binding var isAddingKeyword: Bool
    @Binding var newKeywordText: String
    
    var body: some View {
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
                let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 3)
                LazyVGrid(columns: columns, alignment: .leading, spacing: 8) {
                    ForEach(retainer.keywords, id: \.self) { keyword in
                        KeywordTag(keyword: keyword) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                retainer.keywords.removeAll { $0 == keyword }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct RetainerNotes: View {
    @Binding var notes: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            FormFortunateSectionHeader(title: "Notes", icon: Image(systemName: "note.text"))
            
            TextEditor(text: $notes)
                .frame(height: 60)
                .padding(8)
                .background(Color.systemBackground)
                .cornerRadius(8)
        }
    }
}

struct RetainerView: View {
    let slotNumber: Int
    @Binding var retainer: Retainer
    @State private var isAddingKeyword = false
    @State private var newKeywordText = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "person.fill")
                        .font(.headline)
                        .foregroundColor(.purple)
                    Text("Retainer #\(slotNumber)")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                Spacer()
            }
            .padding()
            
            // Content
            VStack(spacing: 20) {
                RetainerBasicInfo(retainer: $retainer)
                RetainerCombatStats(retainer: $retainer)
                RetainerNotes(notes: $retainer.notes)
                RetainerKeywords(
                    retainer: $retainer,
                    isAddingKeyword: $isAddingKeyword,
                    newKeywordText: $newKeywordText
                )
            }
            .padding()
            .background(Color.systemBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
            )
        }
    }
}

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
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .imageScale(.small)
                    .foregroundColor(.secondary)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            TextField("", text: $text)
                .textFieldStyle(.roundedBorder)
                .font(.system(.body, design: .rounded))
        }
    }
}

struct FormFortunateStatField: View {
    let label: String
    @Binding var value: Int
    let systemImage: String
    let color: Color
    @FocusState private var focusedField: CharacterFormView.Field?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: systemImage)
                    .imageScale(.small)
                    .foregroundColor(color)
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            NumericTextField(
                text: Binding(
                    get: { String(value) },
                    set: { value = Int($0) ?? (label == "HD" ? 1 : 0) }  // Default to 1 for HD, 0 for others
                ),
                field: .currentHP,
                minValue: {
                    switch label {
                    case "HD": return 1   // HD starts at 1
                    case "DF", "MV": return 0  // DF and MV start at 0
                    default: return 0
                    }
                }(),
                maxValue: {
                    switch label {
                    case "HD", "DF": return 99   // HD and DF max at 99
                    case "MV": return 999        // MV max at 999
                    default: return 9999         // Others higher
                    }
                }(),
                focusedField: $focusedField
            )
            .frame(width: 60)
        }
    }
}

struct FormFortunateKeywordInputField: View {
    @Binding var text: String
    let onCancel: () -> Void
    let onSave: () -> Void
    
    var body: some View {
        HStack {
            TextField("Enter keyword", text: $text)
                .textFieldStyle(.roundedBorder)
                .font(.system(.body, design: .rounded))
            
            Button(action: onCancel) {
                Image(systemName: "xmark.circle.fill")
                    .imageScale(.medium)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.red)
            }
            .buttonStyle(BorderlessButtonStyle())
            
            Button(action: onSave) {
                Image(systemName: "checkmark.circle.fill")
                    .imageScale(.medium)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.green)
            }
            .buttonStyle(BorderlessButtonStyle())
            .disabled(text.trimmingCharacters(in: .whitespaces).isEmpty)
        }
        .padding(8)
        .background(Color.systemBackground)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
        )
    }
}

struct KeywordTag: View {
    let keyword: String
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Text(keyword)
                .font(.system(.subheadline, design: .rounded))
            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .imageScale(.small)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.red)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.systemBackground)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
        )
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

extension View {
    func cardStyle() -> some View {
        self
            .padding()
            .background(Color.systemBackground)
            .cornerRadius(10)
            .shadow(radius: 2)
    }
}

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