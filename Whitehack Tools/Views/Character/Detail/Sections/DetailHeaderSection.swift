import SwiftUI
import PhosphorSwift

struct DetailHeaderSection: View {
    let character: PlayerCharacter
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        VStack(spacing: 16) {
            // Name field
            if !character.name.isEmpty {
                Text(character.name)
                    .font(.title2)
                    .fontWeight(.medium)
            }
            
            // Level, Class, XP
            LazyVGrid(columns: columns, spacing: 16) {
                InfoCard(
                    title: "Level",
                    value: "\(character.level)",
                    icon: Ph.numberCircleOne.bold
                )
                .padding()
                .groupCardStyle()
                
                InfoCard(
                    title: "Class",
                    value: character.characterClass.rawValue,
                    icon: Ph.sword.bold
                )
                .padding()
                .groupCardStyle()
                
                InfoCard(
                    title: "XP",
                    value: "\(character.experience)",
                    icon: Ph.star.bold
                )
                .padding()
                .groupCardStyle()
            }
            .padding(.horizontal)
            
            // Health and XP Progress
            VStack(spacing: 8) {
                ProgressBar(
                    value: Double(character.currentHP),
                    maxValue: Double(character.maxHP),
                    label: "Health (\(character.currentHP)/\(character.maxHP))",
                    foregroundColor: character.currentHP <= 0 ? .red : .green
                )
                
                if character.currentHP <= 0 {
                    Text("Knocked out until healed to positive HP.")
                        .font(.caption)
                        .foregroundColor(.red)
                }
                
                if character.level < 10 {
                    ProgressBar(
                        value: Double(character.experience - (character.level > 1 ? AdvancementTables.shared.xpRequirement(for: character.characterClass, at: character.level) : 0)),
                        maxValue: Double(character.xpForNextLevel - (character.level > 1 ? AdvancementTables.shared.xpRequirement(for: character.characterClass, at: character.level) : 0)),
                        label: "XP to Level \(character.level + 1)",
                        foregroundColor: character.experience >= character.xpForNextLevel ? .yellow : .blue,
                        isComplete: character.experience >= character.xpForNextLevel,
                        completionMessage: character.experience >= character.xpForNextLevel ? "Ready to level up!" : nil
                    )
                }
            }
            .padding()
            .groupCardStyle()
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
}

private struct InfoCard: View {
    let title: String
    let value: String
    let icon: Image
    
    var body: some View {
        VStack(spacing: 8) {
            icon
                .frame(width: 24, height: 24)
                .foregroundColor(.accentColor)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.title2)
                .fontWeight(.medium)
        }
        .frame(maxWidth: .infinity)
    }
}

private extension View {
    func groupCardStyle() -> some View {
        self
            #if os(iOS)
            .background(Color(uiColor: .systemBackground))
            #else
            .background(Color(nsColor: .windowBackgroundColor))
            #endif
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    DetailHeaderSection(character: PlayerCharacter())
        .padding()
}
