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
    
    var body: some View {
        if characterClass == .fortunate {
            // MARK: - Standing & Fortune
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    // Standing
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Noble Standing")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        TextField("e.g., Reincarnated Master, Royal Heir", text: $fortunateOptions.standing)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    Divider()
                    
                    // Fortune Usage
                    Toggle(isOn: $fortunateOptions.hasUsedFortune) {
                        Text("Good Fortune")
                            .font(.headline)
                    }
                    .tint(.purple)
                    
                    Text("Once per game session major fortune usage")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Image(systemName: fortunateOptions.hasUsedFortune ? "xmark.circle.fill" : "checkmark.circle.fill")
                            .foregroundColor(fortunateOptions.hasUsedFortune ? .red : .green)
                        Text(fortunateOptions.hasUsedFortune ? "Fortune has been used this session" : "Fortune is available")
                            .font(.caption)
                            .foregroundColor(fortunateOptions.hasUsedFortune ? .red : .green)
                    }
                }
            } header: {
                Label("Noble Status", systemImage: "crown.fill")
            }
            
            // MARK: - Signature Object
            Section {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Object Name")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    TextField("Enter signature object name", text: $fortunateOptions.signatureObject.name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            } header: {
                Label("Signature Object", systemImage: "sparkles")
            } footer: {
                Text("Your signature object has plot immunity and cannot be lost or destroyed without your consent.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // MARK: - Retainers
            Section {
                ForEach(0..<availableRetainers, id: \.self) { index in
                    if index < fortunateOptions.retainers.count {
                        RetainerFormView(retainer: binding(for: index))
                            .padding(.vertical, 4)
                        if index < availableRetainers - 1 {
                            Divider()
                        }
                    } else {
                        // Empty retainer slot with add button
                        HStack {
                            Text("Empty Retainer Slot \(index + 1)")
                                .foregroundColor(.secondary)
                            Spacer()
                            Button {
                                withAnimation(.easeInOut) {
                                    fortunateOptions.retainers.append(Retainer())
                                }
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .imageScale(.large)
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.vertical, 4)
                        if index < availableRetainers - 1 {
                            Divider()
                        }
                    }
                }
            } header: {
                Label("Retainers (\(fortunateOptions.retainers.count)/\(availableRetainers))", systemImage: "person.2.fill")
            } footer: {
                Text("Retainers grow in strength as you level up.")
                    .font(.caption)
                    .foregroundColor(.secondary)
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

struct RetainerFormView: View {
    @Binding var retainer: Retainer
    @State private var isAddingKeyword = false
    @State private var editingKeywordIndex: Int? = nil
    @State private var tempKeywordText = ""
    @State private var newKeywordText = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Basic Info
            VStack(alignment: .leading, spacing: 4) {
                Text("Basic Information")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 12) {
                    TextField("Name", text: $retainer.name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Type", text: $retainer.type)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            
            // Stats
            VStack(alignment: .leading, spacing: 4) {
                Text("Combat Stats")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 12) {
                    StatField(label: "HD", value: $retainer.hitDice, systemImage: "heart.fill")
                    StatField(label: "DF", value: $retainer.defenseFactor, systemImage: "shield.fill")
                    StatField(label: "MV", value: $retainer.movement, systemImage: "figure.walk")
                }
            }
            
            // Keywords
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Keywords")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    if !isAddingKeyword {
                        Button {
                            withAnimation(.easeInOut) {
                                isAddingKeyword = true
                                newKeywordText = ""
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
                
                if isAddingKeyword {
                    HStack {
                        TextField("Add Keyword", text: $newKeywordText)
                            .textFieldStyle(.roundedBorder)
                        
                        Button {
                            withAnimation(.easeInOut) {
                                newKeywordText = ""
                                isAddingKeyword = false
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
                                let trimmed = newKeywordText.trimmingCharacters(in: .whitespaces)
                                if !trimmed.isEmpty {
                                    retainer.keywords.append(trimmed)
                                }
                                newKeywordText = ""
                                isAddingKeyword = false
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
                
                if !retainer.keywords.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(Array(retainer.keywords.enumerated()), id: \.element) { index, keyword in
                            HStack {
                                if editingKeywordIndex == index {
                                    TextField("Edit Keyword", text: $tempKeywordText)
                                        .textFieldStyle(.roundedBorder)
                                        .onAppear { tempKeywordText = keyword }
                                    
                                    Button {
                                        withAnimation(.easeInOut) {
                                            editingKeywordIndex = nil
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
                                            let trimmed = tempKeywordText.trimmingCharacters(in: .whitespaces)
                                            if !trimmed.isEmpty {
                                                retainer.keywords[index] = trimmed
                                            }
                                            editingKeywordIndex = nil
                                        }
                                    } label: {
                                        Image(systemName: "checkmark.circle.fill")
                                            .imageScale(.medium)
                                            .symbolRenderingMode(.hierarchical)
                                            .foregroundColor(.green)
                                    }
                                    .buttonStyle(BorderlessButtonStyle())
                                } else {
                                    Text(keyword)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Button {
                                        withAnimation(.easeInOut) {
                                            editingKeywordIndex = index
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
                                            guard index < retainer.keywords.count else { return }
                                            retainer.keywords.remove(at: index)
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
                    .frame(maxHeight: retainer.keywords.count > 3 ? 150 : nil)
                    .animation(.easeInOut, value: retainer.keywords)
                }
            }
        }
    }
}

struct StatField: View {
    let label: String
    @Binding var value: Int
    let systemImage: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Label(label, systemImage: systemImage)
                .font(.caption)
                .foregroundColor(.secondary)
            TextField(label, value: $value, format: .number)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .frame(maxWidth: 80)
        }
    }
}

struct KeywordBubble: View {
    let keyword: String
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Text(keyword)
                .font(.caption)
            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.secondary.opacity(0.2))
        .cornerRadius(12)
    }
}

struct FlowingKeywords: View {
    @Binding var keywords: [String]
    @State private var newKeyword = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Existing keywords
            FlexibleView(data: keywords, spacing: 8) { keyword in
                KeywordBubble(keyword: keyword) {
                    if let index = keywords.firstIndex(of: keyword) {
                        keywords.remove(at: index)
                    }
                }
            }
            
            // Add new keyword
            TextField("Add keyword (Return or comma to add)", text: $newKeyword, onCommit: addKeyword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: newKeyword) { value in
                    if value.hasSuffix(",") {
                        addKeyword()
                    }
                }
        }
    }
    
    private func addKeyword() {
        let keyword = newKeyword.trimmingCharacters(in: .whitespacesAndNewlines)
            .trimmingCharacters(in: CharacterSet(charactersIn: ","))
        if !keyword.isEmpty && !keywords.contains(keyword) {
            keywords.append(keyword)
        }
        newKeyword = ""
    }
}

struct FlexibleView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let data: Data
    let spacing: CGFloat
    let content: (Data.Element) -> Content
    @State private var availableWidth: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.clear
                .frame(height: 1)
                .readSize { size in
                    availableWidth = size.width
                }
            
            FlexibleInnerView(
                availableWidth: availableWidth,
                data: data,
                spacing: spacing,
                content: content
            )
        }
    }
}

struct FlexibleInnerView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let availableWidth: CGFloat
    let data: Data
    let spacing: CGFloat
    let content: (Data.Element) -> Content
    @State private var elementsSize: [Data.Element: CGSize] = [:]
    
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
                            height -= lastRowHeight
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
                        return result
                    }
                    .readSize { size in
                        elementsSize[element] = size
                        if lastRowHeight < size.height {
                            lastRowHeight = size.height
                        }
                    }
            }
        }
    }
}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}
