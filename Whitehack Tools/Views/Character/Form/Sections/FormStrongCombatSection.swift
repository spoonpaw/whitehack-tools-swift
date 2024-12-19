import SwiftUICore
import SwiftUI
import PhosphorSwift

struct FormStrongCombatSection: View {
    let characterClass: CharacterClass
    let level: Int
    @Binding var strongCombatOptions: StrongCombatOptions
    @Binding var currentConflictLoot: ConflictLoot?
    
    private var availableSlots: Int {
        AdvancementTables.shared.stats(for: characterClass, at: level).slots
    }
    
    @Environment(\.colorScheme) var colorScheme
    
    private var backgroundColor: Color {
        #if os(iOS)
        colorScheme == .dark ? Color(uiColor: .systemGray6) : .white
        #else
        colorScheme == .dark ? Color(nsColor: .windowBackgroundColor) : .white
        #endif
    }
    
    private var cardShadow: Color {
        #if os(iOS)
        colorScheme == .dark ? Color.black.opacity(0.3) : Color.black.opacity(0.1)
        #else
        colorScheme == .dark ? Color.black.opacity(0.3) : Color.black.opacity(0.1)
        #endif
    }
    
    private func combatOptionMenu(for slotIndex: Int) -> some View {
        Menu {
            Button("None") {
                strongCombatOptions.setOption(nil, at: slotIndex)
            }
            
            ForEach(StrongCombatOption.allCases) { option in
                if !strongCombatOptions.isActive(option) || strongCombatOptions.getOption(at: slotIndex) == option {
                    Button(option.name) {
                        strongCombatOptions.setOption(option, at: slotIndex)
                    }
                }
            }
        } label: {
            HStack {
                Text(strongCombatOptions.getOption(at: slotIndex)?.name ?? "Select Option")
                    .foregroundColor(strongCombatOptions.getOption(at: slotIndex) == nil ? .secondary : .primary)
                Spacer()
                Image(systemName: "chevron.up.chevron.down")
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background({
                #if os(iOS)
                Color(uiColor: .systemBackground)
                #else
                Color(nsColor: .windowBackgroundColor)
                #endif
            }())
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke({
                        #if os(iOS)
                        Color(uiColor: .systemGray4)
                        #else
                        Color(nsColor: .separatorColor)
                        #endif
                    }(), lineWidth: 1)
            )
        }
    }
    
    private func combatOptionSlot(at slotIndex: Int) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "shield.fill")
                    .foregroundStyle(.secondary)
                Text("Slot \(slotIndex + 1)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            combatOptionMenu(for: slotIndex)
            
            if let option = strongCombatOptions.getOption(at: slotIndex) {
                HStack(alignment: .top, spacing: 4) {
                    Image(systemName: "info.circle.fill")
                        .foregroundStyle(.secondary)
                    Text(option.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 4)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
    }
    
    private var combatOptionsSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Label {
                Text("Combat Options")
                    .font(.headline)
            } icon: {
                IconFrame(icon: Ph.sword.bold, color: .secondary)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            
            VStack(alignment: .leading, spacing: 16) {
                ForEach(0..<availableSlots, id: \.self) { slotIndex in
                    combatOptionSlot(at: slotIndex)
                    
                    if slotIndex < availableSlots - 1 {
                        Divider()
                            .padding(.horizontal, 16)
                    }
                }
            }
        }
    }
    
    private var lootHeaderView: some View {
        HStack {
            if currentConflictLoot == nil {
                Text("No conflict loot currently held")
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(.horizontal, 16)
    }
    
    private var lootEditorView: some View {
        Group {
            if let loot = currentConflictLoot {
                VStack(alignment: .leading, spacing: 16) {
                    TextField("Keyword", text: Binding(
                        get: { loot.keyword },
                        set: { currentConflictLoot?.keyword = $0 }
                    ))
                    .textFieldStyle(.roundedBorder)
                    
                    Picker("Type", selection: Binding(
                        get: { loot.type },
                        set: { currentConflictLoot?.type = $0 }
                    )) {
                        ForEach(ConflictLootType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Stepper("Uses Remaining: \(loot.usesRemaining)", value: Binding(
                        get: { loot.usesRemaining },
                        set: { currentConflictLoot?.usesRemaining = $0 }
                    ), in: 0...level)
                    
                    Button(role: .destructive, action: removeLoot) {
                        Label("Remove Loot", systemImage: "trash")
                    }
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
            }
        }
    }
    
    private var conflictLootSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Label {
                HStack {
                    Text("Current Conflict Loot")
                        .font(.headline)
                    Spacer()
                    if currentConflictLoot == nil {
                        Button(action: addNewLoot) {
                            Label("Add Loot", systemImage: "plus.circle.fill")
                        }
                    }
                }
            } icon: {
                Image(systemName: "bag.fill")
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            
            VStack(alignment: .leading, spacing: 16) {
                lootHeaderView
                lootEditorView
            }
        }
    }
    
    var body: some View {
        if characterClass == .strong {
            VStack(spacing: 16) {
                // Header
                SectionHeader(title: "The Strong", icon: Image(systemName: "figure.strengthtraining.traditional"))
                
                // Main content card
                GroupBox {
                    VStack(alignment: .leading, spacing: 32) {
                        combatOptionsSection
                        Divider()
                            .padding(.horizontal, 16)
                        conflictLootSection
                    }
                    .padding(.vertical, 16)
                }
                .background(backgroundColor)
                .cornerRadius(12)
                .shadow(color: cardShadow, radius: 8, x: 0, y: 2)
            }
        }
    }
    
    private func addNewLoot() {
        currentConflictLoot = ConflictLoot()
    }
    
    private func removeLoot() {
        currentConflictLoot = nil
    }
}
