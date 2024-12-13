import SwiftUI
import PhosphorSwift

struct FormDeftAttunementSection: View {
    let characterClass: CharacterClass
    let level: Int
    @Binding var attunementSlots: [AttunementSlot]
    
    var body: some View {
        if characterClass == .deft {
            VStack(spacing: 16) {
                // Header
                SectionHeader(title: "The Deft", icon: Ph.detective.bold)
                
                // Content
                VStack(spacing: 24) {
                    ForEach(0..<level, id: \.self) { index in
                        if index < attunementSlots.count {
                            AttunementSlotView(
                                index: index,
                                attunementSlots: $attunementSlots
                            )
                        }
                    }
                }
                .padding(.horizontal)
            }
            .task {
                initializeSlotsIfNeeded()
            }
        }
    }
    
    private func initializeSlotsIfNeeded() {
        if attunementSlots.isEmpty {
            attunementSlots = Array(repeating: AttunementSlot(), count: level)
        }
        
        while attunementSlots.count < level {
            attunementSlots.append(AttunementSlot())
        }
        while attunementSlots.count > level {
            attunementSlots.removeLast()
        }
    }
}

private struct AttunementSlotView: View {
    let index: Int
    @Binding var attunementSlots: [AttunementSlot]
    
    var body: some View {
        VStack(spacing: 16) {
            PrimaryAttunementView(index: index, attunementSlots: $attunementSlots)
            SecondaryAttunementView(index: index, attunementSlots: $attunementSlots)
            TertiaryAttunementView(index: index, attunementSlots: $attunementSlots)
            QuaternaryAttunementView(index: index, attunementSlots: $attunementSlots)
            DailyPowerView(index: index, attunementSlots: $attunementSlots)
        }
        .padding(16)
        .background(Color.primary.opacity(0.05))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.purple.opacity(0.2), lineWidth: 1)
        )
    }
}

private struct PrimaryAttunementView: View {
    let index: Int
    @Binding var attunementSlots: [AttunementSlot]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Primary Attunement")
                .font(.subheadline.bold())
                .foregroundColor(.blue)
            
            AttunementFieldsView(
                index: index,
                attunementSlots: $attunementSlots,
                getAttunement: { slots in slots[index].primaryAttunement },
                setAttunement: { slots, attunement in slots[index].primaryAttunement = attunement }
            )
        }
    }
}

private struct SecondaryAttunementView: View {
    let index: Int
    @Binding var attunementSlots: [AttunementSlot]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Secondary Attunement")
                .font(.subheadline.bold())
                .foregroundColor(.purple)
            
            AttunementFieldsView(
                index: index,
                attunementSlots: $attunementSlots,
                getAttunement: { slots in slots[index].secondaryAttunement },
                setAttunement: { slots, attunement in slots[index].secondaryAttunement = attunement }
            )
        }
    }
}

