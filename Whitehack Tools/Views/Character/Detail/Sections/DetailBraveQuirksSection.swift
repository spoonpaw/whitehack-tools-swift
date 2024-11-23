import SwiftUI

struct DetailBraveQuirksSection: View {
    let characterClass: CharacterClass
    let level: Int
    let braveQuirkOptions: BraveQuirkOptions
    let comebackDice: Int
    let hasUsedSayNo: Bool
    
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
                    
                    if braveQuirkOptions.activeQuirks.isEmpty {
                        Text("No quirks selected")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.vertical, 8)
                    } else {
                        ForEach(0..<availableSlots, id: \.self) { slotIndex in
                            if let quirk = braveQuirkOptions.getQuirk(at: slotIndex) {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text(quirk.name)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                        Spacer()
                                        Text("Slot \(slotIndex + 1)")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Text(quirk.description)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .padding(.top, 4)
                                    
                                    if quirk == .protectAlly {
                                        let ally = braveQuirkOptions.getProtectedAlly(at: slotIndex)
                                        if !ally.isEmpty {
                                            Text("Protected Ally: \(ally)")
                                                .font(.caption)
                                                .foregroundColor(.blue)
                                                .padding(.top, 4)
                                        }
                                    }
                                }
                                .padding(.vertical, 8)
                            }
                        }
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
                            .foregroundColor(comebackDice > 0 ? .green : .secondary)
                    }
                    
                    Text("Gain a d6 when losing an auction, failing a task roll, or failing a save (not attacks). Can be added to any attribute, saving throw, attack value, or to supplant a damage die. Only the best die counts when using multiple dice.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
                
                // Say No Power
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Say No Power")
                            .font(.headline)
                        Spacer()
                        if hasUsedSayNo {
                            Text("Used")
                                .font(.subheadline)
                                .foregroundColor(.red)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(Color.red.opacity(0.2))
                                .cornerRadius(8)
                        } else {
                            Text("Available")
                                .font(.subheadline)
                                .foregroundColor(.green)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(Color.green.opacity(0.2))
                                .cornerRadius(8)
                        }
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
