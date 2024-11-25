import SwiftUI

struct FormWiseMiracleSection: View {
    let characterClass: CharacterClass
    let level: Int
    let willpower: Int
    @Binding var miracleSlots: [WiseMiracleSlot]
    @Environment(\.colorScheme) var colorScheme
    
    private var extraInactiveMiracles: Int {
        guard level == 1 else { return 0 }
        if willpower >= 16 {
            return 2
        } else if willpower >= 13 {
            return 1
        }
        return 0
    }
    
    enum MiracleType {
        case base     // Regular miracles from the main list (0-2)
        case additional  // Additional miracles in first/second slot
    }
    
    var body: some View {
        if characterClass == .wise {
            Section {
                ForEach(Array(zip(miracleSlots.indices, miracleSlots)).prefix(level), id: \.0) { index, slot in
                    VStack(alignment: .leading, spacing: 12) {
                        slotHeader(index: index)
                        
                        if index == 2 {
                            magicItemSection(index: index, slot: slot)
                        }
                        
                        if !slot.isMagicItem {
                            // Base miracles
                            ForEach(slot.baseMiracles) { miracle in
                                miracleView(miracle, isAdditional: false, slotIndex: index)
                            }
                        }
                        
                        if index == 0 {
                            additionalMiraclesSection(index: index)
                        }
                    }
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(colorScheme == .dark ? Color(.systemGray6) : Color.white)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                    )
                    .shadow(color: Color.primary.opacity(0.05), radius: 2, x: 0, y: 1)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 4)
                }
            } header: {
                Label {
                    Text("Miracles")
                        .font(.headline)
                        .foregroundColor(.primary)
                } icon: {
                    Image(systemName: "sparkles")
                        .foregroundColor(.yellow)
                }
            } footer: {
                if level == 1 {
                    Text("Level 1 slot gets \(extraInactiveMiracles) extra inactive miracle\(extraInactiveMiracles == 1 ? "" : "s") (Willpower \(willpower))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else if level == 3 {
                    Text("Level 3 slot can hold a magic item instead of miracles")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .onAppear {
                initializeSlotsIfNeeded()
            }
        }
    }
    
    private func slotHeader(index: Int) -> some View {
        HStack {
            Text("Slot \(index + 1)")
                .font(.headline)
                .foregroundColor(.primary)
            Spacer()
        }
        .padding(.horizontal)
    }
    
    private func magicItemSection(index: Int, slot: WiseMiracleSlot) -> some View {
        VStack(spacing: 8) {
            Toggle(isOn: $miracleSlots[index].isMagicItem) {
                Label("Magic Item", systemImage: "wand.and.stars")
                    .foregroundColor(.purple)
            }
            .toggleStyle(SwitchToggleStyle(tint: .purple))
            
            if slot.isMagicItem {
                TextField("Magic Item Name", text: $miracleSlots[index].magicItemName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
        .padding(.horizontal)
    }
    
    private func additionalMiraclesSection(index: Int) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Additional Miracles")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            additionalMiraclesContent(index: index)
        }
        .padding(.vertical, 8)
    }
    
    private func additionalMiraclesContent(index: Int) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Toggle(isOn: Binding(
                get: { miracleSlots[index].additionalMiracleCount >= 1 },
                set: { newValue in
                    miracleSlots[index].additionalMiracleCount = newValue ? 1 : 0
                    updateMiracleCount(index: index)
                }
            )) {
                HStack(alignment: .center) {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.purple)
                    Text("First Additional Miracle")
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: .purple))
            .padding(.horizontal)

            if miracleSlots[index].additionalMiracleCount >= 1 {
                // First additional miracle
                if let firstMiracle = miracleSlots[index].additionalMiracles.first {
                    miracleView(firstMiracle, isAdditional: true, slotIndex: index)
                }

                Toggle(isOn: Binding(
                    get: { miracleSlots[index].additionalMiracleCount == 2 },
                    set: { newValue in
                        miracleSlots[index].additionalMiracleCount = newValue ? 2 : 1
                        updateMiracleCount(index: index)
                    }
                )) {
                    HStack(alignment: .center) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.purple)
                        Text("Second Additional Miracle")
                    }
                }
                .toggleStyle(SwitchToggleStyle(tint: .purple))
                .padding(.horizontal)

