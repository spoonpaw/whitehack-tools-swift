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

struct EqualHeight: ViewModifier {
    let alignment: Alignment
    
    func body(content: Content) -> some View {
        content
            .frame(maxHeight: .infinity, alignment: alignment)
    }
}

extension View {
    func equalHeight(alignment: Alignment = .center) -> some View {
        modifier(EqualHeight(alignment: alignment))
    }
}

private struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

struct DetailGroupsSection: View {
    let character: PlayerCharacter
    
    var body: some View {
        Section(header: SectionHeader(title: "Groups", icon: Ph.users.bold)) {
            VStack(spacing: 16) {
                // Species and Vocation in a grid
                HStack(spacing: 16) {
                    GroupRow(
                        title: "Species",
                        value: character.speciesGroup ?? "Not Chosen",
                        icon: Ph.dna.bold,
                        isPlaceholder: character.speciesGroup == nil
                    )
                    .padding()
                    #if os(iOS)
                    .background(Color(uiColor: .systemBackground))
                    #else
                    .background(Color(nsColor: .windowBackgroundColor))
                    #endif
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    GroupRow(
                        title: "Vocation",
                        value: character.vocationGroup ?? "Not Chosen",
                        icon: Ph.briefcase.bold,
                        isPlaceholder: character.vocationGroup == nil
                    )
                    .padding()
                    #if os(iOS)
                    .background(Color(uiColor: .systemBackground))
                    #else
                    .background(Color(nsColor: .windowBackgroundColor))
                    #endif
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .fixedSize(horizontal: false, vertical: true)
                
                // Affiliations as full width
                if !character.affiliationGroups.isEmpty {
                    GroupRow(
                        title: "Affiliations",
                        value: character.affiliationGroups.joined(separator: ", "),
                        icon: Ph.usersThree.bold,
                        isPlaceholder: false
                    )
                    .padding()
                    .groupCardStyle()
                }
            }
            .padding(.horizontal)
        }
    }
}

private struct GroupRow: View {
    let title: String
    let value: String
    let icon: Image
    let isPlaceholder: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            IconFrame(icon: icon, color: isPlaceholder ? .secondary : .accentColor)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(isPlaceholder ? .body.italic() : .body)
                    .foregroundColor(isPlaceholder ? .secondary : .primary)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxHeight: .infinity, alignment: .topLeading)
            Spacer(minLength: 0)
        }
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
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    DetailGroupsSection(character: PlayerCharacter())
        .padding()
}
