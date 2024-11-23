import SwiftUI
import PhosphorSwift

struct DetailEquipmentSection: View {
    let character: PlayerCharacter
    
    private var isOverEncumbered: Bool {
        character.currentEncumbrance > character.maxEncumbrance
    }
    
    var body: some View {
        Section(header: SectionHeader(title: "Equipment", icon: Ph.briefcase.bold)) {
            VStack(alignment: .leading, spacing: 16) {
                // Encumbrance Bar
                VStack(alignment: .leading, spacing: 4) {
                    ProgressBar(
                        value: Double(character.currentEncumbrance),
                        maxValue: Double(character.maxEncumbrance),
                        label: "Encumbrance",
                        foregroundColor: isOverEncumbered ? .red : .blue,
                        showPercentage: true,
                        isComplete: isOverEncumbered,
                        completionMessage: isOverEncumbered ? "Over encumbered!" : nil
                    )
                }
                
                // Coins
                HStack {
                    Ph.coins.bold
                        .frame(width: 16, height: 16)
                        .foregroundColor(.yellow)
                    Text("\(character.coins) GP")
                        .fontWeight(.medium)
                }
                
                // Inventory
                if !character.inventory.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Inventory (\(character.inventory.count) items)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        ForEach(character.inventory, id: \.self) { item in
                            HStack {
                                Ph.circle.fill
                                    .frame(width: 6, height: 6)
                                    .foregroundColor(.secondary)
                                Text(item)
                            }
                        }
                    }
                }
            }
            .padding(.vertical, 8)
        }
    }
}
