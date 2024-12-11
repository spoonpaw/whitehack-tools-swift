import SwiftUI
import PhosphorSwift

struct DetailCombatSection: View {
    let character: PlayerCharacter
    
    var body: some View {
        VStack(spacing: 12) {
            SectionHeader(title: "Combat Stats", icon: Ph.boxingGlove.bold)
            
            VStack(spacing: 16) {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                    StatCard(
                        title: "Attack",
                        value: "\(character.attackValue)",
                        iconView: AnyView(Ph.sword.bold),
                        isPlaceholder: false
                    )
                    .padding()
                    .groupCardStyle()
                    
                    StatCard(
                        title: "Defense",
                        value: "\(character.defenseValue)",
                        iconView: AnyView(Ph.shield.bold),
                        isPlaceholder: false
                    )
                    .padding()
                    .groupCardStyle()
                    
                    StatCard(
                        title: "Movement",
                        value: "\(character.movement) ft",
                        iconView: AnyView(Ph.personSimpleRun.bold),
                        isPlaceholder: false
                    )
                    .padding()
                    .groupCardStyle()
                    
                    StatCard(
                        title: "Initiative",
                        value: character.initiativeBonus > 0 ? "+\(character.initiativeBonus)" : "0",
                        iconView: AnyView(Ph.lightning.bold),
                        isPlaceholder: false
                    )
                    .padding()
                    .groupCardStyle()
                }
                
                SaveColorCard(value: character.saveValue, colorName: character.saveColor)
                    .padding()
                    .groupCardStyle()
            }
            .padding(.horizontal)
        }
    }
}

private struct StatCard: View {
    let title: String
    let value: String
    let iconView: AnyView
    let isPlaceholder: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            iconView
                .frame(width: 24, height: 24)
                .foregroundColor(isPlaceholder ? .secondary : .accentColor)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.title2)
                .fontWeight(.medium)
                .foregroundColor(isPlaceholder ? .secondary : .primary)
            
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct SaveColorCard: View {
    let value: Int
    let colorName: String
    
    var body: some View {
        VStack(spacing: 8) {
            Ph.shieldStar.bold
                .frame(width: 24, height: 24)
                .foregroundColor(.accentColor)
            
            Text("Save")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("\(value)")
                .font(.title2)
                .fontWeight(.medium)
            
            Text(colorName)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
