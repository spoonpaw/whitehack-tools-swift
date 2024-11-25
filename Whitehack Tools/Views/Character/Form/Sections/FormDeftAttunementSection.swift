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
                    
                    HStack(spacing: 8) {
                        Text("Type")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Picker("", selection: Binding(
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
                        .labelsHidden()
                        Spacer()
                    }
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Active")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Toggle("", isOn: Binding(
                                get: { index < attunementSlots.count ? attunementSlots[index].primaryAttunement.isActive : false },
                                set: { 
                                    if index >= attunementSlots.count {
                                        attunementSlots.append(AttunementSlot())
                                    }
                                    attunementSlots[index].primaryAttunement.isActive = $0
                                    // Ensure only one attunement is active
                                    if $0 {
                                        attunementSlots[index].secondaryAttunement.isActive = false
                                        if attunementSlots[index].hasTertiaryAttunement {
                                            attunementSlots[index].tertiaryAttunement.isActive = false
                                        }
                                        if attunementSlots[index].hasQuaternaryAttunement {
                                            attunementSlots[index].quaternaryAttunement.isActive = false
                                        }
                                    }
                                }
                            ))
                            .labelsHidden()
                        }
                        .frame(maxWidth: .infinity)
                        
                        VStack(alignment: .leading) {
                            Text("Lost")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Toggle("", isOn: Binding(
                                get: { index < attunementSlots.count ? attunementSlots[index].primaryAttunement.isLost : false },
                                set: { 
                                    if index >= attunementSlots.count {
                                        attunementSlots.append(AttunementSlot())
                                    }
                                    attunementSlots[index].primaryAttunement.isLost = $0
                                }
                            ))
                            .labelsHidden()
                        }
                        .frame(maxWidth: .infinity)
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
                    
                    HStack(spacing: 8) {
                        Text("Type")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Picker("", selection: Binding(
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
                        .labelsHidden()
                        Spacer()
                    }
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Active")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Toggle("", isOn: Binding(
                                get: { index < attunementSlots.count ? attunementSlots[index].secondaryAttunement.isActive : false },
                                set: { 
                                    if index >= attunementSlots.count {
                                        attunementSlots.append(AttunementSlot())
                                    }
                                    attunementSlots[index].secondaryAttunement.isActive = $0
                                    // Ensure only one attunement is active
                                    if $0 {
                                        attunementSlots[index].primaryAttunement.isActive = false
                                        if attunementSlots[index].hasTertiaryAttunement {
                                            attunementSlots[index].tertiaryAttunement.isActive = false
                                        }
                                        if attunementSlots[index].hasQuaternaryAttunement {
                                            attunementSlots[index].quaternaryAttunement.isActive = false
                                        }
                                    }
                                }
                            ))
                            .labelsHidden()
                        }
                        .frame(maxWidth: .infinity)
                        
                        VStack(alignment: .leading) {
                            Text("Lost")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Toggle("", isOn: Binding(
                                get: { index < attunementSlots.count ? attunementSlots[index].secondaryAttunement.isLost : false },
                                set: { 
                                    if index >= attunementSlots.count {
                                        attunementSlots.append(AttunementSlot())
                                    }
                                    attunementSlots[index].secondaryAttunement.isLost = $0
                                }
                            ))
                            .labelsHidden()
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(12)
                .background(Color.purple.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            // Tertiary Attunement (only for first slot)
            if index == 0 {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Tertiary Attunement")
                            .font(.subheadline.bold())
                            .foregroundColor(.green)
                        Spacer()
                        Toggle("Enable", isOn: Binding(
                            get: { attunementSlots[index].hasTertiaryAttunement },
                            set: { attunementSlots[index].hasTertiaryAttunement = $0 }
                        ))
                        .labelsHidden()
                    }
                    
                    if attunementSlots[index].hasTertiaryAttunement {
                        VStack(alignment: .leading, spacing: 8) {
                            TextField("Name", text: Binding(
                                get: { attunementSlots[index].tertiaryAttunement.name },
                                set: { attunementSlots[index].tertiaryAttunement.name = $0 }
                            ))
                            .textFieldStyle(.roundedBorder)
                            
                            HStack(spacing: 8) {
                                Text("Type")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Picker("", selection: Binding(
                                    get: { attunementSlots[index].tertiaryAttunement.type },
                                    set: { attunementSlots[index].tertiaryAttunement.type = $0 }
                                )) {
                                    ForEach(AttunementType.allCases, id: \.self) { type in
                                        Label(
                                            type.rawValue.capitalized,
                                            systemImage: typeIcon(for: type)
                                        ).tag(type)
                                    }
                                }
                                .pickerStyle(.menu)
                                .labelsHidden()
                                Spacer()
                            }
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Active")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Toggle("", isOn: Binding(
                                        get: { attunementSlots[index].tertiaryAttunement.isActive },
                                        set: { 
                                            attunementSlots[index].tertiaryAttunement.isActive = $0
                                            // Ensure only one attunement is active
                                            if $0 {
                                                attunementSlots[index].primaryAttunement.isActive = false
                                                attunementSlots[index].secondaryAttunement.isActive = false
                                                attunementSlots[index].quaternaryAttunement.isActive = false
                                            }
                                        }
                                    ))
                                    .labelsHidden()
                                }
                                .frame(maxWidth: .infinity)
                                
                                VStack(alignment: .leading) {
                                    Text("Lost")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Toggle("", isOn: Binding(
                                        get: { attunementSlots[index].tertiaryAttunement.isLost },
                                        set: { attunementSlots[index].tertiaryAttunement.isLost = $0 }
                                    ))
                                    .labelsHidden()
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                    }
                    
                    // Quaternary Attunement
                    HStack {
                        Text("Quaternary Attunement")
                            .font(.subheadline.bold())
                            .foregroundColor(.blue)
                        Spacer()
                        Toggle("Enable", isOn: Binding(
                            get: { attunementSlots[index].hasQuaternaryAttunement },
                            set: { attunementSlots[index].hasQuaternaryAttunement = $0 }
                        ))
                        .labelsHidden()
                    }
                    
                    if attunementSlots[index].hasQuaternaryAttunement {
                        VStack(alignment: .leading, spacing: 8) {
                            TextField("Name", text: Binding(
                                get: { attunementSlots[index].quaternaryAttunement.name },
                                set: { attunementSlots[index].quaternaryAttunement.name = $0 }
                            ))
                            .textFieldStyle(.roundedBorder)
                            
                            HStack(spacing: 8) {
                                Text("Type")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Picker("", selection: Binding(
                                    get: { attunementSlots[index].quaternaryAttunement.type },
                                    set: { attunementSlots[index].quaternaryAttunement.type = $0 }
                                )) {
                                    ForEach(AttunementType.allCases, id: \.self) { type in
                                        Label(
                                            type.rawValue.capitalized,
                                            systemImage: typeIcon(for: type)
                                        ).tag(type)
                                    }
                                }
                                .pickerStyle(.menu)
                                .labelsHidden()
                                Spacer()
                            }
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Active")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Toggle("", isOn: Binding(
                                        get: { attunementSlots[index].quaternaryAttunement.isActive },
                                        set: { 
                                            attunementSlots[index].quaternaryAttunement.isActive = $0
                                            // Ensure only one attunement is active
                                            if $0 {
                                                attunementSlots[index].primaryAttunement.isActive = false
                                                attunementSlots[index].secondaryAttunement.isActive = false
                                                attunementSlots[index].tertiaryAttunement.isActive = false
                                            }
                                        }
                                    ))
                                    .labelsHidden()
                                }
                                .frame(maxWidth: .infinity)
                                
                                VStack(alignment: .leading) {
                                    Text("Lost")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Toggle("", isOn: Binding(
                                        get: { attunementSlots[index].quaternaryAttunement.isLost },
                                        set: { attunementSlots[index].quaternaryAttunement.isLost = $0 }
                                    ))
                                    .labelsHidden()
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                    }
                }
            }
            
            // Daily Power Usage
            HStack {
                Text("Daily Power Used")
                    .font(.subheadline)
                    .foregroundColor(.orange)
                Spacer()
                Toggle("", isOn: Binding(
                    get: { index < attunementSlots.count ? attunementSlots[index].hasUsedDailyPower : false },
                    set: { 
                        if index >= attunementSlots.count {
                            attunementSlots.append(AttunementSlot())
                        }
                        attunementSlots[index].hasUsedDailyPower = $0
                    }
                ))
                .labelsHidden()
            }
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