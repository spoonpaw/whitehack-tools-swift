import SwiftUI
import PhosphorSwift

// MARK: - Main View
struct DetailWiseMiracleSection: View {
    let character: PlayerCharacter
    @Environment(\.colorScheme) var colorScheme
    
    private var extraInactiveMiracles: Int {
        print("\n[WISEDETAIL] Calculating extra inactive miracles...")
        if character.useCustomAttributes {
            print("[WISEDETAIL] Using custom attributes, no extra miracles")
            return 0
        }
        print("[WISEDETAIL] Willpower value: \(character.willpower)")
        if character.willpower >= 16 {
            print("[WISEDETAIL] Willpower >= 16, adding 2 extra miracles")
            return 2
        } else if character.willpower >= 14 {
            print("[WISEDETAIL] Willpower >= 14, adding 1 extra miracle")
            return 1
        }
        print("[WISEDETAIL] Willpower < 14, no extra miracles")
        return 0
    }
    
    private var availableSlots: Int {
        print("[WISEDETAIL] Calculating available slots...")
        print("[WISEDETAIL] Available slots: \(AdvancementTables.shared.stats(for: character.characterClass, at: character.level).slots)")
        return AdvancementTables.shared.stats(for: character.characterClass, at: character.level).slots
    }
    
    private func initializeSlots() {
        print("\n[WISEDETAIL] Initializing miracle slots...")
        
        // Get number of slots from advancement table
        let slots = availableSlots
        print("[WISEDETAIL] Available slots: \(slots)")
        
        // Initialize slots if needed
        while character.wiseMiracleSlots.count < slots {
            character.wiseMiracleSlots.append(WiseMiracleSlot())
        }
        
        // Update each slot
        for index in 0..<slots {
            print("\n[WISEDETAIL] Updating slot \(index)...")
            
            // Only slot 0 gets extra miracles from willpower
            let baseMiracleCount = index == 0 ? (2 + extraInactiveMiracles) : 2
            print("[WISEDETAIL] Slot \(index) should have \(baseMiracleCount) base miracles")
            
            // Update base miracles
            while character.wiseMiracleSlots[index].baseMiracles.count < baseMiracleCount {
                character.wiseMiracleSlots[index].baseMiracles.append(WiseMiracle(isAdditional: false))
            }
            while character.wiseMiracleSlots[index].baseMiracles.count > baseMiracleCount {
                character.wiseMiracleSlots[index].baseMiracles.removeLast()
            }
            
            // Update additional miracles for slot 0 only
            if index == 0 {
                let additionalCount = character.wiseMiracleSlots[index].additionalMiracleCount
                print("[WISEDETAIL] Slot 0 should have \(additionalCount) additional miracles")
                
                while character.wiseMiracleSlots[index].additionalMiracles.count < additionalCount {
                    character.wiseMiracleSlots[index].additionalMiracles.append(WiseMiracle(isAdditional: true))
                }
                while character.wiseMiracleSlots[index].additionalMiracles.count > additionalCount {
                    character.wiseMiracleSlots[index].additionalMiracles.removeLast()
                }
            } else {
                // Clear any additional miracles from other slots
                if !character.wiseMiracleSlots[index].additionalMiracles.isEmpty {
                    print("[WISEDETAIL] Clearing additional miracles from slot \(index)")
                    character.wiseMiracleSlots[index].additionalMiracles.removeAll()
                }
            }
            
            print("[WISEDETAIL] Slot \(index) final counts:")
            print("  Base miracles: \(character.wiseMiracleSlots[index].baseMiracles.count)")
            print("  Additional miracles: \(character.wiseMiracleSlots[index].additionalMiracles.count)")
        }
    }
    
    private func logMiracleStructure() {
        print("\n[WISEDETAIL] Full Miracle Structure:")
        print("Character Class: \(character.characterClass)")
        print("Character Level: \(character.level)")
        print("Character Willpower: \(character.willpower)")
        print("Available Slots: \(availableSlots)")
        print("Extra Inactive Miracles: \(extraInactiveMiracles)")
        
        for (index, slot) in character.wiseMiracleSlots.prefix(availableSlots).enumerated() {
            print("\nSlot \(index):")
            print("  Base Miracles (\(slot.baseMiracles.count)):")
            for (i, miracle) in slot.baseMiracles.enumerated() {
                print("    \(i): \(miracle.name) (Active: \(miracle.isActive))")
            }
            print("  Additional Miracles (\(slot.additionalMiracles.count)):")
            for (i, miracle) in slot.additionalMiracles.enumerated() {
                print("    \(i): \(miracle.name) (Active: \(miracle.isActive))")
            }
            if slot.isMagicItem {
                print("  Magic Item: \(slot.magicItemName)")
            }
        }
        print("\n")
    }
    