private struct AttunementFieldsView: View {
    let index: Int
    @Binding var attunementSlots: [AttunementSlot]
    let getAttunement: ([AttunementSlot]) -> Attunement
    let setAttunement: (inout [AttunementSlot], Attunement) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Text("Name")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                TextField("", text: Binding(
                    get: { 
                        guard index < attunementSlots.count else { return "" }
                        return getAttunement(attunementSlots).name
                    },
                    set: { newValue in
                        guard index < attunementSlots.count else { return }
                        var attunement = getAttunement(attunementSlots)
                        attunement.name = newValue
                        setAttunement(&attunementSlots, attunement)
                    }
                ))
                .textFieldStyle(.roundedBorder)
            }
            
            HStack(spacing: 8) {
                Text("Type")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Picker("", selection: Binding<AttunementType>(
                    get: { 
                        guard index < attunementSlots.count else { return AttunementType.item }
                        return getAttunement(attunementSlots).type
                    },
                    set: { newType in
                        guard index < attunementSlots.count else { return }
                        var attunement = getAttunement(attunementSlots)
                        attunement.type = newType
                        setAttunement(&attunementSlots, attunement)
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
            
            AttunementToggleRow(
                title: "Active",
                isOn: Binding<Bool>(
                    get: {
                        guard index < attunementSlots.count else { return false }
                        return getAttunement(attunementSlots).isActive
                    },
                    set: { newValue in
                        guard index < attunementSlots.count else { return }
                        var attunement = getAttunement(attunementSlots)
                        attunement.isActive = newValue
                        setAttunement(&attunementSlots, attunement)
                    }
                )
            )
            
            AttunementToggleRow(
                title: "Lost",
                isOn: Binding<Bool>(
                    get: {
                        guard index < attunementSlots.count else { return false }
                        return getAttunement(attunementSlots).isLost
                    },
                    set: { newValue in
                        guard index < attunementSlots.count else { return }
                        var attunement = getAttunement(attunementSlots)
                        attunement.isLost = newValue
                        setAttunement(&attunementSlots, attunement)
                    }
                )
            )
        }
        .padding(12)
        .background(Color.blue.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private struct AttunementToggleRow: View {
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
    }
}

private struct TertiaryAttunementView: View {
    let index: Int
    @Binding var attunementSlots: [AttunementSlot]
    
    var body: some View {
        if index == 0 {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Tertiary Attunement")
                        .font(.subheadline.bold())
                        .foregroundColor(.green)
                    Spacer()
                    Toggle("Enable", isOn: Binding(
                        get: { 
                            guard index < attunementSlots.count else { return false }
                            return attunementSlots[index].hasTertiaryAttunement
                        },
                        set: { 
                            guard index < attunementSlots.count else { return }
                            attunementSlots[index].hasTertiaryAttunement = $0
                        }
                    ))
                    .labelsHidden()
                }
                
                if attunementSlots[index].hasTertiaryAttunement {
                    AttunementFieldsView(
                        index: index,
                        attunementSlots: $attunementSlots,
                        getAttunement: { slots in slots[index].tertiaryAttunement },
                        setAttunement: { slots, attunement in slots[index].tertiaryAttunement = attunement }
                    )
                }
                
                if attunementSlots[index].hasTertiaryAttunement {
                    HStack {
                        Text("Quaternary Attunement")
                            .font(.subheadline.bold())
                            .foregroundColor(.blue)
                        Spacer()
                        Toggle("Enable", isOn: Binding(
                            get: { 
                                guard index < attunementSlots.count else { return false }
                                return attunementSlots[index].hasQuaternaryAttunement
                            },
                            set: { 
                                guard index < attunementSlots.count else { return }
                                attunementSlots[index].hasQuaternaryAttunement = $0
                            }
                        ))
                        .labelsHidden()
                    }
                    
                    if attunementSlots[index].hasQuaternaryAttunement {
                        AttunementFieldsView(
                            index: index,
                            attunementSlots: $attunementSlots,
                            getAttunement: { slots in slots[index].quaternaryAttunement },
                            setAttunement: { slots, attunement in slots[index].quaternaryAttunement = attunement }
                        )
                    }
                }
            }
        } else {
            EmptyView()
        }
    }
}

private struct QuaternaryAttunementView: View {
    let index: Int
    @Binding var attunementSlots: [AttunementSlot]
    
    var body: some View {
        EmptyView()
    }
}

private struct DailyPowerView: View {
    let index: Int
    @Binding var attunementSlots: [AttunementSlot]
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Daily Power")
                    .font(.subheadline)
                    .foregroundColor(.orange)
                Text(attunementSlots[index].hasUsedDailyPower ? 
                    "This slot's daily power has been used and cannot be used again until tomorrow" : 
                    "This slot's daily power is available to use")
                    .font(.caption)
                    .foregroundColor(attunementSlots[index].hasUsedDailyPower ? .secondary : .green)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
            Toggle("", isOn: Binding(
                get: { 
                    guard index < attunementSlots.count else { return false }
                    return attunementSlots[index].hasUsedDailyPower
                },
                set: { 
                    guard index < attunementSlots.count else { return }
                    attunementSlots[index].hasUsedDailyPower = $0
                }
            ))
            .labelsHidden()
        }
        .padding(.top, 8)
    }
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