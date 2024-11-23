import SwiftUI
import PhosphorSwift

struct DetailNotesSection: View {
    let character: PlayerCharacter
    
    var body: some View {
        if !character.notes.isEmpty {
            Section(header: SectionHeader(title: "Notes", icon: Ph.note.bold)) {
                Text(character.notes)
                    .padding(.vertical, 8)
            }
        }
    }
}
