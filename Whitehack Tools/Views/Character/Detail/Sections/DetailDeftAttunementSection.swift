import SwiftUI
import PhosphorSwift

struct DetailDeftAttunementSection: View {
    let character: PlayerCharacter
    
    var body: some View {
        if character.characterClass == .deft {
            Section(header: SectionHeader(title: "Attunements", icon: Image(systemName: "sparkles"))) {
                ForEach(character.attunementSlots) { slot in
                    AttunementSlotCard(slot: slot)
                }
            }
        }
    }
}

private struct AttunementSlotCard: View {
    let slot: AttunementSlot
    
    var body: some View {
        VStack(spacing: 16) {
            // Primary & Secondary Container
            VStack(spacing: 12) {
                if !slot.primaryAttunement.name.isEmpty {
                    AttunementRow(
                        attunement: slot.primaryAttunement,
                        isActive: slot.primaryAttunement.isActive,
                        style: .primary
                    )
                }
                
                if !slot.secondaryAttunement.name.isEmpty {
                    AttunementRow(
                        attunement: slot.secondaryAttunement,
                        isActive: !slot.primaryAttunement.isActive,
                        style: .secondary
                    )
                }
            }
            
            // Daily Power Indicator
            if slot.hasUsedDailyPower {
                HStack {
                    Image(systemName: "sunset.fill")
                        .foregroundColor(.orange)
                    Text("Daily Power Used")
                        .font(.footnote.weight(.medium))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
                .background(Color(.systemBackground).opacity(0.5))
                .cornerRadius(8)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.purple.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(Color.purple.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

private struct AttunementRow: View {
    let attunement: Attunement
    let isActive: Bool
    let style: RowStyle
    
    enum RowStyle {
        case primary, secondary
        
        var gradient: LinearGradient {
            switch self {
            case .primary:
                return LinearGradient(
                    colors: [.purple.opacity(0.2), .clear],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            case .secondary:
                return LinearGradient(
                    colors: [.blue.opacity(0.2), .clear],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            }
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Name and Type
            VStack(alignment: .leading, spacing: 4) {
                Text(attunement.name)
                    .font(.headline)
                
                HStack(spacing: 6) {
                    Image(systemName: typeIcon)
                        .font(.caption)
                    Text(attunement.type.rawValue.capitalized)
                        .font(.caption)
                        .textCase(.uppercase)
                }
                .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Status Indicators
            HStack(spacing: 8) {
                // Active Status
                if isActive {
                    Label("Active", systemImage: "circle.fill")
                        .font(.caption.weight(.medium))
                        .foregroundColor(.green)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(6)
                }
                
                // Lost Status
                if attunement.isLost {
                    Label("Lost", systemImage: "exclamationmark.triangle.fill")
                        .font(.caption.weight(.medium))
                        .foregroundColor(.yellow)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.yellow.opacity(0.1))
                        .cornerRadius(6)
                }
            }
        }
        .padding(12)
        .background(style.gradient)
        .cornerRadius(12)
    }
    
    private var typeIcon: String {
        switch attunement.type {
        case .teacher: return "person.fill.checkmark"
        case .item: return "sparkles.square.filled.on.square"
        case .vehicle: return "car.fill"
        case .pet: return "pawprint.fill"
        case .place: return "mappin.circle.fill"
        }
    }
}
