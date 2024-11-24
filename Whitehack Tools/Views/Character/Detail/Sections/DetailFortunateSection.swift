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
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "person.2.fill")
                    .foregroundColor(.blue)
                Text("Retainers")
                    .font(.headline)
                Spacer()
                Text("\(retainers.count)/\(availableSlots)")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.secondary.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            Text("""
                As the only class, the Fortunate are allowed to have retainers that can grow in strength, like a chambermaid, a cook, an apprentice, or a squire. The Fortunate start the game with one retainer and gain slots for additional ones.

                A fortunate retainer has HD, DF, MV, and keywords as per the monster rules. DF and AV (HD + 10) may be reconsidered if their equipment changes, and HD increases at the Fortunate’s even levels.

                Retainers do their work within the confines of a written or otherwise established contract but also have ideas, feelings, and attitudes concerning their position and the Fortunate's standing. They are referee characters, but the player may switch into the retainer role for part of an adventure.
                """)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(12)
                .background(Color.blue.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .frame(maxWidth: .infinity)

            if availableSlots == 0 {
                Text("No retainer slots available at current level.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
            } else {
                ForEach(0..<availableSlots, id: \.self) { index in
                    if index < retainers.count {
                        RetainerDetailView(retainer: retainers[index], slotNumber: index + 1)
                    } else {
                        EmptyRetainerSlotView(slotNumber: index + 1)
                    }
                }
            }

            ExampleRetainersCard()
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Retainer Views
private struct RetainerDetailView: View {
    let retainer: Retainer
    let slotNumber: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Retainer Slot \(slotNumber)")
                .font(.headline)
                .foregroundColor(.blue)
            HStack {
                VStack(alignment: .leading) {
                    Text(retainer.name)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text(retainer.type)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                HStack(spacing: 16) {
                    StatBadge(value: retainer.hitDice, label: "HD", color: .red)
                    StatBadge(value: retainer.defenseFactor, label: "DF", color: .blue)
                    StatBadge(value: retainer.movement, label: "MV", color: .green)
                }
            }
            HStack(spacing: 16) {
                StatBadge(value: retainer.currentHP, label: "HP", color: .pink)
                StatBadge(value: retainer.maxHP, label: "Max HP", color: .pink)
            }
            .padding(.top, 4)
            if !retainer.keywords.isEmpty {
                TagWrappingView(tags: retainer.keywords)
                    .frame(height: 30)
                    .frame(maxWidth: .infinity)
            }
            if !retainer.notes.isEmpty {
                Text(retainer.notes)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(12)
        .background(Color.blue.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .frame(maxWidth: .infinity)
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
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 18))
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
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
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.purple)
                .font(.system(size: 18))
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 4)
        .frame(maxWidth: .infinity)
    }
}

private struct StatBadge: View {
    let value: Int
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 2) {
            Text("\(value)")
                .font(.subheadline)
                .fontWeight(.medium)
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(width: 60)
        .padding(4)
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 4))
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
