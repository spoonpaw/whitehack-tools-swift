import SwiftUI
import PhosphorSwift

struct DetailStatsSection: View {
    let character: PlayerCharacter
    
    var body: some View {
        Section(header: SectionHeader(title: "Attributes", icon: Ph.user.bold)) {
            VStack(spacing: 16) {
                GeometryReader { geometry in
                    VStack(spacing: 16) {
                        // Row 1
                        HStack(spacing: 16) {
                            AttributeCard(
                                label: "Strength",
                                value: "\(character.strength)",
                                icon: Ph.barbell.bold,
                                description: "Physical power used for carrying capacity and muscle-based tasks."
                            )
                            .frame(width: (geometry.size.width - 48) / 2)
                            
                            AttributeCard(
                                label: "Agility",
                                value: "\(character.agility)",
                                icon: Ph.lightning.bold,
                                description: "Speed and coordination. 13+ gives +1 initiative, 16+ gives +2."
                            )
                            .frame(width: (geometry.size.width - 48) / 2)
                        }
                        
                        // Row 2
                        HStack(spacing: 16) {
                            AttributeCard(
                                label: "Toughness",
                                value: "\(character.toughness)",
                                icon: Ph.shield.bold,
                                description: "Physical resilience and ability to survive damage."
                            )
                            .frame(width: (geometry.size.width - 48) / 2)
                            
                            AttributeCard(
                                label: "Intelligence",
                                value: "\(character.intelligence)",
                                icon: Ph.brain.bold,
                                description: "Mental acuity and memory. 13+ grants +1 language, 16+ grants +2."
                            )
                            .frame(width: (geometry.size.width - 48) / 2)
                        }
                        
                        // Row 3
                        HStack(spacing: 16) {
                            AttributeCard(
                                label: "Willpower",
                                value: "\(character.willpower)",
                                icon: Ph.flame.bold,
                                description: "Mental fortitude, intuition, and awareness."
                            )
                            .frame(width: (geometry.size.width - 48) / 2)
                            
                            AttributeCard(
                                label: "Charisma",
                                value: "\(character.charisma)",
                                icon: Ph.chat.bold,
                                description: "Social influence and ability to lead or persuade others."
                            )
                            .frame(width: (geometry.size.width - 48) / 2)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, 16)
                }
                .frame(height: 800)
            }
            .padding(.vertical, 8)
        }
    }
}

struct EqualHeightModifier: ViewModifier {
    let index: Int
    @Binding var heights: [Int: CGFloat]
    
    func body(content: Content) -> some View {
        content
            .background(GeometryReader { proxy in
                Color.clear.preference(
                    key: HeightPreferenceKey.self,
                    value: [index: proxy.size.height]
                )
            })
            .frame(height: heights[index])
            .onPreferenceChange(HeightPreferenceKey.self) { preferences in
                for (index, height) in preferences {
                    heights[index] = max(heights[index] ?? 0, height)
                }
            }
    }
}

struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue: [Int: CGFloat] = [:]
    
    static func reduce(value: inout [Int: CGFloat], nextValue: () -> [Int: CGFloat]) {
        value.merge(nextValue()) { max($0, $1) }
    }
}
