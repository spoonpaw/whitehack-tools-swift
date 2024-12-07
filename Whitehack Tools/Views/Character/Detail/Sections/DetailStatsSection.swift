import SwiftUICore
import SwiftUI
import PhosphorSwift

public struct DetailStatsSection: View {
    let character: PlayerCharacter
    
    public var body: some View {
        
        Section {
            VStack(spacing: 16) {
                if character.useCustomAttributes {
                    // Display custom attributes
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(character.customAttributes) { attribute in
                            StatCard(
                                label: attribute.name,
                                value: "\(attribute.value)",
                                icon: AnyView(attribute.icon.iconView)
                            )
                        }
                    }
                } else {
                    // Display default attributes
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        StatCard(
                            label: "Strength",
                            value: "\(character.strength)",
                            icon: AnyView(Ph.barbell.bold)
                        )
                        
                        StatCard(
                            label: "Dexterity",
                            value: "\(character.agility)",
                            icon: AnyView(Ph.personSimpleRun.bold)
                        )
                        
                        StatCard(
                            label: "Constitution",
                            value: "\(character.toughness)",
                            icon: AnyView(Ph.heart.bold)
                        )
                        
                        StatCard(
                            label: "Intelligence",
                            value: "\(character.intelligence)",
                            icon: AnyView(Ph.brain.bold)
                        )
                        
                        StatCard(
                            label: "Willpower",
                            value: "\(character.willpower)",
                            icon: AnyView(Ph.eye.bold)
                        )
                        
                        StatCard(
                            label: "Charisma",
                            value: "\(character.charisma)",
                            icon: AnyView(Ph.star.bold)
                        )
                    }
                }
            }
            .padding(.vertical, 8)
        } header: {
            HStack(spacing: 8) {
                AnyView(Ph.chartBar.bold)
                    .frame(width: 20, height: 20)
                Text("Attributes")
                    .font(.headline)
            }
        }
    }
}
