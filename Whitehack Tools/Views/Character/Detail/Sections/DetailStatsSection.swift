import SwiftUICore
import SwiftUI
import PhosphorSwift

public struct DetailStatsSection: View {
    let character: PlayerCharacter
    
    public var body: some View {
        Section(header: SectionHeader(title: "Attributes", icon: Ph.chartBar.bold)) {
            VStack(spacing: 16) {
                if character.useCustomAttributes {
                    // Display custom attributes
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                        ForEach(character.customAttributes) { attribute in
                            AttributeRow(
                                title: attribute.name,
                                value: "\(attribute.value)",
                                iconView: AnyView(attribute.icon.iconView),
                                isPlaceholder: false
                            )
                            .padding()
                            .groupCardStyle()
                        }
                    }
                } else {
                    // Display default attributes
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                        AttributeRow(
                            title: "Strength",
                            value: "\(character.strength)",
                            iconView: AnyView(Ph.barbell.bold),
                            isPlaceholder: false
                        )
                        .padding()
                        .groupCardStyle()
                        
                        AttributeRow(
                            title: "Dexterity",
                            value: "\(character.agility)",
                            iconView: AnyView(Ph.personSimpleRun.bold),
                            isPlaceholder: false
                        )
                        .padding()
                        .groupCardStyle()
                        
                        AttributeRow(
                            title: "Constitution",
                            value: "\(character.toughness)",
                            iconView: AnyView(Ph.heart.bold),
                            isPlaceholder: false
                        )
                        .padding()
                        .groupCardStyle()
                        
                        AttributeRow(
                            title: "Intelligence",
                            value: "\(character.intelligence)",
                            iconView: AnyView(Ph.brain.bold),
                            isPlaceholder: false
                        )
                        .padding()
                        .groupCardStyle()
                        
                        AttributeRow(
                            title: "Willpower",
                            value: "\(character.willpower)",
                            iconView: AnyView(Ph.eye.bold),
                            isPlaceholder: false
                        )
                        .padding()
                        .groupCardStyle()
                        
                        AttributeRow(
                            title: "Charisma",
                            value: "\(character.charisma)",
                            iconView: AnyView(Ph.star.bold),
                            isPlaceholder: false
                        )
                        .padding()
                        .groupCardStyle()
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

private struct AttributeRow: View {
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
