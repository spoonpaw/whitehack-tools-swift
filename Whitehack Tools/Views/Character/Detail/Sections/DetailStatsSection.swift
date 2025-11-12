import SwiftUICore
import SwiftUI
import PhosphorSwift

public struct DetailStatsSection: View {
    let character: PlayerCharacter
    
    private func findGroupsForAttribute(_ attributeName: String) -> [String] {
        return character.attributeGroupPairs
            .filter { $0.attribute.lowercased() == attributeName.lowercased() }
            .map { $0.group }
    }
    
    public var body: some View {
        VStack(spacing: 12) {
            SectionHeader(title: "Attributes", icon: Ph.chartBar.bold)
            
            VStack(spacing: 16) {
                if character.useCustomAttributes {
                    // Display custom attributes
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                        ForEach(character.customAttributes) { attribute in
                            AttributeRow(
                                title: attribute.name,
                                value: "\(attribute.value)",
                                iconView: AnyView(attribute.icon.iconView),
                                isPlaceholder: false,
                                groups: findGroupsForAttribute(attribute.name),
                                character: character
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
                            isPlaceholder: false,
                            groups: findGroupsForAttribute("Strength"),
                            character: character
                        )
                        .padding()
                        .groupCardStyle()
                        
                        AttributeRow(
                            title: "Agility",
                            value: "\(character.agility)",
                            iconView: AnyView(Ph.personSimpleRun.bold),
                            isPlaceholder: false,
                            groups: findGroupsForAttribute("Agility"),
                            character: character
                        )
                        .padding()
                        .groupCardStyle()
                        
                        AttributeRow(
                            title: "Toughness",
                            value: "\(character.toughness)",
                            iconView: AnyView(Ph.heart.bold),
                            isPlaceholder: false,
                            groups: findGroupsForAttribute("Toughness"),
                            character: character
                        )
                        .padding()
                        .groupCardStyle()
                        
                        AttributeRow(
                            title: "Intelligence",
                            value: "\(character.intelligence)",
                            iconView: AnyView(Ph.brain.bold),
                            isPlaceholder: false,
                            groups: findGroupsForAttribute("Intelligence"),
                            character: character
                        )
                        .padding()
                        .groupCardStyle()
                        
                        AttributeRow(
                            title: "Willpower",
                            value: "\(character.willpower)",
                            iconView: AnyView(Ph.eye.bold),
                            isPlaceholder: false,
                            groups: findGroupsForAttribute("Willpower"),
                            character: character
                        )
                        .padding()
                        .groupCardStyle()
                        
                        AttributeRow(
                            title: "Charisma",
                            value: "\(character.charisma)",
                            iconView: AnyView(Ph.star.bold),
                            isPlaceholder: false,
                            groups: findGroupsForAttribute("Charisma"),
                            character: character
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
    let groups: [String]
    let character: PlayerCharacter
    
    private func groupColor(for group: String) -> Color {
        if group == character.speciesGroup {
            return .blue
        } else if group == character.vocationGroup {
            return .purple
        } else {
            return .green
        }
    }
    
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
            
            if !groups.isEmpty {
                VStack(spacing: 4) {
                    ForEach(groups, id: \.self) { group in
                        let color = groupColor(for: group)
                        Text(group)
                            .font(.caption)
                            .foregroundColor(color)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(color.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(color.opacity(0.3), lineWidth: 1)
                            )
                    }
                }
            }
            
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private extension View {
    func groupCardStyle() -> some View {
        self
            #if os(iOS)
            .background(Color(UIColor.tertiarySystemGroupedBackground))
            #else
            .background(Color(NSColor.controlBackgroundColor))
            #endif
            .clipShape(RoundedRectangle(cornerRadius: 12))
            #if os(iOS)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(UIColor.separator).opacity(0.25), lineWidth: 1)
            )
            #else
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(NSColor.separatorColor).opacity(0.25), lineWidth: 1)
            )
            #endif
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    DetailStatsSection(character: PlayerCharacter())
        .padding()
}
