import SwiftUI

struct DetailWiseMiracleSection: View {
    let character: PlayerCharacter
    @Environment(\.colorScheme) var colorScheme
    
    private var extraInactiveMiracles: Int {
        guard character.characterClass == .wise && character.level == 1 else { return 0 }
        if character.willpower >= 16 {
            return 2
        } else if character.willpower >= 13 {
            return 1
        }
        return 0
    }
    
    var body: some View {
        if character.characterClass == .wise {
            Section {
                ForEach(Array(character.wiseMiracleSlots.enumerated()), id: \.element.id) { index, slot in
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Slot \(index + 1)")
                                .font(.headline)
                                .foregroundColor(.primary)
                            if index == 0 && extraInactiveMiracles > 0 {
                                Text("(\(extraInactiveMiracles) extra inactive)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.secondary.opacity(0.2))
                                    .cornerRadius(12)
                            }
                            Spacer()
                            if index == 2 && slot.isMagicItem {
                                Label("Magic Item", systemImage: "wand.and.stars")
                                    .font(.caption)
                                    .foregroundColor(.purple)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 4)
                        
                        if index == 2 && slot.isMagicItem {
                            HStack {
                                Image(systemName: "sparkles")
                                    .foregroundColor(.purple)
                                Text(slot.magicItemName.isEmpty ? "Empty Magic Item" : slot.magicItemName)
                                    .foregroundColor(.purple)
                            }
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                            )
                            .padding(.horizontal)
                        } else {
                            let maxMiracles = index == 0 ? 2 + extraInactiveMiracles : 2
                            ForEach(0..<maxMiracles, id: \.self) { miracleIndex in
                                if miracleIndex < slot.miracles.count {
                                    miracleView(slot.miracles[miracleIndex])
                                } else {
                                    emptyMiracleView()
                                }
                            }
                        }
                    }
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(colorScheme == .dark ? Color(.systemGray6) : Color.white)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                    )
                    .shadow(color: Color.primary.opacity(0.05), radius: 2, x: 0, y: 1)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 4)
                }
            } header: {
                Label {
                    Text("Miracles")
                        .font(.headline)
                        .foregroundColor(.primary)
                } icon: {
                    Image(systemName: "sparkles")
                        .foregroundColor(.yellow)
                }
            } footer: {
                if character.level == 1 {
                    Text("Level 1 slot gets \(extraInactiveMiracles) extra inactive miracle\(extraInactiveMiracles == 1 ? "" : "s") (Willpower \(character.willpower))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else if character.level == 3 {
                    Text("Level 3 slot can hold a magic item instead of miracles")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    private func miracleView(_ miracle: WiseMiracle) -> some View {
        HStack(spacing: 12) {
            Image(systemName: miracle.isActive ? "checkmark.circle.fill" : "circle")
                .foregroundColor(miracle.isActive ? .green : .secondary)
                .imageScale(.large)
            
            Text(miracle.name.isEmpty ? "Empty Miracle" : miracle.name)
                .foregroundColor(miracle.isActive ? .primary : .secondary)
            
            Spacer()
            
            if miracle.isActive {
                Text("Active")
                    .font(.caption)
                    .foregroundColor(.green)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(8)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(colorScheme == .dark ? Color(.systemGray5) : Color(.systemGray6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(miracle.isActive ? Color.green.opacity(0.3) : Color.clear, lineWidth: 1)
        )
        .padding(.horizontal)
    }
    
    private func emptyMiracleView() -> some View {
        HStack(spacing: 12) {
            Image(systemName: "circle")
                .foregroundColor(.secondary)
                .imageScale(.large)
            
            Text("Empty Miracle")
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(colorScheme == .dark ? Color(.systemGray5) : Color(.systemGray6))
        )
        .padding(.horizontal)
        .opacity(0.5)
    }
}
