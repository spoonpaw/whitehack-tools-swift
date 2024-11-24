import SwiftUI

struct DetailFortunateSection: View {
    let character: PlayerCharacter
    
    var body: some View {
        if character.characterClass == .fortunate {
            VStack(alignment: .leading, spacing: 16) {
                // Standing & Fortune
                VStack(alignment: .leading, spacing: 8) {
                    Label("Noble Status", systemImage: "crown.fill")
                        .font(.headline)
                    
                    if !character.fortunateOptions.standing.isEmpty {
                        Text(character.fortunateOptions.standing)
                            .font(.body)
                    }
                    
                    HStack {
                        Image(systemName: character.fortunateOptions.hasUsedFortune ? "xmark.circle.fill" : "checkmark.circle.fill")
                            .foregroundColor(character.fortunateOptions.hasUsedFortune ? .red : .green)
                        Text(character.fortunateOptions.hasUsedFortune ? "Fortune has been used this session" : "Fortune is available")
                            .font(.caption)
                            .foregroundColor(character.fortunateOptions.hasUsedFortune ? .red : .green)
                    }
                }
                
                Divider()
                
                // Signature Object
                VStack(alignment: .leading, spacing: 8) {
                    Label("Signature Object", systemImage: "sparkles")
                        .font(.headline)
                    
                    if !character.fortunateOptions.signatureObject.name.isEmpty {
                        Text(character.fortunateOptions.signatureObject.name)
                            .font(.body)
                    }
                }
                
                Divider()
                
                // Retainers
                VStack(alignment: .leading, spacing: 8) {
                    Label("Retainers", systemImage: "person.2.fill")
                        .font(.headline)
                    
                    ForEach(character.fortunateOptions.retainers, id: \.id) { retainer in
                        RetainerDetailView(retainer: retainer)
                            .padding(.vertical, 4)
                    }
                }
            }
            .padding()
        }
    }
}

struct RetainerDetailView: View {
    let retainer: Retainer
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Basic Info
            HStack {
                VStack(alignment: .leading) {
                    Text(retainer.name)
                        .font(.headline)
                    Text(retainer.type)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            // Stats
            HStack(spacing: 16) {
                RetainerStatView(label: "HD", value: retainer.hitDice, systemImage: "heart.fill")
                RetainerStatView(label: "DF", value: retainer.defenseFactor, systemImage: "shield.fill")
                RetainerStatView(label: "MV", value: retainer.movement, systemImage: "figure.walk")
            }
            
            // Keywords
            if !retainer.keywords.isEmpty {
                TagFlowView(data: retainer.keywords, spacing: 8) { keyword in
                    Text(keyword)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.secondary.opacity(0.2))
                        .cornerRadius(12)
                }
            }
            
            Divider()
        }
    }
}

struct RetainerStatView: View {
    let label: String
    let value: Int
    let systemImage: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: systemImage)
                .foregroundColor(.secondary)
            Text("\(label) \(value)")
                .font(.caption)
        }
    }
}
