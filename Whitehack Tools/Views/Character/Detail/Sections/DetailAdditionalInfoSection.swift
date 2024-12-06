import SwiftUI
import PhosphorSwift

struct DetailAdditionalInfoSection: View {
    let character: PlayerCharacter
    
    var body: some View {
        Section {
            VStack(alignment: .leading, spacing: 16) {
                if !character.notes.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            Ph.info.bold
                                .frame(width: 20, height: 20)
                            Text("Notes")
                                .font(.headline)
                        }
                        Text(character.notes)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding(16)
                    .background(.secondary.opacity(0.1))
                    .cornerRadius(12)
                }
            }
            .padding(.vertical, 8)
        } header: {
            HStack(spacing: 8) {
                Ph.info.bold
                    .frame(width: 20, height: 20)
                Text("Additional Information")
                    .font(.headline)
            }
        }
    }
}
