import SwiftUI
import PhosphorSwift

struct GroupPill: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(value)
                .font(.body)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.secondary.opacity(0.1))
        .cornerRadius(8)
    }
}

struct DetailGroupsSection: View {
    let character: PlayerCharacter
    
    private let columns = [
        GridItem(.adaptive(minimum: 100, maximum: .infinity), spacing: 8)
    ]
    
    var body: some View {
        Section(header: SectionHeader(title: "Character Groups", icon: Ph.usersThree.bold)) {
            VStack(alignment: .leading, spacing: 16) {
                // Species & Vocation
                HStack(spacing: 16) {
                    GroupPill(label: "Species", value: character.speciesGroup ?? "None")
                    GroupPill(label: "Vocation", value: character.vocationGroup ?? "None")
                }
                
                // Affiliation Groups
                if !character.affiliationGroups.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Ph.flag.bold
                                .frame(width: 16, height: 16)
                                .foregroundColor(.secondary)
                            Text("Affiliations")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        LazyVGrid(columns: columns, alignment: .leading, spacing: 8) {
                            ForEach(character.affiliationGroups, id: \.self) { group in
                                Text(group)
                                    .font(.subheadline)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(.secondary.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                
                // Attribute-Group Pairs
                if !character.attributeGroupPairs.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Ph.sparkle.bold
                                .frame(width: 16, height: 16)
                                .foregroundColor(.secondary)
                            Text("Attribute Specializations")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        ForEach(character.attributeGroupPairs) { pair in
                            HStack(spacing: 8) {
                                Text(pair.attribute)
                                    .fontWeight(.medium)
                                Text("•")
                                    .foregroundColor(.secondary)
                                Text(pair.group)
                            }
                            .font(.subheadline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.purple.opacity(0.1))
                            .cornerRadius(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
            }
            .padding(.vertical, 8)
        }
    }
}
