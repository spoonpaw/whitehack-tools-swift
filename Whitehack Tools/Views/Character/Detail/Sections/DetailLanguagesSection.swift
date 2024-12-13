import SwiftUI
import PhosphorSwift

struct DetailLanguagesSection: View {
    let character: PlayerCharacter
    
    var body: some View {
        VStack(spacing: 12) {
            SectionHeader(title: "Languages", icon: Ph.scroll.bold)
            
            if character.languages.isEmpty {
                Text("No Languages Known")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
            } else {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 8)], spacing: 8) {
                    ForEach(character.languages, id: \.self) { language in
                        Text(language)
                            .font(.subheadline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .frame(maxWidth: .infinity)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
