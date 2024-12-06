import SwiftUICore
import SwiftUI
struct FormStrongCombatSection: View {
    let characterClass: CharacterClass
    let level: Int
    @Binding var strongCombatOptions: StrongCombatOptions
    @Binding var currentConflictLoot: ConflictLoot?
    let availableSlots: Int
    
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
        VStack(alignment: .leading, spacing: 4) {
            Text("Slot \(slotIndex + 1)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            combatOptionMenu(for: slotIndex)
            
            if let option = strongCombatOptions.getOption(at: slotIndex) {
                Text(option.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var combatOptionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Combat Options")
                .font(.headline)
            
            ForEach(0..<availableSlots, id: \.self) { slotIndex in
                combatOptionSlot(at: slotIndex)
            }
        }
        .padding(.vertical, 8)
    }
    
    private var lootHeaderView: some View {
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
    }
    
    private var lootEditorView: some View {
        Group {
            if let loot = currentConflictLoot {
                VStack(alignment: .leading, spacing: 12) {
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
            } else {
                Text("No conflict loot currently held")
                    .foregroundColor(.secondary)
                    .padding(.vertical, 8)
            }
        }
    }
    
    private var conflictLootSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            lootHeaderView
            lootEditorView
        }
        .padding(.vertical, 8)
    }
    
    var body: some View {
        if characterClass == .strong {
            Section {
                VStack(alignment: .leading, spacing: 16) {
                    combatOptionsSection
                    conflictLootSection
                }
            } header: {
                SectionHeader(title: "The Strong", icon: Image(systemName: "figure.strengthtraining.traditional"))
            }
        }
    }
    
    private func addNewLoot() {
        currentConflictLoot = ConflictLoot(keyword: "", type: .special, usesRemaining: 1)
    }
    
    private func removeLoot() {
        currentConflictLoot = nil
    }
}
