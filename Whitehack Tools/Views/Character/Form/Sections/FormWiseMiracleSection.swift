import SwiftUI
import PhosphorSwift

struct FormWiseMiracleSection: View {
    let characterClass: CharacterClass
    let level: Int
    @Binding var willpower: String
    @Binding var useCustomAttributes: Bool
    @Binding var miracleSlots: [WiseMiracleSlot]
    @Environment(\.colorScheme) var colorScheme
    
    private var extraInactiveMiracles: Int {
        print("[WISEFORM] Calculating extra inactive miracles...")
        if useCustomAttributes {
            print("[WISEFORM] Using custom attributes, no extra miracles")
            return 0
        }
        print("[WISEFORM] Willpower value: \(willpower)")
        guard let willpowerValue = Int(willpower) else {
            print("[WISEFORM] Invalid willpower value, no extra miracles")
            return 0
        }
        if willpowerValue >= 16 {
            print("[WISEFORM] Willpower >= 16, adding 2 extra miracles")
            return 2
        } else if willpowerValue >= 14 {
            print("[WISEFORM] Willpower >= 14, adding 1 extra miracle")
            return 1
        }
        print("[WISEFORM] Willpower < 14, no extra miracles")
        return 0
    }
    
    private var slotIndices: [(Int, WiseMiracleSlot)] {
        let zipped = zip(miracleSlots.indices, miracleSlots)
        return Array(zipped.prefix(level))
    }
    
    private var backgroundFillColor: Color {
        #if os(iOS)
        colorScheme == .dark ? Color(uiColor: .systemGray6) : .white
        #else
        colorScheme == .dark ? Color(nsColor: .windowBackgroundColor) : .white
        #endif
    }
    
    private var footerText: String {
        "Level \(level) slot gets \(extraInactiveMiracles) extra inactive miracle\(extraInactiveMiracles == 1 ? "" : "s") (Willpower \(willpower))"
    }
    
    enum MiracleType {
        case base     // Regular miracles from the main list (0-2)
        case additional  // Additional miracles in first/second slot
    }
    
    var body: some View {
        if characterClass == .wise {
            Section {
                ForEach(slotIndices, id: \.0) { index, slot in
                    miracleSlotView(index: index, slot: slot)
                }
            } header: {
                SectionHeader(title: "The Wise", icon: Ph.magicWand.bold)
            } footer: {
                Text(footerText)
            }
        }
    }
    
    private func miracleSlotView(index: Int, slot: WiseMiracleSlot) -> some View {
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
                .fill(backgroundFillColor)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
        )
        .shadow(color: Color.primary.opacity(0.05), radius: 2, x: 0, y: 1)
        .padding(.horizontal, 4)
        .padding(.vertical, 4)
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
        return VStack(spacing: 12) {
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
                .fill({
                    #if os(iOS)
                    return colorScheme == .dark ? Color(uiColor: .systemGray5) : Color(uiColor: .systemGray6)
                    #else
                    return colorScheme == .dark ? Color(nsColor: .controlBackgroundColor) : Color(nsColor: .windowBackgroundColor)
                    #endif
                }())
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
                        print("[WISEFORM] Deactivating all miracles in slot \(index)")
                        
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
        print("\n[WISEFORM] Updating miracle count for slot \(index)...")
        
        // Only slot 0 gets extra miracles from willpower
        let baseMiracleCount = index == 0 ? (2 + extraInactiveMiracles) : 2
        print("[WISEFORM] Slot \(index) should have \(baseMiracleCount) base miracles")
        print("[WISEFORM] Current base miracles: \(miracleSlots[index].baseMiracles.count)")
        
        // Handle base miracles
        while miracleSlots[index].baseMiracles.count < baseMiracleCount {
            print("[WISEFORM] Adding base miracle to slot \(index)")
            miracleSlots[index].baseMiracles.append(WiseMiracle(isAdditional: false))
        }
        if miracleSlots[index].baseMiracles.count > baseMiracleCount {
            print("[WISEFORM] Removing excess base miracles from slot \(index)")
            miracleSlots[index].baseMiracles = Array(miracleSlots[index].baseMiracles.prefix(baseMiracleCount))
        }
        
        // Handle additional miracles
        let totalAdditionalNeeded = miracleSlots[index].additionalMiracleCount
        print("[WISEFORM] Slot \(index) needs \(totalAdditionalNeeded) additional miracles")
        print("[WISEFORM] Current additional miracles: \(miracleSlots[index].additionalMiracles.count)")
        
        if miracleSlots[index].additionalMiracles.count < totalAdditionalNeeded {
            let needToAdd = totalAdditionalNeeded - miracleSlots[index].additionalMiracles.count
            print("[WISEFORM] Adding \(needToAdd) additional miracles to slot \(index)")
            for _ in 0..<needToAdd {
                miracleSlots[index].additionalMiracles.append(WiseMiracle(isAdditional: true))
            }
        } else if miracleSlots[index].additionalMiracles.count > totalAdditionalNeeded {
            print("[WISEFORM] Removing excess additional miracles from slot \(index)")
            miracleSlots[index].additionalMiracles = Array(miracleSlots[index].additionalMiracles.prefix(totalAdditionalNeeded))
        }
        
        print("[WISEFORM] Final counts for slot \(index):")
        print("  - Base miracles: \(miracleSlots[index].baseMiracles.count)")
        print("  - Additional miracles: \(miracleSlots[index].additionalMiracles.count)")
    }
    
