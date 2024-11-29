import SwiftUI
import PhosphorSwift

struct DetailEncumbranceSection: View {
    let character: PlayerCharacter
    
    private var isOverEncumbered: Bool {
        character.currentEncumbrance > character.maxEncumbrance
    }
    
    var body: some View {
        Section(header: SectionHeader(title: "Encumbrance", icon: Ph.scales.bold)) {
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
            .padding(.vertical, 8)
        }
    }
}
