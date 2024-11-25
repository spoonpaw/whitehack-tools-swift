import SwiftUI
import PhosphorSwift

struct DetailFortunateSection: View {
    let character: PlayerCharacter
    @Environment(\.colorScheme) var colorScheme

    private var availableSlots: Int {
        AdvancementTables.shared.stats(for: character.characterClass, at: character.level).slots
    }

    var body: some View {
        if character.characterClass == .fortunate {
            Section {
                VStack(alignment: .leading, spacing: 16) {
                    ClassOverviewCard()
                    FortunePowerCard(hasUsedFortune: character.fortunateOptions.hasUsedFortune)
                    StandingCard(standing: character.fortunateOptions.standing)
                    SignatureObjectCard(signatureObject: character.fortunateOptions.signatureObject)
                    RetainersCard(
                        retainers: character.fortunateOptions.retainers,
                        availableSlots: availableSlots
                    )
                }
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
            } header: {
                Label {
                    Text("The Fortunate")
                        .font(.headline)
                } icon: {
                    Image(systemName: "crown.fill")
                        .foregroundColor(.orange)
                }
            }
        }
    }
}

// MARK: - Cards
private struct ClassOverviewCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "crown.fill")
                    .foregroundColor(.orange)
                Text("Class Overview")
                    .font(.headline)
            }
            Text("""
                Fortunate characters are born with the advantages of nobility, fame, destiny, wealth, or a combination thereof. They can be royal heirs, rich and influential merchants, star performers, or religious icons. Once per game session, they may use their good fortune in a major way, like hiring a large ship, performing the will of a god, getting a personal audience with the queen, or being hailed as a friend by a hostile tribe.

                The Fortunate may use any weapon or armor without penalty. They have +4 to charisma when checking retainer morale, +2 in reaction rolls, and +6 in any reputation roll. They also get a single signature object with plot immunity.
                """)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(12)
                .background(Color.orange.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .frame(maxWidth: .infinity)

            VStack(alignment: .leading, spacing: 8) {
                FeatureRow(
                    icon: "shield.fill",
                    color: .blue,
                    title: "Combat Proficiency",
                    description: "Can use any weapon or armor without penalty."
                )
                FeatureRow(
                    icon: "person.2.fill",
                    color: .green,
                    title: "Social Advantages",
                    description: "+4 to charisma for retainer morale, +2 on reaction rolls, +6 on reputation rolls."
                )
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
        .frame(maxWidth: .infinity)
    }
}

private struct FortunePowerCard: View {
    let hasUsedFortune: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "star.circle.fill")
                    .foregroundColor(.yellow)
                Text("Fortune Power")
                    .font(.headline)
            }
            Text("""
                Once per game session, the Fortunate may use their good fortune in a major way, such as:

                • Hiring a large ship.
                • Performing the will of a god.
                • Getting a personal audience with the queen.
                • Being hailed as a friend by a hostile tribe.

                Note: The Fortunate may not use their fortune power to purchase experience or fund XP for others.
                """)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(12)
                .background(Color.yellow.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .frame(maxWidth: .infinity)

            HStack {
                Image(systemName: hasUsedFortune ? "xmark.circle.fill" : "checkmark.circle.fill")
                    .foregroundColor(hasUsedFortune ? .red : .green)
                Text(hasUsedFortune ? "Fortune power has been used this session" : "Fortune power is available")
                    .foregroundColor(hasUsedFortune ? .red : .green)
            }
            .padding(8)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
        .frame(maxWidth: .infinity)
    }
}

