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
            VStack(alignment: .center, spacing: 4) {
                HStack {
                    Ph.crown.bold
                        .frame(width: 24, height: 24)
                    Text("The Fortunate")
                        .font(.title3.bold())
                }
                .frame(maxWidth: .infinity)
                
                VStack(spacing: 16) {
                    ClassOverviewCard()
                    FortunePowerCard(hasUsedFortune: character.fortunateOptions.hasUsedFortune)
                    StandingCard(standing: character.fortunateOptions.standing)
                    SignatureObjectCard(signatureObject: character.fortunateOptions.signatureObject)
                    RetainersCard(character: character)
                }
                .padding(20)
                .background(Color.purple.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.purple.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: Color.primary.opacity(0.05), radius: 2, x: 0, y: 1)
            }
        }
    }
}

// MARK: - Cards
private struct ClassOverviewCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Ph.crown.bold
                    .frame(width: 20, height: 20)
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
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 8) {
                FeatureRow(
                    icon: AnyView(Ph.shield.bold.frame(width: 16, height: 16)),
                    color: Color.blue,
                    title: "Combat Proficiency",
                    description: "Can use any weapon or armor without penalty."
                )
                FeatureRow(
                    icon: AnyView(Ph.users.bold.frame(width: 16, height: 16)),
                    color: Color.green,
                    title: "Social Advantages",
                    description: "+4 to charisma for retainer morale, +2 on reaction rolls, +6 on reputation rolls."
                )
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
        )
    }
}

private struct FortunePowerCard: View {
    let hasUsedFortune: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Ph.star.bold
                    .frame(width: 20, height: 20)
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
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.yellow.opacity(0.1))
                .cornerRadius(8)

            HStack {
                Spacer()
                Ph.check.bold
                    .frame(width: 16, height: 16)
                    .foregroundColor(hasUsedFortune ? .red : .green)
                Text(hasUsedFortune ? "Fortune power has been used this session" : "Fortune power is available")
                    .foregroundColor(hasUsedFortune ? .red : .green)
                Spacer()
            }
            .padding(8)
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(8)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
        )
    }
}

private struct StandingCard: View {
    let standing: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Ph.buildings.bold
                    .frame(width: 20, height: 20)
                    .foregroundColor(.purple)
                Text("Standing")
                    .font(.headline)
            }
            
            if !standing.isEmpty {
                Text(standing)
                    .font(.body)
                    .padding(12)
                    .background(Color.purple.opacity(0.1))
                    .cornerRadius(8)
                    .frame(maxWidth: .infinity)

                Text("When the referee thinks that the standing is relevant:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.top, 8)

                VStack(alignment: .leading, spacing: 8) {
                    BenefitRow(
                        icon: AnyView(Ph.users.bold.frame(width: 16, height: 16)),
                        title: "Faction Relations",
                        description: "Affiliated factions are considerably more helpful, and their enemies more vengeful. Others may distance themselves or show interest."
                    )
                    BenefitRow(
                        icon: AnyView(Ph.horse.bold.frame(width: 16, height: 16)),
                        title: "Species Benefits",
                        description: "Your species gives any applicable benefits regardless of attribute."
                    )
                    BenefitRow(
                        icon: AnyView(Ph.plusCircle.bold.frame(width: 16, height: 16)),
                        title: "Task Bonus",
                        description: "If standing and vocation align for a task, and the vocation is marked next to the applicable attribute, you get a +6 bonus."
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Text("No standing specified")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
        )
    }
}

private struct SignatureObjectCard: View {
    let signatureObject: SignatureObject

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Ph.seal.bold
                    .frame(width: 20, height: 20)
                    .foregroundColor(.orange)
                Text("Signature Object")
                    .font(.headline)
            }
            if !signatureObject.name.isEmpty {
                Text(signatureObject.name)
                    .font(.body)
                    .padding(12)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(8)
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
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
        )
    }
}

private struct RetainersCard: View {
    let character: PlayerCharacter
    
    var maxRetainers: Int {
        AdvancementTables.shared.stats(for: .fortunate, at: character.level).slots
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Ph.users.bold
                    .frame(width: 24, height: 24)
                Text("Retainers")
                    .font(.title3.bold())
            }
            
            Text("Retainers can grow in strength and serve as valuable allies. They have their own stats, attitudes, and can be played as alternate characters.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            ForEach(0..<maxRetainers, id: \.self) { index in
                if index < character.fortunateOptions.retainers.count {
                    RetainerDetailView(retainer: character.fortunateOptions.retainers[index])
                } else {
                    EmptyRetainerSlot()
                }
            }
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

private struct EmptyRetainerSlot: View {
    var body: some View {
        Text("Empty Retainer Slot")
            .font(.headline)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private struct RetainerDetailView: View {
    let retainer: Retainer
    
    var body: some View {
        if retainer.name.isEmpty {
            Text("Empty Retainer Slot")
                .font(.headline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        } else {
            VStack(alignment: .center, spacing: 12) {
                Text(retainer.name)
                    .font(.headline)
                
                if !retainer.type.isEmpty {
                    Text(retainer.type)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Ph.heart.bold
                        .frame(width: 16, height: 16)
                    Text(retainer.attitude)
                }
                
                if !retainer.keywords.isEmpty {
                    HStack {
                        Ph.tag.bold
                            .frame(width: 16, height: 16)
                        Text(retainer.keywords.joined(separator: ", "))
                    }
                }
                
                if !retainer.notes.isEmpty {
                    HStack {
                        Ph.note.bold
                            .frame(width: 16, height: 16)
                        Text(retainer.notes)
                    }
                }

                HStack(spacing: 12) {
                    StatBadge(
                        icon: AnyView(Ph.shield.bold.frame(width: 16, height: 16)),
                        value: "\(retainer.defenseFactor)",
                        label: "DF"
                    )
                    StatBadge(
                        icon: AnyView(Ph.arrowsOutCardinal.bold.frame(width: 16, height: 16)),
                        value: "\(retainer.movement)",
                        label: "MV"
                    )
                    StatBadge(
                        icon: AnyView(Ph.heartbeat.bold.frame(width: 16, height: 16)),
                        value: "\(retainer.currentHP)/\(retainer.maxHP)",
                        label: "HP"
                    )
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

private struct StatBadge: View {
    let icon: AnyView
    let value: String
    let label: String
    
    var body: some View {
        HStack(spacing: 4) {
            icon
                .foregroundColor(.blue)
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(8)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(6)
    }
}

private struct FeatureRow: View {
    let icon: AnyView
    let color: Color
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            icon
                .foregroundColor(color)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color.opacity(0.1))
        .cornerRadius(6)
    }
}

private struct BenefitRow: View {
    let icon: AnyView
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            icon
                .foregroundColor(.purple)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.purple.opacity(0.1))
        .cornerRadius(6)
    }
}
