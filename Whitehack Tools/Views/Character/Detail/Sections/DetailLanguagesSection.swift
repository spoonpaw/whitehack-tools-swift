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
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    .padding(.horizontal)
            } else {
                HStack(spacing: 12) {
                    Spacer(minLength: 0)
                    ForEach(character.languages, id: \.self) { language in
                        Text(language)
                            .font(.subheadline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    }
                    Spacer(minLength: 0)
                }
                .padding(.horizontal)
            }
        }
    }
}