    private func initializeSlotsIfNeeded() {
        print("\n[WISEFORM] Initializing miracle slots...")
        print("[WISEFORM] Current slot count: \(miracleSlots.count)")
        
        if miracleSlots.isEmpty {
            print("[WISEFORM] Creating initial 3 miracle slots")
            miracleSlots = Array(repeating: WiseMiracleSlot(), count: 3)
        }
        
        while miracleSlots.count < 3 {
            print("[WISEFORM] Adding missing miracle slot")
            miracleSlots.append(WiseMiracleSlot())
        }
        while miracleSlots.count > 3 {
            print("[WISEFORM] Removing excess miracle slot")
            miracleSlots.removeLast()
        }
        
        print("[WISEFORM] Initializing each slot...")
        for index in miracleSlots.indices {
            print("\n[WISEFORM] Initializing slot \(index):")
            let baseMiracleCount = index == 0 ? (2 + extraInactiveMiracles) : 2
            print("[WISEFORM] Slot \(index) should have \(baseMiracleCount) base miracles")
            print("[WISEFORM] Current base miracles: \(miracleSlots[index].baseMiracles.count)")
            
            while miracleSlots[index].baseMiracles.count < baseMiracleCount {
                print("[WISEFORM] Adding base miracle to slot \(index)")
                miracleSlots[index].baseMiracles.append(WiseMiracle(isAdditional: false))
            }
            if miracleSlots[index].baseMiracles.count > baseMiracleCount {
                print("[WISEFORM] Removing excess base miracles from slot \(index)")
                miracleSlots[index].baseMiracles = Array(miracleSlots[index].baseMiracles.prefix(baseMiracleCount))
            }
            
            let totalAdditionalNeeded = miracleSlots[index].additionalMiracleCount
            print("[WISEFORM] Slot \(index) needs \(totalAdditionalNeeded) additional miracles")
            print("[WISEFORM] Current additional miracles: \(miracleSlots[index].additionalMiracles.count)")
            
            if miracleSlots[index].additionalMiracles.count < totalAdditionalNeeded {
                let needToAdd = totalAdditionalNeeded - miracleSlots[index].additionalMiracles.count
                print("[WISEFORM] Adding \(needToAdd) additional miracles to slot \(index)")
                for _ in 0..<needToAdd {
                    miracleSlots[index].additionalMiracles.append(WiseMiracle(isAdditional: true))
                }
            } else if miracleSlots[index].additionalMiracles.count > totalAdditionalNeeded {
                print("[WISEFORM] Removing excess additional miracles from slot \(index)")
                miracleSlots[index].additionalMiracles = Array(miracleSlots[index].additionalMiracles.prefix(totalAdditionalNeeded))
            }
            
            print("[WISEFORM] Final counts for slot \(index):")
            print("  - Base miracles: \(miracleSlots[index].baseMiracles.count)")
            print("  - Additional miracles: \(miracleSlots[index].additionalMiracles.count)")
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
