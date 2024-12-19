import SwiftUI
import PhosphorSwift

struct DetailSectionHeader: View {
    let title: String
    let icon: Image
    
    var body: some View {
        HStack(spacing: 8) {
            icon
                .frame(width: 20, height: 20)
            Text(title)
                .font(.headline)
        }
    }
}

struct DetailDeftAttunementSection: View {
    let character: PlayerCharacter
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        if character.characterClass == .deft {
            VStack(spacing: 0) {
                DetailSectionHeader(title: "The Deft", icon: Ph.detective.bold)
                    .padding(.bottom, 4)
                
                VStack(alignment: .leading, spacing: 16) {
                    ClassInfoCard()
                        .frame(maxWidth: .infinity)
                    DeftFeaturesCard()
                        .frame(maxWidth: .infinity)
                    AttunementSlotsCard(character: character)
                        .frame(maxWidth: .infinity)
                }
                .padding()
                .background(Color.purple.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.purple.opacity(0.2), lineWidth: 1)
                )
            }
        }
    }
}

// MARK: - Section Header
// private struct DeftSectionHeader: View {
//     var body: some View {
//         SectionHeader(title: "The Deft", icon: Ph.detective.bold)
//     }
// }

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
        #if os(iOS)
        .background(Color(uiColor: .systemBackground))
        #else
        .background(Color(nsColor: .windowBackgroundColor))
        #endif
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
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 16) {
                DeftAttunementFeatureRow(
                    icon: "dice.fill",
                    color: .green,
                    title: "Double Roll",
                    description: "Always use positive double roll for tasks and attacks in line with vocation when properly equipped"
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                
                DeftAttunementFeatureRow(
                    icon: "bolt.fill",
                    color: .orange,
                    title: "Combat Advantage",
                    description: "Can swap combat advantage for double damage if vocation is relevant"
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                
                DeftAttunementFeatureRow(
                    icon: "shield.lefthalf.filled",
                    color: .blue,
                    title: "Weapon Proficiency",
                    description: "-2 AV with non-attuned two-handed melee weapons. Combat vocations get +1 damage and df from off-hand weapons"
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                
                DeftAttunementFeatureRow(
                    icon: "tshirt.fill",
                    color: .red,
                    title: "Light Armor",
                    description: "Cannot use slot abilities or swap for double damage when using shield or armor heavier than studded leather"
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                
                DeftAttunementFeatureRow(
                    icon: "star.circle.fill",
                    color: .yellow,
                    title: "Non-Combat Vocation",
                    description: "Once per session, can save to turn a successful task roll into a critical success"
                )
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        #if os(iOS)
        .background(Color(uiColor: .systemBackground))
        #else
        .background(Color(nsColor: .windowBackgroundColor))
        #endif
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
        return slot.primaryAttunement.name.isEmpty && 
               slot.secondaryAttunement.name.isEmpty && 
               (!slot.hasTertiaryAttunement || slot.tertiaryAttunement.name.isEmpty) &&
               (!slot.hasQuaternaryAttunement || slot.quaternaryAttunement.name.isEmpty)
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
                        slotView(for: character.attunementSlots[index], index: index)
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
        #if os(iOS)
        .background(Color(uiColor: .systemBackground))
        #else
        .background(Color(nsColor: .windowBackgroundColor))
        #endif
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
    
    private func attunementView(for attunement: Attunement, type: String, isActive: Bool) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(type)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text(isActive ? "ACTIVE" : "INACTIVE")
                    .font(.caption.bold())
                    .foregroundColor(isActive ? .green : .secondary)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(isActive ? Color.green.opacity(0.15) : Color.gray.opacity(0.1))
                    .clipShape(Capsule())
            }
            
            if attunement.name.isEmpty {
                Text("(Empty)")
                    .italic()
                    .foregroundColor(.secondary)
            } else {
                HStack {
                    Text(attunement.name)
                        .fontWeight(.medium)
                    if attunement.isLost {
                        Text("(Lost)")
                            .foregroundColor(.red)
                            .italic()
                    }
                }
            }
            
            Label(attunement.type.rawValue.capitalized, systemImage: typeIcon(for: attunement.type))
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(isActive ? Color.green.opacity(0.05) : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 8))
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
    
    private func slotView(for slot: AttunementSlot, index: Int) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Slot \(index + 1)")
                .font(.headline)
                .foregroundColor(.blue)
            
            attunementView(for: slot.primaryAttunement, type: "Primary", isActive: slot.primaryAttunement.isActive)
            attunementView(for: slot.secondaryAttunement, type: "Secondary", isActive: slot.secondaryAttunement.isActive)
            
            if slot.hasTertiaryAttunement {
                attunementView(for: slot.tertiaryAttunement, type: "Tertiary", isActive: slot.tertiaryAttunement.isActive)
            }
            
            if slot.hasQuaternaryAttunement {
                attunementView(for: slot.quaternaryAttunement, type: "Quaternary", isActive: slot.quaternaryAttunement.isActive)
            }
            
            if slot.hasUsedDailyPower {
                Text("Daily Power: Used")
                    .font(.subheadline)
                    .foregroundColor(.orange)
                    .italic()
            } else {
                Text("Daily Power: Available")
                    .font(.subheadline)
                    .foregroundColor(.green)
                    .italic()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.purple.opacity(0.05))
        .cornerRadius(10)
    }
}

private struct EmptySlotView: View {
    let slotNumber: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Slot \(slotNumber)")
                .font(.headline)
                .foregroundColor(.blue)
            
            Text("Empty")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        #if os(iOS)
        .background(Color(uiColor: .systemGray6))
        #else
        .background(Color(nsColor: .controlBackgroundColor))
        #endif
        .cornerRadius(10)
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
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
