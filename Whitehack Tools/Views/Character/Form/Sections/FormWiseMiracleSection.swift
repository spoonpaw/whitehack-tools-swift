import SwiftUI

struct FormWiseMiracleSection: View {
    let characterClass: CharacterClass
    let level: Int
    let willpower: Int
    @Binding var miracleSlots: [WiseMiracleSlot]
    @Environment(\.colorScheme) var colorScheme
    
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
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Slot \(index + 1)")
                                .font(.headline)
                                .foregroundColor(.primary)
                            if index == 0 && extraInactiveMiracles > 0 {
                                Text("(\(extraInactiveMiracles) extra inactive)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.secondary.opacity(0.2))
                                    .cornerRadius(12)
                            }
                            Spacer()
                            if index == 2 {
                                Image(systemName: "sparkles")
                                    .foregroundColor(.purple)
                                    .font(.caption)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 4)
                        
                        if index == 2 { // Level 3 slot can be magic item
                            Toggle(isOn: $miracleSlots[index].isMagicItem) {
                                Label("Magic Item", systemImage: "wand.and.stars")
                                    .foregroundColor(.purple)
                            }
                            .padding(.horizontal)
                            .toggleStyle(SwitchToggleStyle(tint: .purple))
                        }
                        
                        if index == 2 && slot.isMagicItem {
                            VStack(spacing: 12) {
                                TextField("Magic Item Name", text: $miracleSlots[index].magicItemName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.purple.opacity(0.5), lineWidth: 1)
                                    )
                            }
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(colorScheme == .dark ? Color(.systemGray5) : Color(.systemGray6))
                            )
                            .padding(.horizontal)
                        } else {
                            let maxMiracles = index == 0 ? 2 + extraInactiveMiracles : 2
                            ForEach(0..<maxMiracles, id: \.self) { miracleIndex in
                                if miracleIndex < slot.miracles.count {
                                    miracleView(slot.miracles[miracleIndex], slotIndex: index)
                                } else {
                                    emptyMiracleView(slotIndex: index)
                                }
                            }
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
                    .onChange(of: willpower) { _ in
                        if index == 0 {
                            // Remove excess miracles if willpower drops
                            let maxAllowed = 2 + extraInactiveMiracles
                            if slot.miracles.count > maxAllowed {
                                miracleSlots[index].miracles = Array(slot.miracles.prefix(maxAllowed))
                            }
                            // Add empty miracles if needed
                            while miracleSlots[index].miracles.count < maxAllowed {
                                miracleSlots[index].miracles.append(WiseMiracle())
                            }
                        }
                    }
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
    
    private func miracleView(_ miracle: WiseMiracle, slotIndex: Int) -> some View {
        VStack(spacing: 12) {
            TextField("Miracle Name", text: binding(for: miracle).name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(miracle.isActive ? Color.green.opacity(0.5) : Color.secondary.opacity(0.3), lineWidth: 1)
                )
            
            Toggle(isOn: binding(for: miracle).isActive) {
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
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(miracle.isActive ? Color.green.opacity(0.2) : Color.clear, lineWidth: 1)
        )
        .padding(.horizontal)
    }
    
    private func emptyMiracleView(slotIndex: Int) -> some View {
        VStack(spacing: 12) {
            TextField("Miracle Name", text: .constant(""))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disabled(true)
            
            Toggle(isOn: .constant(false)) {
                Label("Active", systemImage: "circle")
                    .foregroundColor(.secondary)
            }
            .toggleStyle(SwitchToggleStyle(tint: .green))
            .disabled(true)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(colorScheme == .dark ? Color(.systemGray5) : Color(.systemGray6))
        )
        .padding(.horizontal)
        .opacity(0.5)
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
        
        // Initialize all miracle slots with the correct number of miracles
        for index in miracleSlots.indices {
            let maxMiracles = index == 0 ? 2 + extraInactiveMiracles : 2
            while miracleSlots[index].miracles.count < maxMiracles {
                miracleSlots[index].miracles.append(WiseMiracle())
            }
        }
    }
}

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