                // Second additional miracle
                if miracleSlots[index].additionalMiracleCount == 2,
                   miracleSlots[index].additionalMiracles.count > 1 {
                    miracleView(miracleSlots[index].additionalMiracles[1], isAdditional: true, slotIndex: index)
                }
            }
        }
    }
    
    private func miracleView(_ miracle: WiseMiracle, isAdditional: Bool, slotIndex: Int) -> some View {
        VStack(spacing: 12) {
            TextField("Miracle Name", text: binding(for: miracle, isAdditional: isAdditional).name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(miracle.isActive ? Color.green.opacity(0.5) : Color.secondary.opacity(0.3), lineWidth: 1)
                )
            
            Toggle(isOn: binding(for: miracle, isAdditional: isAdditional).isActive) {
                Label("Active", systemImage: miracle.isActive ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(miracle.isActive ? .green : .secondary)
            }
            .toggleStyle(SwitchToggleStyle(tint: .green))
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(colorScheme == .dark ? Color(.systemGray5) : Color(.systemGray6))
        )
        .padding(.horizontal)
    }
    
    private func binding(for miracle: WiseMiracle, isAdditional: Bool) -> WiseMiracleBinding {
        let miracleBinding = Binding(
            get: { miracle },
            set: { newValue in
                if let index = miracleSlots.firstIndex(where: { slot in
                    if isAdditional {
                        return slot.additionalMiracles.contains(where: { $0.id == miracle.id })
                    } else {
                        return slot.baseMiracles.contains(where: { $0.id == miracle.id })
                    }
                }) {
                    // If activating, deactivate ALL other miracles in this slot (both base and additional)
                    if newValue.isActive {
                        print("🎯 Deactivating all miracles in slot \(index)")
                        
                        // Deactivate base miracles
                        for mIndex in miracleSlots[index].baseMiracles.indices {
                            if miracleSlots[index].baseMiracles[mIndex].id != miracle.id {
                                miracleSlots[index].baseMiracles[mIndex].isActive = false
                            }
                        }
                        
                        // Deactivate additional miracles
                        for mIndex in miracleSlots[index].additionalMiracles.indices {
                            if miracleSlots[index].additionalMiracles[mIndex].id != miracle.id {
                                miracleSlots[index].additionalMiracles[mIndex].isActive = false
                            }
                        }
                    }
                    
                    // Update the miracle in the correct array
                    if isAdditional {
                        if let miracleIndex = miracleSlots[index].additionalMiracles.firstIndex(where: { $0.id == miracle.id }) {
                            miracleSlots[index].additionalMiracles[miracleIndex] = newValue
                        }
                    } else {
                        if let miracleIndex = miracleSlots[index].baseMiracles.firstIndex(where: { $0.id == miracle.id }) {
                            miracleSlots[index].baseMiracles[miracleIndex] = newValue
                        }
                    }
                }
            }
        )
        
        return WiseMiracleBinding(miracle: miracleBinding)
    }
    
    private func updateMiracleCount(index: Int) {
        // Calculate base miracle count (2 + any extra from willpower)
        let baseMiracleCount = 2 + extraInactiveMiracles
        
        // Handle base miracles
        while miracleSlots[index].baseMiracles.count < baseMiracleCount {
            miracleSlots[index].baseMiracles.append(WiseMiracle(isAdditional: false))
        }
        if miracleSlots[index].baseMiracles.count > baseMiracleCount {
            miracleSlots[index].baseMiracles = Array(miracleSlots[index].baseMiracles.prefix(baseMiracleCount))
        }
        
        // Handle additional miracles
        let totalAdditionalNeeded = miracleSlots[index].additionalMiracleCount
        if miracleSlots[index].additionalMiracles.count < totalAdditionalNeeded {
            let needToAdd = totalAdditionalNeeded - miracleSlots[index].additionalMiracles.count
            for _ in 0..<needToAdd {
                miracleSlots[index].additionalMiracles.append(WiseMiracle(isAdditional: true))
            }
        } else if miracleSlots[index].additionalMiracles.count > totalAdditionalNeeded {
            miracleSlots[index].additionalMiracles = Array(miracleSlots[index].additionalMiracles.prefix(totalAdditionalNeeded))
        }
    }
    
    private func ensureMiracleExists(index: Int, miracleIndex: Int, isAdditional: Bool) {
        if isAdditional {
            while miracleSlots[index].additionalMiracles.count <= miracleIndex {
                miracleSlots[index].additionalMiracles.append(WiseMiracle(isAdditional: true))
            }
        } else {
            while miracleSlots[index].baseMiracles.count <= miracleIndex {
                miracleSlots[index].baseMiracles.append(WiseMiracle(isAdditional: false))
            }
        }
    }
    
    private func initializeSlotsIfNeeded() {
        if miracleSlots.isEmpty {
            miracleSlots = Array(repeating: WiseMiracleSlot(), count: 3)
        }
        
        while miracleSlots.count < 3 {
            miracleSlots.append(WiseMiracleSlot())
        }
        while miracleSlots.count > 3 {
            miracleSlots.removeLast()
        }
        
        for index in miracleSlots.indices {
            let baseMiracleCount = 2 + extraInactiveMiracles
            while miracleSlots[index].baseMiracles.count < baseMiracleCount {
                miracleSlots[index].baseMiracles.append(WiseMiracle(isAdditional: false))
            }
            if miracleSlots[index].baseMiracles.count > baseMiracleCount {
                miracleSlots[index].baseMiracles = Array(miracleSlots[index].baseMiracles.prefix(baseMiracleCount))
            }
            
            let totalAdditionalNeeded = miracleSlots[index].additionalMiracleCount
            if miracleSlots[index].additionalMiracles.count < totalAdditionalNeeded {
                let needToAdd = totalAdditionalNeeded - miracleSlots[index].additionalMiracles.count
                for _ in 0..<needToAdd {
                    miracleSlots[index].additionalMiracles.append(WiseMiracle(isAdditional: true))
                }
            } else if miracleSlots[index].additionalMiracles.count > totalAdditionalNeeded {
                miracleSlots[index].additionalMiracles = Array(miracleSlots[index].additionalMiracles.prefix(totalAdditionalNeeded))
            }
        }
    }
    
    private func addMiracle(to slot: Int, isAdditional: Bool = false) {
        if isAdditional {
            miracleSlots[slot].additionalMiracles.append(WiseMiracle(isAdditional: true))
        } else {
            miracleSlots[slot].baseMiracles.append(WiseMiracle(isAdditional: false))
        }
    }
}

struct WiseMiracleBinding {
    let name: Binding<String>
    let isActive: Binding<Bool>
    
    init(miracle: Binding<WiseMiracle>) {
        self.name = Binding(
            get: { miracle.wrappedValue.name },
            set: { newValue in
                var updatedMiracle = miracle.wrappedValue
                updatedMiracle.name = newValue
                miracle.wrappedValue = updatedMiracle
            }
        )
        
        self.isActive = Binding(
            get: { miracle.wrappedValue.isActive },
            set: { newValue in
                var updatedMiracle = miracle.wrappedValue
                updatedMiracle.isActive = newValue
                miracle.wrappedValue = updatedMiracle
            }
        )
    }
}
