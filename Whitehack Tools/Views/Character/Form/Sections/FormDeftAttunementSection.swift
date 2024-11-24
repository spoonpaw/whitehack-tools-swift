import SwiftUI

struct FormDeftAttunementSection: View {
    let characterClass: CharacterClass
    let level: Int
    @Binding var attunementSlots: [AttunementSlot]
    @Binding var hasUsedAttunementToday: Bool
    
    private var availableSlots: Int {
        AdvancementTables.shared.stats(for: characterClass, at: level).slots
    }
    
    var body: some View {
        if characterClass == .deft {
            Section(header: Text("Deft Attunements")) {
                ForEach(0..<availableSlots, id: \.self) { index in
                    AttunementSlotView(
                        index: index,
                        attunementSlots: $attunementSlots
                    )
                    .padding(.vertical, 8)
                }
            }
        }
    }
}

private struct AttunementSlotView: View {
    let index: Int
    @Binding var attunementSlots: [AttunementSlot]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Slot Header
            HStack {
                Image(systemName: "sparkles")
                    .foregroundColor(.purple)
                Text("Slot \(index + 1)")
                    .font(.headline)
                    .foregroundColor(.purple)
            }
            .padding(.bottom, 4)
            
            // Primary Attunement
            VStack(alignment: .leading, spacing: 12) {
                Text("Primary Attunement")
                    .font(.subheadline.bold())
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 8) {
                    TextField("Name", text: Binding(
                        get: { index < attunementSlots.count ? attunementSlots[index].primaryAttunement.name : "" },
                        set: { 
                            if index >= attunementSlots.count {
                                attunementSlots.append(AttunementSlot())
                            }
                            attunementSlots[index].primaryAttunement.name = $0
                        }
                    ))
                    .textFieldStyle(.roundedBorder)
                    
                    Picker("Type", selection: Binding(
                        get: { index < attunementSlots.count ? attunementSlots[index].primaryAttunement.type : .item },
                        set: { 
                            if index >= attunementSlots.count {
                                attunementSlots.append(AttunementSlot())
                            }
                            attunementSlots[index].primaryAttunement.type = $0
                        }
                    )) {
                        ForEach(AttunementType.allCases, id: \.self) { type in
                            Label(
                                type.rawValue.capitalized,
                                systemImage: typeIcon(for: type)
                            ).tag(type)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    HStack(spacing: 20) {
                        Toggle("Active", isOn: Binding(
                            get: { index < attunementSlots.count ? attunementSlots[index].primaryAttunement.isActive : false },
                            set: { 
                                if index >= attunementSlots.count {
                                    attunementSlots.append(AttunementSlot())
                                }
                                attunementSlots[index].primaryAttunement.isActive = $0
                                // Ensure only one attunement is active
                                if $0 {
                                    attunementSlots[index].secondaryAttunement.isActive = false
                                }
                            }
                        ))
                        
                        Toggle("Lost", isOn: Binding(
                            get: { index < attunementSlots.count ? attunementSlots[index].primaryAttunement.isLost : false },
                            set: { 
                                if index >= attunementSlots.count {
                                    attunementSlots.append(AttunementSlot())
                                }
                                attunementSlots[index].primaryAttunement.isLost = $0
                            }
                        ))
                    }
                }
                .padding(12)
                .background(Color.blue.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            // Secondary Attunement
            VStack(alignment: .leading, spacing: 12) {
                Text("Secondary Attunement")
                    .font(.subheadline.bold())
                    .foregroundColor(.purple)
                
                VStack(alignment: .leading, spacing: 8) {
                    TextField("Name", text: Binding(
                        get: { index < attunementSlots.count ? attunementSlots[index].secondaryAttunement.name : "" },
                        set: { 
                            if index >= attunementSlots.count {
                                attunementSlots.append(AttunementSlot())
                            }
                            attunementSlots[index].secondaryAttunement.name = $0
                        }
                    ))
                    .textFieldStyle(.roundedBorder)
                    
                    Picker("Type", selection: Binding(
                        get: { index < attunementSlots.count ? attunementSlots[index].secondaryAttunement.type : .item },
                        set: { 
                            if index >= attunementSlots.count {
                                attunementSlots.append(AttunementSlot())
                            }
                            attunementSlots[index].secondaryAttunement.type = $0
                        }
                    )) {
                        ForEach(AttunementType.allCases, id: \.self) { type in
                            Label(
                                type.rawValue.capitalized,
                                systemImage: typeIcon(for: type)
                            ).tag(type)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    HStack(spacing: 20) {
                        Toggle("Active", isOn: Binding(
                            get: { index < attunementSlots.count ? !attunementSlots[index].primaryAttunement.isActive : false },
                            set: { 
                                if index >= attunementSlots.count {
                                    attunementSlots.append(AttunementSlot())
                                }
                                attunementSlots[index].primaryAttunement.isActive = !$0
                            }
                        ))
                        
                        Toggle("Lost", isOn: Binding(
                            get: { index < attunementSlots.count ? attunementSlots[index].secondaryAttunement.isLost : false },
                            set: { 
                                if index >= attunementSlots.count {
                                    attunementSlots.append(AttunementSlot())
                                }
                                attunementSlots[index].secondaryAttunement.isLost = $0
                            }
                        ))
                    }
                }
                .padding(12)
                .background(Color.purple.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            // Daily Power Usage
            Toggle("Daily Power Used", isOn: Binding(
                get: { index < attunementSlots.count ? attunementSlots[index].hasUsedDailyPower : false },
                set: { 
                    if index >= attunementSlots.count {
                        attunementSlots.append(AttunementSlot())
                    }
                    attunementSlots[index].hasUsedDailyPower = $0
                }
            ))
            .foregroundColor(.orange)
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.purple.opacity(0.2), lineWidth: 1)
        )
    }
    
    private func typeIcon(for type: AttunementType) -> String {
        switch type {
        case .teacher: return "person.fill.checkmark"
        case .item: return "sparkles.square.filled.on.square"
        case .vehicle: return "car.fill"
        case .pet: return "pawprint.fill"
        case .place: return "mappin.circle.fill"
        }
    }
}