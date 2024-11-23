import SwiftUI

struct DetailWiseMiracleSection: View {
    let character: PlayerCharacter
    
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
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Slot \(index + 1)")
                                .font(.headline)
                            if index == 0 && extraInactiveMiracles > 0 {
                                Text("(\(extraInactiveMiracles) extra inactive)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            if index == 2 && slot.isMagicItem {
                                Image(systemName: "wand.and.stars")
                                    .foregroundColor(.purple)
                            }
                        }
                        
                        if index == 2 && slot.isMagicItem {
                            Text(slot.magicItemName.isEmpty ? "Unnamed Magic Item" : slot.magicItemName)
                                .foregroundColor(.purple)
                        } else {
                            let visibleMiracles = index == 0 ? 
                                Array(slot.miracles.prefix(2 + extraInactiveMiracles)) : 
                                slot.miracles
                            
                            if visibleMiracles.isEmpty {
                                Text("No miracles")
                                    .foregroundColor(.secondary)
                                    .italic()
                            } else {
                                ForEach(visibleMiracles) { miracle in
                                    HStack {
                                        if miracle.isActive {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.green)
                                        } else {
                                            Image(systemName: "circle")
                                                .foregroundColor(.secondary)
                                        }
                                        
                                        Text(miracle.name.isEmpty ? "Unnamed Miracle" : miracle.name)
                                            .foregroundColor(miracle.isActive ? .primary : .secondary)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
            } header: {
                Label("Miracles", systemImage: "sparkles")
            } footer: {
                if character.level == 1 {
                    Text("Level 1 slot gets \(extraInactiveMiracles) extra inactive miracle\(extraInactiveMiracles == 1 ? "" : "s") (Willpower \(character.willpower))")
                } else if character.level == 3 {
                    Text("Level 3 slot can hold a magic item instead of miracles")
                }
            }
        }
    }
}