    var body: some View {
        if character.characterClass == .wise {
            VStack(spacing: 12) {
                SectionHeader(title: "The Wise", icon: Ph.sparkle.bold)
                
                VStack(alignment: .leading, spacing: 16) {
                    ClassInfoCard()
                    Divider()
                    ClassFeaturesCard()
                    Divider()
                    MiracleGuidelinesCard()
                    Divider()
                    CostModifiersCard()
                    Divider()
                    HPCostReferenceCard()
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            IconFrame(icon: Ph.magicWand.bold, color: .yellow)
                            Text("Miracles")
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        
                        let _ = initializeSlots() // Force initialization before ForEach
                        ForEach(Array(character.wiseMiracleSlots.prefix(availableSlots).enumerated()), id: \.offset) { index, slot in
                            MiracleSlotCard(
                                index: index,
                                slot: slot,
                                extraInactiveMiracles: index == 0 ? extraInactiveMiracles : 0,
                                colorScheme: colorScheme
                            )
                        }
                    }
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.yellow.opacity(0.1))
                    .groupCardStyle()
                }
                .padding(8)
                .background(.background)
                .cornerRadius(10)
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
            }
        } else {
            EmptyView()
        }
    }
}

// MARK: - Section Header
private struct WiseSectionHeader: View {
    var body: some View {
        SectionHeader(title: "The Wise", icon: Ph.magicWand.bold)
    }
}

// MARK: - Cards
private struct ClassInfoCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                IconFrame(icon: Ph.sparkle.bold, color: .yellow)
                Text("Class Overview")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            Text("Masters of miracles who negotiate with supernatural forces. Whether as cultists, chemists, meta-mathematicians, exorcists, druids, bards, or wizards, they channel powers beyond normal comprehension.")
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.yellow.opacity(0.1))
        .groupCardStyle()
    }
}

private struct ClassFeaturesCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                IconFrame(icon: Ph.star.bold, color: .yellow)
                Text("Class Features")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            WiseMiracleFeatureRow(
                icon: "Sparkles",
                color: .yellow,
                title: "Miracle Slots",
                description: "Each slot holds two miracles—one active, one inactive. Switching takes a day of preparation."
            )
            
            WiseMiracleFeatureRow(
                icon: "Brain",
                color: .yellow,
                title: "Willpower Bonus",
                description: "Level 1 slot gets +1 inactive miracle at WP 13+, +2 at WP 16+."
            )
            
            WiseMiracleFeatureRow(
                icon: "Heart",
                color: .green,
                title: "Supernatural Healing",
                description: "Recover HP at 2× natural rate. Requires treatment to heal beyond 1 HP or for other conditions."
            )
            
            WiseMiracleFeatureRow(
                icon: "Sparkles",
                color: .red,
                title: "Magick Interference",
                description: "Cannot benefit from direct HP restoration (potions, miracles, medicine). Still need treatment for bleeding, illness, poison, etc."
            )
            
            WiseMiracleFeatureRow(
                icon: "Scroll",
                color: .purple,
                title: "Scroll Mastery",
                description: "Can slot scroll effects with trained INT roll. Level must exceed HP cost, glyphs must be 10+ years old."
            )
            
            WiseMiracleFeatureRow(
                icon: "Sword",
                color: .red,
                title: "Combat Penalties",
                description: "-2 AV with non-slotted two-handed weapons."
            )
            
            WiseMiracleFeatureRow(
                icon: "Shield",
                color: .green,
                title: "Magical Defense",
                description: "+2 SV vs magick and mind influencing abilities."
            )
            
            WiseMiracleFeatureRow(
                icon: "Heart",
                color: .red,
                title: "Equipment Cost",
                description: "+2 HP costs when using shields or armor heavier than leather (before doubling)."
            )
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.yellow.opacity(0.1))
        .groupCardStyle()
    }
}

private struct MiracleGuidelinesCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                IconFrame(icon: Ph.book.bold, color: .yellow)
                Text("Miracle Guidelines")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            Text("Miracles are governed by the following rules:")
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
            
            VStack(alignment: .leading, spacing: 12) {
                MiracleRuleCard(
                    title: "HP Cost",
                    text: "Cannot attempt miracles with an initial maximum cost > current HP",
                    icon: "ExclamationMarkTriangle",
                    color: Color.orange
                )
                
                MiracleRuleCard(
                    title: "Level Check",
                    text: "Must save or double cost if HP cost > level",
                    icon: "ExclamationMarkTriangle",
                    color: Color.orange
                )
                
                MiracleRuleCard(
                    title: "Energy Detection",
                    text: "Save once/day (10min) to reduce magnitude by 1",
                    icon: "Bolt",
                    color: Color.yellow
                )
                
                MiracleRuleCard(
                    title: "Crafting",
                    text: "First charge costs 2×, permanent items cost permanent HP",
                    icon: "Hammer",
                    color: Color.purple
                )
            }
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.yellow.opacity(0.1))
        .groupCardStyle()
    }
}

