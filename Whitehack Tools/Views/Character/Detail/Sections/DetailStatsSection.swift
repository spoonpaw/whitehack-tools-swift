import SwiftUI
import PhosphorSwift

private struct EqualHeight: ViewModifier {
    let height: Binding<CGFloat>
    
    func body(content: Content) -> some View {
        content
            .frame(height: height.wrappedValue)
            .background(
                GeometryReader { geometry in
                    Color.clear.preference(
                        key: MaxHeightPreferenceKey.self,
                        value: geometry.size.height
                    )
                }
            )
    }
}

private struct MaxHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

struct DetailStatsSection: View {
    let character: PlayerCharacter
    
    var body: some View {
        Section(header: SectionHeader(title: "Attributes", icon: Ph.gauge.bold)) {
            VStack(spacing: 16) {
                // Row 1: Strength & Agility
                HStack(spacing: 16) {
                    AttributeCard(
                        label: "Strength",
                        value: "\(character.strength)",
                        icon: Ph.barbell.bold,
                        description: "Physical power used for carrying capacity and muscle-based tasks."
                    )
                    
                    AttributeCard(
                        label: "Agility",
                        value: "\(character.agility)",
                        icon: Ph.lightning.bold,
                        description: "Speed and coordination. 13+ gives +1 initiative, 16+ gives +2."
                    )
                }
                
                // Row 2: Toughness & Intelligence
                HStack(spacing: 16) {
                    AttributeCard(
                        label: "Toughness",
                        value: "\(character.toughness)",
                        icon: Ph.shield.bold,
                        description: "Physical resilience and ability to survive damage."
                    )
                    .frame(height: 220.5)  // Force Toughness card to match others
                    
                    AttributeCard(
                        label: "Intelligence",
                        value: "\(character.intelligence)",
                        icon: Ph.brain.bold,
                        description: "Mental acuity and memory. 13+ grants +1 language, 16+ grants +2."
                    )
                }
                
                // Row 3: Willpower & Charisma
                HStack(spacing: 16) {
                    AttributeCard(
                        label: "Willpower",
                        value: "\(character.willpower)",
                        icon: Ph.flame.bold,
                        description: "Mental fortitude, intuition, and awareness."
                    )
                    
                    AttributeCard(
                        label: "Charisma",
                        value: "\(character.charisma)",
                        icon: Ph.chat.bold,
                        description: "Social influence and leadership ability."
                    )
                }
            }
            .padding(.horizontal, 16)
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            print("📏 DetailStatsSection height: \(geometry.size.height)")
                        }
                        .onChange(of: geometry.size) { newSize in
                            print("📐 DetailStatsSection height changed to: \(newSize.height)")
                        }
                }
            )
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
