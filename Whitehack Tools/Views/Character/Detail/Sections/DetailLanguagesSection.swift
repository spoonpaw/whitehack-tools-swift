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
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    )
                    .padding(.horizontal)
            } else {
                VStack(spacing: 8) {
                    ForEach(character.languages, id: \.self) { language in
                        LanguageCard(language: language)
                    }
                }
                .padding(16)
                #if os(iOS)
                .background(Color(UIColor.systemBackground))
                #else
                .background(Color(NSColor.windowBackgroundColor))
                #endif
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                .padding(.horizontal)
            }
        }
    }
}

struct LanguageCard: View {
    let language: String
    
    var body: some View {
        Text(language)
            .font(.system(.subheadline, design: .rounded))
            .foregroundColor(.primary)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.06), radius: 2, x: 0, y: 1)
                    .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)
            )
    }
}