private struct CostModifiersCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                IconFrame(icon: Ph.plusMinus.bold, color: .yellow)
                Text("Cost Modifiers")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            Text("The following factors can modify the cost of a miracle:")
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
            
            VStack(alignment: .leading, spacing: 12) {
                // Increased Cost Factors
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        IconFrame(icon: Ph.arrowUp.bold, color: .red)
                        Text("Increases Cost")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.red.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach([
                            "Peripheral to vocation/wording",
                            "Extra duration/range/area/victims",
                            "No save allowed",
                            "Crafting items (×2 first charge)",
                            "Adding charges (×1 per charge)",
                            "Permanent items (×2 permanent HP)",
                            "Expensive magick type"
                        ], id: \.self) { text in
                            CostModifierRow(text: text, color: .red)
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Decreased Cost Factors
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        IconFrame(icon: Ph.arrowDown.bold, color: .green)
                        Text("Decreases Cost")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.green.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach([
                            "Close to vocation/wording",
                            "Rare/costly ingredients",
                            "Bad side effects for the Wise",
                            "Wise save (fail negates)",
                            "Boosting but addictive drugs",
                            "Cheap magick type",
                            "Extra casting time",
                            "Time/place requirements"
                        ], id: \.self) { text in
                            CostModifierRow(text: text, color: .green)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.yellow.opacity(0.1))
        .groupCardStyle()
    }
}

private struct HPCostReferenceCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                IconFrame(icon: Ph.gauge.bold, color: .yellow)
                Text("HP Cost Magnitudes")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            Text("The following HP cost magnitudes are used for miracles:")
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach([
                    (magnitude: "0", desc: "Trivial/Slotted scroll", examples: "Simple effects with limits", color: Color.green),
                    (magnitude: "1", desc: "Simple magick", examples: "Minor healing, light, unlocking", color: Color.blue),
                    (magnitude: "2", desc: "Standard magick", examples: "Force field, water breathing", color: Color.yellow),
                    (magnitude: "d6", desc: "Major magick", examples: "Teleport, animate dead", color: Color.orange),
                    (magnitude: "2d6", desc: "Powerful magick", examples: "Resurrection, weather control", color: Color.red)
                ], id: \.magnitude) { magnitude in
                    MagnitudeCard(magnitude: magnitude.magnitude, desc: magnitude.desc, examples: magnitude.examples, color: magnitude.color)
                }
            }
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.yellow.opacity(0.1))
        .groupCardStyle()
    }
}

private struct HPCostRow: View {
    let cost: Int
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Text("\(cost)")
                .font(.headline)
                .foregroundColor(.primary)
                .frame(width: 24)
            
            Text(text)
                .font(.body)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

private struct MiracleSlotCard: View {
    let index: Int
    let slot: WiseMiracleSlot
    let extraInactiveMiracles: Int
    let colorScheme: ColorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            slotHeader(index: index, slot: slot, extraInactiveMiracles: extraInactiveMiracles)
            
            if index == 1 && slot.isMagicItem {
                magickItemView()
                magickItemInfoView()
            } else {
                // Base miracles
                ForEach(slot.baseMiracles) { miracle in
                    miracleView(miracle)
                }
                
                // Additional miracles if this is slot 0
                if index == 0 {
                    ForEach(slot.additionalMiracles) { miracle in
                        miracleView(miracle)
                    }
                }
                
                if slot.baseMiracles.isEmpty && (index != 0 || slot.additionalMiracles.isEmpty) {
                    emptyMiracleView()
                }
            }
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        #if os(iOS)
        .background(Color(uiColor: .systemBackground))
        #else
        .background(Color(nsColor: .windowBackgroundColor))
        #endif
        .groupCardStyle()
    }
    
