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
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Slot \(index + 1)")
                            .font(.headline)
                        
                        // Primary Attunement
                        VStack(alignment: .leading) {
                            TextField("Primary Attunement", text: Binding(
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
                                    Text(type.rawValue.capitalized).tag(type)
                                }
                            }
                            .pickerStyle(.segmented)
                            
                            Toggle("Active", isOn: Binding(
                                get: { index < attunementSlots.count ? attunementSlots[index].primaryAttunement.isActive : false },
                                set: { 
                                    if index >= attunementSlots.count {
                                        attunementSlots.append(AttunementSlot())
                                    }
                                    attunementSlots[index].primaryAttunement.isActive = $0
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
                        .padding(.vertical, 5)
                        
                        // Secondary Attunement
                        VStack(alignment: .leading) {
                            TextField("Secondary Attunement", text: Binding(
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
                                    Text(type.rawValue.capitalized).tag(type)
                                }
                            }
                            .pickerStyle(.segmented)
                            
                            Toggle("Active", isOn: Binding(
                                get: { index < attunementSlots.count ? !attunementSlots[index].primaryAttunement.isActive : false },
                                set: { _ in 
                                    if index >= attunementSlots.count {
                                        attunementSlots.append(AttunementSlot())
                                    }
                                    attunementSlots[index].primaryAttunement.isActive.toggle()
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
                        .padding(.vertical, 5)
                        
                        Toggle("Used Daily Power", isOn: Binding(
                            get: { index < attunementSlots.count ? attunementSlots[index].hasUsedDailyPower : false },
                            set: { 
                                if index >= attunementSlots.count {
                                    attunementSlots.append(AttunementSlot())
                                }
                                attunementSlots[index].hasUsedDailyPower = $0
                            }
                        ))
                    }
                    .padding(.vertical, 5)
                }
            }
        }
    }
}