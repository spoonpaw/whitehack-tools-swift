import SwiftUI
import PhosphorSwift

struct DetailDeftAttunementSection: View {
    let character: PlayerCharacter
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        if character.characterClass == .deft {
            Section {
                VStack(alignment: .leading, spacing: 16) {
                    ClassInfoCard()
                    DeftFeaturesCard()
                    AttunementSlotsCard(character: character)
                }
                .padding(.vertical)
            } header: {
                DeftSectionHeader()
            }
        }
    }
}

// MARK: - Section Header
private struct DeftSectionHeader: View {
    var body: some View {
        Label {
            Text("The Deft")
                .font(.headline)
                .foregroundColor(.primary)
        } icon: {
            Image(systemName: "person.fill")
                .foregroundColor(.purple)
        }
    }
}

// MARK: - Cards
private struct ClassInfoCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "figure.walk")
                    .foregroundColor(.purple)
                Text("Class Overview")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            Text("Masters of technique and skill who rely on superior training and expertise. Whether as thieves, wandering monks, spies, marksmen, rangers, or assassins, they excel through precision and finesse.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.purple.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
}

private struct DeftFeaturesCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.purple)
                Text("Class Features")
                    .font(.headline)
            }
            
            VStack(alignment: .leading, spacing: 16) {
                DeftAttunementFeatureRow(
                    icon: "dice.fill",
                    color: .green,
                    title: "Double Roll",
                    description: "Always use positive double roll for tasks and attacks in line with vocation when properly equipped"
                )
                
                DeftAttunementFeatureRow(
                    icon: "bolt.fill",
                    color: .orange,
                    title: "Combat Advantage",
                    description: "Can swap combat advantage for double damage if vocation is relevant"
                )
                
                DeftAttunementFeatureRow(
                    icon: "shield.lefthalf.filled",
                    color: .blue,
                    title: "Weapon Proficiency",
                    description: "+2 AV with non-attuned two-handed melee weapons. Combat vocations get +1 damage and df from off-hand weapons"
                )
                
                DeftAttunementFeatureRow(
                    icon: "tshirt.fill",
                    color: .red,
                    title: "Light Armor",
                    description: "Cannot use slot abilities or swap for double damage when using shield or armor heavier than studded leather"
                )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
}

private struct AttunementSlotsCard: View {
    let character: PlayerCharacter
    
    private var availableSlots: Int {
        AdvancementTables.shared.stats(for: character.characterClass, at: character.level).slots
    }
    
    private func isSlotEmpty(_ slot: AttunementSlot) -> Bool {
        return slot.primaryAttunement.name.isEmpty && slot.secondaryAttunement.name.isEmpty
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "sparkles")
                    .foregroundColor(.purple)
                Text("Attunement Slots")
                    .font(.headline)
            }
            
            VStack(alignment: .leading, spacing: 16) {
                ForEach(0..<availableSlots, id: \.self) { index in
                    if index < character.attunementSlots.count && !isSlotEmpty(character.attunementSlots[index]) {
                        AttunementSlotView(slot: character.attunementSlots[index], slotNumber: index + 1)
                    } else {
                        EmptySlotView(slotNumber: index + 1)
                    }
                }
                
                if availableSlots == 0 {
                    Text("No attunement slots available at level \(character.level)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.leading, 4)
                }
            }
            
            // Attunement Rules
            VStack(alignment: .leading, spacing: 8) {
                Text("Attunement Rules")
                    .font(.subheadline.bold())
                    .foregroundColor(.purple)
                    .padding(.bottom, 4)
                
                RuleRow(icon: "clock.fill", text: "Switching attunements takes a day of practice")
                RuleRow(icon: "sparkles", text: "Active attunements can be invoked once per day")
                RuleRow(icon: "arrow.clockwise", text: "Hard tasks succeed automatically")
                RuleRow(icon: "exclamationmark.triangle.fill", text: "Nigh impossible tasks become regular rolls")
                RuleRow(icon: "plus", text: "Lost attunements give +1 to related tasks")
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.purple.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
}

private struct EmptySlotView: View {
    let slotNumber: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Slot \(slotNumber)")
                .font(.headline)
                .foregroundColor(.purple)
            
            Text("Empty Slot")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.leading, 4)
        }
        .padding(12)
        .background(Color.purple.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private struct AttunementSlotView: View {
    let slot: AttunementSlot
    let slotNumber: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Slot \(slotNumber)")
                .font(.headline)
                .foregroundColor(.purple)
            
            // Primary Attunement
            if !slot.primaryAttunement.name.isEmpty {
                AttunementItemView(
                    attunement: slot.primaryAttunement,
                    isActive: slot.primaryAttunement.isActive,
                    isPrimary: true
                )
            }
            
            // Secondary Attunement
            if !slot.secondaryAttunement.name.isEmpty {
                AttunementItemView(
                    attunement: slot.secondaryAttunement,
                    isActive: !slot.primaryAttunement.isActive,
                    isPrimary: false
                )
            }
            
            // Daily Power Status
            if slot.hasUsedDailyPower {
                HStack {
                    Image(systemName: "sun.max.fill")
                        .foregroundColor(.orange)
                    Text("Daily Power Used")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
                .padding(.vertical, 4)
            }
        }
        .padding(12)
        .background(Color.purple.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private struct AttunementItemView: View {
    let attunement: Attunement
    let isActive: Bool
    let isPrimary: Bool
    
    private var typeIcon: (icon: String, color: Color) {
        switch attunement.type {
        case .teacher: return ("person.fill.checkmark", .blue)
        case .item: return ("sparkles.square.filled.on.square", .orange)
        case .vehicle: return ("car.fill", .green)
        case .pet: return ("pawprint.fill", .yellow)
        case .place: return ("mappin.circle.fill", .red)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: typeIcon.icon)
                    .foregroundColor(typeIcon.color)
                
                Text(attunement.name)
                    .font(.subheadline.bold())
                    .foregroundColor(typeIcon.color)
                
                Spacer()
                
                if isActive {
                    Text("Active")
                        .font(.caption.bold())
                        .foregroundColor(.green)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.1))
                        .clipShape(Capsule())
                }
                
                if attunement.isLost {
                    Text("Lost")
                        .font(.caption.bold())
                        .foregroundColor(.red)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.red.opacity(0.1))
                        .clipShape(Capsule())
                }
            }
            
            Text(attunement.type.rawValue.capitalized)
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.leading, 24)
        }
        .padding(8)
        .background(isPrimary ? Color.purple.opacity(0.05) : Color.blue.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

// MARK: - Helper Views
private struct DeftAttunementFeatureRow: View {
    let icon: String
    let color: Color
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(color)
                .imageScale(.medium)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.vertical, 4)
    }
}

private struct RuleRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(.purple)
                .frame(width: 20)
            
            Text(text)
                .font(.caption)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.leading)
        }
    }
}
