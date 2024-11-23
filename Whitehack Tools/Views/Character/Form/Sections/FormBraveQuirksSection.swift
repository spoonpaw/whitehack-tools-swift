import SwiftUI

struct FormBraveQuirksSection: View {
    let characterClass: CharacterClass
    let level: Int
    @Binding var braveQuirkOptions: BraveQuirkOptions
    @Binding var comebackDice: Int
    @Binding var hasUsedSayNo: Bool
    
    private var availableSlots: Int {
        AdvancementTables.shared.stats(for: characterClass, at: level).slots
    }
    
    var body: some View {
        if characterClass == .brave {
            Section {
                // Quirk Slots
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Quirks")
                            .font(.headline)
                        Spacer()
                        Text("\(braveQuirkOptions.activeQuirks.count)/\(availableSlots)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    ForEach(0..<availableSlots, id: \.self) { slotIndex in
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Slot \(slotIndex + 1)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Menu {
                                Button("None") {
                                    braveQuirkOptions.setQuirk(nil, at: slotIndex)
                                }
                                
                                ForEach(BraveQuirk.allCases) { quirk in
                                    if !braveQuirkOptions.isActive(quirk) || braveQuirkOptions.getQuirk(at: slotIndex) == quirk {
                                        Button(quirk.name) {
                                            braveQuirkOptions.setQuirk(quirk, at: slotIndex)
                                        }
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(braveQuirkOptions.getQuirk(at: slotIndex)?.name ?? "Select Quirk")
                                        .foregroundColor(braveQuirkOptions.getQuirk(at: slotIndex) == nil ? .secondary : .primary)
                                    Spacer()
                                    Image(systemName: "chevron.up.chevron.down")
                                        .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(Color(.systemBackground))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(.systemGray4), lineWidth: 1)
                                )
                            }
                            
                            if let quirk = braveQuirkOptions.getQuirk(at: slotIndex) {
                                Text(quirk.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .padding(.top, 4)
                                
                                if quirk == .protectAlly {
                                    TextField("Protected Ally's Name", text: Binding(
                                        get: { braveQuirkOptions.getProtectedAlly(at: slotIndex) },
                                        set: { braveQuirkOptions.setProtectedAlly($0, at: slotIndex) }
                                    ))
                                    .textFieldStyle(.roundedBorder)
                                    .padding(.top, 4)
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                .padding(.vertical, 8)
                
                // Comeback Dice
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Comeback Dice")
                            .font(.headline)
                        Spacer()
                        Text("\(comebackDice)d6")
                            .font(.title2)
                            .foregroundColor(.green)
                    }
                    
                    Text("Gain a d6 when losing an auction, failing a task roll, or failing a save (not attacks). Can be added to any attribute, saving throw, attack value, or to supplant a damage die. Only the best die counts when using multiple dice.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Stepper("Available Dice: \(comebackDice)", value: $comebackDice, in: 0...10)
                }
                .padding(.vertical, 8)
                
                // Say No Power
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Say No Power")
                            .font(.headline)
                        Spacer()
                        Toggle("Used", isOn: $hasUsedSayNo)
                            .toggleStyle(SwitchToggleStyle(tint: .red))
                    }
                    
                    Text("Once per session, deny an enemy's successful attack, miraculous effect, or fear effect. Must explain how it's plausible and what your character does to avoid/resist.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
                
            } header: {
                Label("Brave Features", systemImage: "heart.fill")
            } footer: {
                if hasArmorPenalty {
                    Text("Wearing armor heavier than cloth: -2 penalty to all task rolls")
                        .foregroundColor(.red)
                }
            }
        }
    }
    
    private var hasArmorPenalty: Bool {
        // TODO: Add armor check logic when equipment system is implemented
        return false
    }
}