    private func slotHeader(index: Int, slot: WiseMiracleSlot, extraInactiveMiracles: Int) -> some View {
        HStack {
            Text("Slot \(index + 1)")
                .font(.headline)
                .foregroundColor(.purple)
            
            if index == 0 {
                if extraInactiveMiracles > 0 {
                    Text("(+\(extraInactiveMiracles) from Willpower)")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.secondary.opacity(0.2))
                        .cornerRadius(12)
                }
                
                if slot.additionalMiracleCount > 0 {
                    Text("(+\(slot.additionalMiracleCount) Additional)")
                        .font(.body)
                        .foregroundColor(.green)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(12)
                }
            }
            
            Spacer()
            if index == 1 {
                IconFrame(icon: Ph.sparkle.bold, color: .purple)
            }
        }
    }
    
    private func magickItemView() -> some View {
        HStack(spacing: 12) {
            IconFrame(icon: Ph.magicWand.bold, color: .yellow)
                .imageScale(.large)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(slot.magicItemName.isEmpty ? "Unnamed Magick Item" : slot.magicItemName)
                    .foregroundColor(.primary)
                Text("Special equipment that extends HP by character level")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                #if os(iOS)
                .fill(Color(uiColor: .systemGray5))
                #else
                .fill(Color(nsColor: .controlBackgroundColor))
                #endif
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.yellow.opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal)
    }
    
    private func magickItemInfoView() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Magick Item Option")
                .font(.body)
                .foregroundColor(.yellow)
            
            Text("The level 2 slot may hold a magick item—a blackstaff, a talking sword, etc.—instead of miracles. This extends the character's hp by an amount equal to her level. When chosen, any previous wordings tied to the slot are ruined. The slot can only hold a new item if the previous one breaks, which lowers both maximum and current hp.")
                .font(.body)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(8)
        .background(Color.yellow.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private func miracleView(_ miracle: WiseMiracle) -> some View {
        HStack(spacing: 12) {
            IconFrame(icon: miracle.isActive ? Ph.checkCircle.bold : Ph.circle.bold, color: miracle.isActive ? .green : .secondary)
                .imageScale(.large)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(miracle.name.isEmpty ? "Empty Miracle" : miracle.name)
                    .foregroundColor(miracle.isActive ? .primary : .secondary)
                Text(miracle.isActive ? "Active" : "Inactive")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                #if os(iOS)
                .fill(Color(uiColor: .systemGray5))
                #else
                .fill(Color(nsColor: .controlBackgroundColor))
                #endif
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(miracle.isActive ? Color.green.opacity(0.3) : Color.clear, lineWidth: 1)
        )
        .padding(.horizontal)
    }
    
    private func emptyMiracleView() -> some View {
        HStack(spacing: 12) {
            IconFrame(icon: Ph.circle.bold, color: .secondary)
                .font(.system(size: 4))
            Text("Empty Miracle")
                .foregroundColor(.secondary)
            Text("No miracle assigned")
                .font(.body)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                #if os(iOS)
                .fill(Color(uiColor: .systemGray5))
                #else
                .fill(Color(nsColor: .controlBackgroundColor))
                #endif
        )
        .padding(.horizontal)
        .opacity(0.5)
    }
}

// MARK: - Feature Row
struct WiseMiracleFeatureRow: View {
    let icon: String
    let color: Color
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            IconFrame(icon: getPhosphorIcon(for: icon), color: color)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }
    }
    
    private func getPhosphorIcon(for name: String) -> some View {
        switch name {
        case "Heart": return Ph.heart.bold
        case "Sparkles": return Ph.sparkle.bold
        case "Brain": return Ph.brain.bold
        case "Sword": return Ph.sword.bold
        case "Scroll": return Ph.scroll.bold
        case "Shield": return Ph.shield.bold
        case "ExclamationMarkTriangle": return Ph.warning.bold
        case "Bolt": return Ph.lightning.bold
        case "Hammer": return Ph.hammer.bold
        default: return Ph.info.bold
        }
    }
}

// MARK: - Miracle Rule Card
private struct MiracleRuleCard: View {
    let title: String
    let text: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                IconFrame(icon: getPhosphorIcon(for: icon), color: color)
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                Spacer()
            }
            
            Text(text)
                .font(.body)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color.opacity(0.1))
        .groupCardStyle()
    }
    
    private func getPhosphorIcon(for name: String) -> some View {
        switch name {
        case "Heart": return Ph.heart.bold
        case "ExclamationMarkTriangle": return Ph.warning.bold
        case "Bolt": return Ph.lightning.bold
        case "Hammer": return Ph.hammer.bold
        default: return Ph.info.bold
        }
    }
}

// MARK: - Cost Modifier Row
struct CostModifierRow: View {
    let text: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .center, spacing: 6) {
            IconFrame(icon: Ph.circle.bold, color: color.opacity(0.5))
                .font(.system(size: 4))
            Text(text)
                .font(.body)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

// MARK: - Magnitude Card
struct MagnitudeCard: View {
    let magnitude: String
    let desc: String
    let examples: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Text(magnitude)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
                .frame(width: 44, height: 44)
                .background(color.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(desc)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                Text(examples)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        #if os(iOS)
        .background(Color(uiColor: .systemGray6))
        #else
        .background(Color(nsColor: .controlBackgroundColor))
        #endif
        .groupCardStyle()
    }
}

private extension View {
    func groupCardStyle() -> some View {
        self
            #if os(iOS)
            .background(Color(uiColor: .systemBackground))
            #else
            .background(Color(nsColor: .windowBackgroundColor))
            #endif
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}
