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
                HStack(spacing: 4) {
                    Ph.crown.bold
                        .frame(width: 20, height: 20)
                        .foregroundColor(.orange)
                    Text("The Fortunate")
                        .font(.headline)
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
                .background(Color.orange.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .frame(maxWidth: .infinity)

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
                .background(Color.yellow.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .frame(maxWidth: .infinity)

            HStack {
                Ph.check.bold
                    .frame(width: 16, height: 16)
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
                    .clipShape(RoundedRectangle(cornerRadius: 8))
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
                    HStack(spacing: 4) {
                        Ph.users.bold
                            .frame(width: 20, height: 20)
                            .foregroundColor(.blue)
                        Text("Retainers")
                            .font(.headline)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Text("\(retainers.count)/\(availableSlots)")
                            .font(.subheadline)
                            .foregroundColor(Color.secondary)
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
            
            if retainers.isEmpty {
                // No retainers message
                HStack {
                    Ph.warningCircle.bold
                        .frame(width: 16, height: 16)
                        .foregroundColor(Color.secondary)
                    Text("No retainers")
                        .font(.subheadline)
                        .foregroundColor(Color.secondary)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.secondary.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 6))
            } else if availableSlots == 0 {
                // No slots available message
                HStack {
                    Ph.warningCircle.bold
                        .frame(width: 16, height: 16)
                        .foregroundColor(Color.secondary)
                    Text("No retainer slots available at current level")
                        .font(.subheadline)
                        .foregroundColor(Color.secondary)
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
        Button {
            // addRetainer()
        } label: {
            HStack {
                Ph.warningCircle.bold
                    .frame(width: 16, height: 16)
                    .foregroundColor(Color.secondary)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Empty Slot \(slotNumber)")
                        .font(.headline)
                    Text("Add a retainer")
                        .font(.subheadline)
                        .foregroundColor(Color.secondary)
                }
                
                Spacer()
            }
            .padding()
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
        }
    }
    
    private var filledSlotView: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with name and type
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 4) {
                        Ph.user.bold
                            .frame(width: 20, height: 20)
                            .foregroundColor(.blue)
                        Text(retainer.name)
                            .font(.headline)
                    }
                    
                    HStack(spacing: 4) {
                        Ph.users.bold
                            .frame(width: 16, height: 16)
                            .foregroundColor(.orange)
                        Text(retainer.type)
                            .font(.headline)
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
            
            // Type
            Text(retainer.type)
                .font(.headline)
                .padding(.vertical, 4)
            
            HStack(spacing: 12) {
                StatBadge(
                    label: "HD",
                    value: "\(retainer.hitDice)",
                    icon: AnyView(Ph.diceFive.bold.frame(width: 16, height: 16))
                )
                StatBadge(
                    label: "DF",
                    value: "\(retainer.defenseFactor)",
                    icon: AnyView(Ph.shield.bold.frame(width: 16, height: 16))
                )
                StatBadge(
                    label: "MV",
                    value: "\(retainer.movement)",
                    icon: AnyView(Ph.personSimpleRun.bold.frame(width: 16, height: 16))
                )
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            // HP
            HStack(spacing: 4) {
                Text("HP")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("\(retainer.currentHP)/\(retainer.maxHP)")
                    .font(.system(.body, design: .monospaced))
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            // Keywords
            if !retainer.keywords.isEmpty {
                VStack(alignment: .center, spacing: 4) {
                    HStack(spacing: 4) {
                        Ph.tag.bold
                            .frame(width: 16, height: 16)
                            .foregroundColor(.purple)
                        Text("Keywords")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(retainer.keywords, id: \.self) { keyword in
                                Text(keyword)
                                    .font(.callout)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.purple.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                            }
                        }
                        .padding(.horizontal, 4)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            
            // Notes
            if !retainer.notes.isEmpty {
                VStack(alignment: .center, spacing: 4) {
                    HStack(spacing: 4) {
                        Ph.noteBlank.bold
                            .frame(width: 16, height: 16)
                            .foregroundColor(.purple)
                        Text("Notes")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Text(retainer.notes)
                        .font(.callout)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}

private struct StatBadge: View {
    let label: String
    let value: String
    let icon: AnyView

    var body: some View {
        VStack(spacing: 2) {
            HStack(spacing: 4) {
                icon
                Text(value)
                    .font(.system(.body, design: .monospaced))
            }
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 8))
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
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
