import SwiftUI
import PhosphorSwift

struct FormCleverKnacksSection: View {
    let characterClass: CharacterClass
    let level: Int
    @Binding var cleverKnackOptions: CleverKnackOptions
    
    private var availableSlots: Int {
        guard characterClass == .clever else { return 0 }
        let stats = AdvancementTables.shared.stats(for: characterClass, at: level)
        return stats.slots
    }
    
    var body: some View {
        VStack(spacing: 0) {
            SectionHeader(title: "The Clever", icon: Ph.brain.bold)
            
            VStack(spacing: 16) {
                CleverMasterCard(
                    cleverKnackOptions: $cleverKnackOptions,
                    availableSlots: availableSlots
                )
            }
            .padding(.vertical, 16)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Clever Master Card
private struct CleverMasterCard: View {
    @Binding var cleverKnackOptions: CleverKnackOptions
    let availableSlots: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Daily Power Section
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 8) {
                    Image(systemName: "sparkles")
                        .foregroundColor(.red)
                        .imageScale(.large)
                    Text("Daily Power")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.red)
                }
                
                HStack(alignment: .top, spacing: 16) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Unorthodox Solution")
                            .font(.title3)
                            .fontWeight(.medium)
                        Text(cleverKnackOptions.hasUsedUnorthodoxBonus ? 
                            "Already used today - must rest to regain" :
                            "Available to use: +6 bonus for non-combat problem solving")
                            .font(.subheadline)
                            .foregroundColor(cleverKnackOptions.hasUsedUnorthodoxBonus ? .red : .green)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: $cleverKnackOptions.hasUsedUnorthodoxBonus)
                        .toggleStyle(.switch)
                        .labelsHidden()
                }
                
                if cleverKnackOptions.hasUsedUnorthodoxBonus {
                    HStack(alignment: .center, spacing: 6) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                        Text("Power has been used today")
                            .font(.subheadline)
                            .foregroundColor(.red)
                    }
                }
            }
            
            Divider()
                .padding(.vertical, 8)
            
            // Knacks Section
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 8) {
                    Image(systemName: "lightbulb")
                        .foregroundColor(.orange)
                        .imageScale(.large)
                    Text("Knacks")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)
                }
                
                ForEach(0..<availableSlots, id: \.self) { index in
                    KnackSlotRow(
                        slotIndex: index,
                        cleverKnackOptions: $cleverKnackOptions
                    )
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Knack Slot Row
private struct KnackSlotRow: View {
    let slotIndex: Int
    @Binding var cleverKnackOptions: CleverKnackOptions
    
    private func isKnackActive(_ knack: CleverKnack) -> Bool {
        cleverKnackOptions.activeKnacks.contains(knack)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Picker("Slot \(slotIndex + 1)", selection: Binding(
                get: { cleverKnackOptions.getKnack(at: slotIndex) },
                set: { cleverKnackOptions.setKnack($0, at: slotIndex) }
            )) {
                Text("Select Knack").tag(Optional<CleverKnack>.none)
                ForEach(CleverKnack.allCases) { knack in
                    if !isKnackActive(knack) || cleverKnackOptions.getKnack(at: slotIndex) == knack {
                        Text(knack.name).tag(Optional(knack))
                    }
                }
            }
            .pickerStyle(.menu)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(Color(nsColor: .controlBackgroundColor))
            .cornerRadius(12)
            
            if let knack = cleverKnackOptions.getKnack(at: slotIndex) {
                Text(knack.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                
                if knack == .combatExploiter {
                    HStack(alignment: .top, spacing: 16) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Battle Usage")
                                .font(.title3)
                                .fontWeight(.medium)
                            Text(cleverKnackOptions.isKnackUsed(at: slotIndex) ?
                                "Already used this battle - resets after battle" :
                                "Available to use this battle")
                                .font(.subheadline)
                                .foregroundColor(cleverKnackOptions.isKnackUsed(at: slotIndex) ? .red : .green)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                        Spacer()
                        
                        Toggle("", isOn: Binding(
                            get: { cleverKnackOptions.isKnackUsed(at: slotIndex) },
                            set: { cleverKnackOptions.setKnackUsed(at: slotIndex, to: $0) }
                        ))
                        .toggleStyle(.switch)
                        .labelsHidden()
                    }
                    .padding(.top, 8)
                }
            }
        }
    }
}
