import SwiftUI
import PhosphorSwift

struct DetailNotesSection: View {
    let character: PlayerCharacter
    
    var body: some View {
        if !character.notes.isEmpty {
            VStack(alignment: .leading, spacing: 16) {
                SectionHeader(title: "Notes", icon: Ph.note.bold)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(character.notes)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(16)
                .frame(maxWidth: .infinity)
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(12)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
