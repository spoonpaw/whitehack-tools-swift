import SwiftUI
import PhosphorSwift

struct DetailFortunateSection: View {
    let character: PlayerCharacter
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Section {
            VStack(alignment: .leading, spacing: 16) {
                // Class Info Card
                VStack(alignment: .leading, spacing: 8) {
                    Label("The Fortunate", systemImage: "crown.fill")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    Text("Born to privilege, you gain unique advantages through nobility, fame, destiny, or wealth. Once per session, you may leverage your fortune for a major benefit.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                Divider()
                    .background(Color.purple.opacity(0.3))
                
                // Standing & Fortune Status
                VStack(alignment: .leading, spacing: 16) {
                    // Noble Status
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Noble Status", systemImage: "crown.fill")
                            .font(.headline)
                            .foregroundStyle(.primary)
                        
                        if !character.fortunateOptions.standing.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(character.fortunateOptions.standing)
                                    .font(.body)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(Color.purple.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                
                                Text("Your standing grants group benefits when relevant: affiliated factions are more helpful, species benefits apply regardless of attributes, and aligned vocations may grant +6 bonus.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 4)
                            }
                        }
                    }
                    
                    Divider()
                        .background(Color.purple.opacity(0.3))
                    
                    // Fortune
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Fortune", systemImage: "star.circle.fill")
                            .font(.headline)
                            .foregroundStyle(.primary)
                        
                        Text("Once per session, you may use your fortune in a major way - like hiring a large ship, getting an audience with royalty, or being welcomed by a hostile tribe.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 4)
                        
                        HStack(spacing: 12) {
                            Image(systemName: character.fortunateOptions.hasUsedFortune ? "xmark.circle.fill" : "sparkles")
                                .font(.title2)
                                .foregroundColor(character.fortunateOptions.hasUsedFortune ? .red : .yellow)
                            
                            VStack(alignment: .leading) {
                                Text(character.fortunateOptions.hasUsedFortune ? "Fortune has been used" : "Fortune is available")
                                    .font(.subheadline)
                                    .foregroundColor(character.fortunateOptions.hasUsedFortune ? .red : .green)
                                Text(character.fortunateOptions.hasUsedFortune ? "Will reset next session" : "Available for a major advantage")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(character.fortunateOptions.hasUsedFortune ? 
                            Color.red.opacity(0.1) : Color.green.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                .padding(.bottom, 8)
                
                Divider()
                    .background(Color.purple.opacity(0.3))
                
                // Signature Object
                if !character.fortunateOptions.signatureObject.name.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Signature Object", systemImage: "sparkles")
                            .font(.headline)
                            .foregroundStyle(.primary)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(character.fortunateOptions.signatureObject.name)
                                .font(.body)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.blue.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                            Text("Your signature object has plot immunity - it can never be lost or destroyed unless you choose.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 4)
                        }
                    }
                    .padding(.vertical, 8)
                    
                    Divider()
                        .background(Color.purple.opacity(0.3))
                }
                
                // Retainers
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Retainers", systemImage: "person.2.fill")
                            .font(.headline)
                            .foregroundStyle(.primary)
                        
                        Text("Your retainers can grow in strength as you level. They have their own HD, DF, MV, and keywords, acting as unique allies with personalities and attitudes.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 4)
                    }
                    
                    ForEach(character.fortunateOptions.retainers) { retainer in
                        RetainerDetailView(retainer: retainer)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
            }
            .padding(.vertical, 8)
        }
    }
}

struct RetainerDetailView: View {
    let retainer: Retainer
    @Environment(\.colorScheme) var colorScheme
    @State private var isExpanded = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header - Now the entire header is tappable
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(retainer.name.isEmpty ? "Unnamed Retainer" : retainer.name)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        Text(retainer.type.isEmpty ? "Type Undefined" : retainer.type)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                        .animation(.spring(response: 0.3), value: isExpanded)
                }
                .padding()
                .background(colorScheme == .dark ? Color(.systemGray6) : .white)
                .contentShape(Rectangle()) // This makes the entire header tappable
                .onTapGesture {
                    withAnimation(.spring(response: 0.3)) {
                        isExpanded.toggle()
                    }
                }
            }
            
            // Expanded Content
            if isExpanded {
                VStack(alignment: .leading, spacing: 16) {
                    // Stats with cool icons and styling
                    HStack(spacing: 20) {
                        StatBadge(label: "HD", value: retainer.hitDice, icon: "heart.fill", color: .red)
                        StatBadge(label: "DF", value: retainer.defenseFactor, icon: "shield.fill", color: .blue)
                        StatBadge(label: "MV", value: retainer.movement, icon: "figure.walk", color: .green)
                    }
                    .padding(.top, 8)
                    
                    // Notes Section with fancy styling
                    if !retainer.notes.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Notes", systemImage: "note.text")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Text(retainer.notes)
                                .font(.body)
                                .padding(12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.purple.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                    
                    // Keywords with modern tag styling
                    if !retainer.keywords.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Keywords", systemImage: "tag.fill")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            TagWrappingView(tags: retainer.keywords)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .background(colorScheme == .dark ? Color(.systemGray6) : .white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color(.systemGray4).opacity(0.3), radius: 10, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.purple.opacity(0.3), lineWidth: 1)
        )
    }
}

struct StatBadge: View {
    let label: String
    let value: Int
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            Text("\(label) \(value)")
                .font(.caption)
                .bold()
                .foregroundColor(.primary)
        }
        .frame(width: 60)
        .padding(.vertical, 8)
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct TagWrappingView: View {
    let tags: [String]
    
    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
    }
    
    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(self.tags, id: \.self) { tag in
                self.item(for: tag)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading) { d in
                        if (abs(width - d.width) > g.size.width) {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if tag == self.tags.last! {
                            width = 0
                        } else {
                            width -= d.width
                        }
                        return result
                    }
                    .alignmentGuide(.top) { _ in
                        let result = height
                        if tag == self.tags.last! {
                            height = 0
                        }
                        return result
                    }
            }
        }
    }
    
    private func item(for text: String) -> some View {
        Text(text)
            .font(.caption)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.blue.opacity(0.1))
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
            )
    }
}
