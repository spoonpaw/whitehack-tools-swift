import SwiftUI

struct FormWiseMiracleSection: View {
    let characterClass: CharacterClass
    let level: Int
    let willpower: Int
    @Binding var miracleSlots: [WiseMiracleSlot]
    
    private var availableSlots: Int {
        guard characterClass == .wise else { return 0 }
        let stats = AdvancementTables.shared.stats(for: characterClass, at: level)
        return stats.slots
    }
    
    private var extraInactiveMiracles: Int {
        guard level == 1 else { return 0 }
        if willpower >= 16 {
            return 2
        } else if willpower >= 13 {
            return 1
        }
        return 0
    }
    
    var body: some View {
        if characterClass == .wise {
            Section {
                ForEach(Array(miracleSlots.enumerated()), id: \.element.id) { index, slot in
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Slot \(index + 1)")
                                .font(.headline)
                            if index == 0 && extraInactiveMiracles > 0 {
                                Text("(\(extraInactiveMiracles) extra inactive)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        if index == 2 { // Level 3 slot can be magic item
                            Toggle("Magic Item", isOn: $miracleSlots[index].isMagicItem)
                        }
                        
                        if index == 2 && slot.isMagicItem {
                            TextField("Magic Item Name", text: $miracleSlots[index].magicItemName)
                        } else {
                            let visibleMiracles = index == 0 ? 
                                Array(slot.miracles.prefix(2 + extraInactiveMiracles)) : 
                                slot.miracles
                            
                            ForEach(visibleMiracles) { miracle in
                                HStack {
                                    TextField("Miracle Name", text: binding(for: miracle).name)
                                    Toggle("Active", isOn: binding(for: miracle).isActive)
                                }
                            }
                            
                            let maxMiracles = index == 0 ? 2 + extraInactiveMiracles : 2
                            if slot.miracles.count < maxMiracles {
                                Button(action: {
                                    addMiracle(to: index)
                                }) {
                                    Label("Add Miracle", systemImage: "plus.circle")
                                }
                            }
                        }
                    }
                    .padding(.vertical, 4)
                    .onChange(of: willpower) { _ in
                        if index == 0 {
                            // Remove excess miracles if willpower drops
                            let maxAllowed = 2 + extraInactiveMiracles
                            if slot.miracles.count > maxAllowed {
                                miracleSlots[index].miracles = Array(slot.miracles.prefix(maxAllowed))
                            }
                        }
                    }
                }
            } header: {
                Label("Miracles", systemImage: "sparkles")
            } footer: {
                if level == 1 {
                    Text("Level 1 slot gets \(extraInactiveMiracles) extra inactive miracle\(extraInactiveMiracles == 1 ? "" : "s") (Willpower \(willpower))")
                } else if level == 3 {
                    Text("Level 3 slot can hold a magic item instead of miracles")
                }
            }
            .onAppear {
                initializeSlotsIfNeeded()
                
                // Clean up any excess miracles in slot 1
                if !miracleSlots.isEmpty {
                    let maxAllowed = 2 + extraInactiveMiracles
                    if miracleSlots[0].miracles.count > maxAllowed {
                        miracleSlots[0].miracles = Array(miracleSlots[0].miracles.prefix(maxAllowed))
                    }
                }
            }
        }
    }
    
    private func binding(for miracle: WiseMiracle) -> WiseMiracleBinding {
        WiseMiracleBinding(
            miracle: Binding(
                get: { miracle },
                set: { newValue in
                    if let slotIndex = miracleSlots.firstIndex(where: { $0.miracles.contains(where: { $0.id == miracle.id }) }),
                       let miracleIndex = miracleSlots[slotIndex].miracles.firstIndex(where: { $0.id == miracle.id }) {
                        miracleSlots[slotIndex].miracles[miracleIndex] = newValue
                    }
                }
            ),
            allMiracles: binding(forSlotContaining: miracle)
        )
    }
    
    private func binding(forSlotContaining miracle: WiseMiracle) -> Binding<[WiseMiracle]> {
        if let slotIndex = miracleSlots.firstIndex(where: { $0.miracles.contains(where: { $0.id == miracle.id }) }) {
            return $miracleSlots[slotIndex].miracles
        }
        return .constant([])
    }
    
    private func addMiracle(to slotIndex: Int) {
        miracleSlots[slotIndex].miracles.append(WiseMiracle())
    }
    
    private func initializeSlotsIfNeeded() {
        // Initialize slots if empty
        if miracleSlots.isEmpty {
            miracleSlots = Array(repeating: WiseMiracleSlot(), count: availableSlots)
        }
        
        // Ensure we have the correct number of slots
        while miracleSlots.count < availableSlots {
            miracleSlots.append(WiseMiracleSlot())
        }
        while miracleSlots.count > availableSlots {
            miracleSlots.removeLast()
        }
    }
}

// Helper struct to manage the relationship between active miracles in a slot
struct WiseMiracleBinding {
    let miracle: Binding<WiseMiracle>
    let allMiracles: Binding<[WiseMiracle]>
    
    var name: Binding<String> {
        Binding(
            get: { miracle.wrappedValue.name },
            set: { miracle.name.wrappedValue = $0 }
        )
    }
    
    var isActive: Binding<Bool> {
        Binding(
            get: { miracle.wrappedValue.isActive },
            set: { newValue in
                if newValue {
                    // Deactivate all other miracles in the slot
                    for index in allMiracles.wrappedValue.indices {
                        if allMiracles.wrappedValue[index].id != miracle.wrappedValue.id {
                            allMiracles[index].isActive.wrappedValue = false
                        }
                    }
                }
                miracle.isActive.wrappedValue = newValue
            }
        )
    }
}
