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
        VStack(alignment: .leading, spacing: 16) {
            // Daily Power Section
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "sparkles")
                        .foregroundColor(.red)
                    Text("Daily Power")
                        .font(.headline)
                        .foregroundColor(.red)
                }
                
                Toggle(isOn: $cleverKnackOptions.hasUsedUnorthodoxBonus) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Unorthodox Solution")
                            .fontWeight(.medium)
                        Text(cleverKnackOptions.hasUsedUnorthodoxBonus ? 
                            "Already used today - must rest to regain" :
                            "Available to use: +6 bonus for non-combat problem solving")
                            .font(.caption)
                            .foregroundColor(cleverKnackOptions.hasUsedUnorthodoxBonus ? .red : .green)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
                
                if cleverKnackOptions.hasUsedUnorthodoxBonus {
                    HStack(alignment: .top, spacing: 4) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                        Text("Power has been used today")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
            }
            .padding(.bottom, 8)
            
            Divider()
                .padding(.vertical, 8)
            
            // Knacks Section
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "lightbulb")
                        .foregroundColor(.orange)
                    Text("Knacks")
                        .font(.headline)
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
        .padding(16)
        .background(backgroundStyle)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
    
    private var backgroundStyle: some View {
        #if os(iOS)
        Color(uiColor: .systemBackground)
        #else
        Color(nsColor: .windowBackgroundColor)
        #endif
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
        VStack(alignment: .leading, spacing: 8) {
            // Knack Selection Menu
            Menu {
                Button("None") {
                    cleverKnackOptions.setKnack(nil, at: slotIndex)
                }
                
                ForEach(CleverKnack.allCases) { knack in
                    if !isKnackActive(knack) || cleverKnackOptions.getKnack(at: slotIndex) == knack {
                        Button(knack.name) {
                            cleverKnackOptions.setKnack(knack, at: slotIndex)
                        }
                    }
                }
            } label: {
                HStack {
                    Text("Slot \(slotIndex + 1):")
                        .foregroundColor(.secondary)
                    Text(cleverKnackOptions.getKnack(at: slotIndex)?.name ?? "Select Knack")
                        .foregroundColor(cleverKnackOptions.getKnack(at: slotIndex) == nil ? .secondary : .primary)
                    Spacer()
                    Image(systemName: "chevron.up.chevron.down")
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(backgroundStyle)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(borderColor, lineWidth: 1)
                )
            }
            
            if let knack = cleverKnackOptions.getKnack(at: slotIndex) {
                Text(knack.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if knack == .combatExploiter {
                    Toggle(isOn: Binding(
                        get: { cleverKnackOptions.isKnackUsed(at: slotIndex) },
                        set: { cleverKnackOptions.setKnackUsed(at: slotIndex, to: $0) }
                    )) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Battle Usage")
                                .fontWeight(.medium)
                            Text(cleverKnackOptions.isKnackUsed(at: slotIndex) ?
                                "Already used this battle - resets after battle" :
                                "Available to use this battle")
                                .font(.caption)
                                .foregroundColor(cleverKnackOptions.isKnackUsed(at: slotIndex) ? .red : .green)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .padding(.top, 4)
                }
            }
        }
    }
    
    private var backgroundStyle: some View {
        #if os(iOS)
        Color(uiColor: .systemBackground)
        #else
        Color(nsColor: .windowBackgroundColor)
        #endif
    }
    
    private var borderColor: Color {
        #if os(iOS)
        Color(uiColor: .systemGray4)
        #else
        Color(nsColor: .separatorColor)
        #endif
    }
}