private struct StandingCard: View {
    let standing: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "building.columns.fill")
                    .foregroundColor(.purple)
                Text("Standing")
                    .font(.headline)
            }
            if !standing.isEmpty {
                Text(standing)
                    .font(.body)
                    .padding(12)
                    .background(Color.purple.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .frame(maxWidth: .infinity)

                Text("When the referee thinks that the standing is relevant:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.top, 8)

                VStack(alignment: .leading, spacing: 8) {
                    BenefitRow(
                        icon: "person.3.fill",
                        title: "Faction Relations",
                        description: "Affiliated factions are considerably more helpful, and their enemies more vengeful. Others may distance themselves or show interest."
                    )
                    BenefitRow(
                        icon: "hare.fill",
                        title: "Species Benefits",
                        description: "Your species gives any applicable benefits regardless of attribute."
                    )
                    BenefitRow(
                        icon: "plus.circle.fill",
                        title: "Task Bonus",
                        description: "If standing and vocation align for a task, and the vocation is marked next to the applicable attribute, you get a +6 bonus."
                    )
                }
                .frame(maxWidth: .infinity)
            } else {
                Text("No standing specified")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
        .frame(maxWidth: .infinity)
    }
}

private struct SignatureObjectCard: View {
    let signatureObject: SignatureObject

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "seal.fill")
                    .foregroundColor(.orange)
                Text("Signature Object")
                    .font(.headline)
            }
            if !signatureObject.name.isEmpty {
                Text(signatureObject.name)
                    .font(.body)
                    .padding(12)
                    .background(Color.orange.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .frame(maxWidth: .infinity)

                Text("This object has plot immunity and cannot be lost, destroyed, or made irretrievable by the referee unless you wish it to happen.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
            } else {
                Text("No signature object specified")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
        .frame(maxWidth: .infinity)
    }
}

private struct RetainersCard: View {
    let retainers: [Retainer]
    let availableSlots: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Label {
                        Text("Retainers")
                            .font(.headline)
                    } icon: {
                        Image(systemName: "person.2.fill")
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .foregroundColor(.secondary)
                        Text("\(retainers.count)/\(availableSlots)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.secondary.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                
                Text("Retainers can grow in strength and serve as valuable allies. They have their own stats, attitudes, and can be played as alternate characters.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 4)
            }
            
            if availableSlots == 0 {
                // No slots available message
                HStack {
                    Image(systemName: "exclamationmark.circle")
                        .foregroundColor(.secondary)
                    Text("No retainer slots available at current level")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.secondary.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                // Retainer slots
                VStack(spacing: 12) {
                    ForEach(0..<availableSlots, id: \.self) { index in
                        if index < retainers.count {
                            RetainerDetailView(retainer: retainers[index], slotNumber: index + 1)
                        } else {
                            RetainerDetailView(retainer: Retainer(), slotNumber: index + 1)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
}

// MARK: - Retainer Views
private struct RetainerDetailView: View {
    let retainer: Retainer
    let slotNumber: Int
    
    private var isEmpty: Bool {
        retainer.name.isEmpty
    }
    
    var body: some View {
        VStack(spacing: 12) {
            if isEmpty {
                emptySlotView
            } else {
                filledSlotView
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private var emptySlotView: some View {
        HStack {
            Image(systemName: "person.crop.circle.badge.plus")
                .font(.title2)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Empty Slot \(slotNumber)")
                    .font(.headline)
                Text("Tap to add a new retainer")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    private var filledSlotView: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with name and type
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Label {
                        Text(retainer.name)
                            .font(.headline)
                    } icon: {
                        Image(systemName: "person.circle.fill")
                            .foregroundColor(.blue)
                    }
                    
                    Label {
                        Text(retainer.type)
                            .font(.subheadline)
                    } icon: {
                        Image(systemName: "tag.fill")
                            .foregroundColor(.orange)
                    }
                }
                
                Spacer()
                
                Text("#\(slotNumber)")
                    .font(.caption)
                    .padding(6)
                    .background(Color.secondary.opacity(0.1))
                    .clipShape(Circle())
            }
            
            Divider()
            
            // Combat Stats
            VStack(alignment: .leading, spacing: 8) {
                Label {
                    Text("Combat Stats")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                } icon: {
                    Image(systemName: "shield.fill")
                        .foregroundColor(.red)
                }
                
                HStack(spacing: 12) {
                    StatBadge(label: "HD", value: "\(retainer.hitDice)", icon: "dice.fill")
                    StatBadge(label: "DF", value: "\(retainer.defenseFactor)", icon: "shield.lefthalf.filled")
                    StatBadge(label: "MV", value: "\(retainer.movement)", icon: "figure.walk")
                }
            }
            
            // HP
            VStack(alignment: .leading, spacing: 4) {
                Label {
                    Text("Hit Points")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                } icon: {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                }
                
                Text("\(retainer.currentHP)/\(retainer.maxHP)")
                    .font(.system(.body, design: .monospaced))
            }
            
            // Keywords
            if !retainer.keywords.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Label {
                        Text("Keywords")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    } icon: {
                        Image(systemName: "text.word.spacing")
                            .foregroundColor(.purple)
                    }
                    
                    HStack(spacing: 4) {
                        ForEach(retainer.keywords, id: \.self) { keyword in
                            Text(keyword)
                                .font(.callout)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.purple.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                    }
                }
            }
            
            // Notes
            if !retainer.notes.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Label {
                        Text("Notes")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    } icon: {
                        Image(systemName: "note.text")
                            .foregroundColor(.green)
                    }
                    
                    Text(retainer.notes)
                        .font(.callout)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
}

private struct StatBadge: View {
    let label: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 2) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.caption2)
                Text(value)
                    .font(.system(.body, design: .monospaced))
            }
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.secondary.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

private struct EmptyRetainerSlotView: View {
    let slotNumber: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Retainer Slot \(slotNumber)")
                .font(.headline)
                .foregroundColor(.secondary)
            Text("Empty Slot")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(12)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .frame(maxWidth: .infinity)
    }
}

private struct ExampleRetainersCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.yellow)
                Text("Example Retainers")
                    .font(.headline)
            }
            Text("""
                These examples can be re-skinned for non-fantasy genres, a pet becoming a drone, a spirit becoming a limited AI, etc.

                • Apprentice
                • Squire
                • Cook
                • Butler
                • Guardian
                • Lover
                • Teacher
                • Thief
                • Ward
                • Relative
                • Student
                • Guide
                • Medic
                • Chronicler
                • Fan
                • Bodyguard
                • Thug
                • Aide de Camp
                • Maid
                • Secretary
                • Accountant
                • Assistant
                • Taster
                • Jester
                • Priest
                • Interpreter
                • Librarian
                • Pet
                • Familiarus
                • Spirit
                """)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(12)
                .background(Color.yellow.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .frame(maxWidth: .infinity)
        }
        .padding(.top, 12)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Supporting Views
private struct FeatureRow: View {
    let icon: String
    let color: Color
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 16))
                .frame(width: 16)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 4)
        .frame(maxWidth: .infinity)
    }
}

private struct BenefitRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(.purple)
                .font(.system(size: 16))
                .frame(width: 16)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 4)
        .frame(maxWidth: .infinity)
    }
}

private struct TagWrappingView: View {
    let tags: [String]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(tags, id: \.self) { tag in
                    Text(tag)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}
