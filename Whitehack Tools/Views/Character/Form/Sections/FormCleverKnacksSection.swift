import SwiftUI
import PhosphorSwift

struct FormCleverKnacksSection: View {
    let characterClass: CharacterClass
    let level: Int
    @Binding var cleverKnackOptions: CleverKnackOptions
    @Environment(\.colorScheme) var colorScheme
    
    private var availableSlots: Int {
        guard characterClass == .clever else { return 0 }
        let stats = AdvancementTables.shared.stats(for: characterClass, at: level)
        return stats.slots
    }
    
    private func availableKnacks(for currentIndex: Int) -> [CleverKnack] {
        let selectedKnacks = Set(cleverKnackOptions.slots.enumerated().compactMap { index, slot in
            index != currentIndex ? slot.knack : nil
        })
        return CleverKnack.allCases.filter { !selectedKnacks.contains($0) }
    }
    
    var body: some View {
        if characterClass == .clever {
            Section {
                DailyPowerCard(cleverKnackOptions: $cleverKnackOptions, colorScheme: colorScheme)
                
                ForEach(0..<availableSlots, id: \.self) { index in
                    KnackSlotCard(
                        index: index,
                        cleverKnackOptions: $cleverKnackOptions,
                        availableKnacks: availableKnacks(for: index),
                        colorScheme: colorScheme
                    )
                }
            } header: {
                SectionHeader(title: "The Clever", icon: Image(systemName: "brain.head.profile"))
            }
            .listStyle(PlainListStyle())
            .listSectionSeparator(.hidden)
        }
    }
}

// MARK: - Daily Power Card
private struct DailyPowerCard: View {
    @Binding var cleverKnackOptions: CleverKnackOptions
    let colorScheme: ColorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Daily Power")
                    .font(.title3)
                    .fontWeight(.medium)
                Spacer()
                ZStack {
                    Circle()
                        .fill(Color.red.opacity(0.2))
                        .frame(width: 44, height: 44)
                        .shadow(color: .red.opacity(0.2), radius: 4, x: 0, y: 2)
                    Image(systemName: "sparkles")
                        .foregroundColor(.red)
                        .font(.system(size: 20))
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            VStack(spacing: 16) {
                Toggle(isOn: $cleverKnackOptions.hasUsedUnorthodoxBonus) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Unorthodox Solution")
                            .fontWeight(.medium)
                        Text(cleverKnackOptions.hasUsedUnorthodoxBonus ? 
                            "Already used today - must rest to regain" :
                            "Available to use: +6 bonus for non-combat problem solving")
                            .font(.caption)
                            .foregroundColor(cleverKnackOptions.hasUsedUnorthodoxBonus ? .red : .green)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
                
                if cleverKnackOptions.hasUsedUnorthodoxBonus {
                    HStack(alignment: .top, spacing: 4) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                            .shadow(color: .red.opacity(0.3), radius: 2, x: 0, y: 1)
                        Text("Power has been used today")
                            .font(.caption)
                            .foregroundColor(.red)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    HStack(alignment: .top, spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .shadow(color: .green.opacity(0.3), radius: 2, x: 0, y: 1)
                        Text("Power is ready to use")
                            .font(.caption)
                            .foregroundColor(.green)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(colorScheme == .dark ? Color(.systemGray6) : .white)
        )
        .compositingGroup()
        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .padding(.horizontal, 2)
    }
}

// MARK: - Knack Slot Card
private struct KnackSlotCard: View {
    let index: Int
    @Binding var cleverKnackOptions: CleverKnackOptions
    let availableKnacks: [CleverKnack]
    let colorScheme: ColorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SlotHeader(index: index)
            
            if let selectedKnack = cleverKnackOptions.getKnack(at: index) {
                SelectedKnackView(
                    knack: selectedKnack,
                    index: index,
                    cleverKnackOptions: $cleverKnackOptions
                )
            } else {
                EmptySlotView(
                    index: index,
                    availableKnacks: availableKnacks,
                    cleverKnackOptions: $cleverKnackOptions
                )
            }
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(colorScheme == .dark ? Color(.systemGray6) : .white)
        )
        .compositingGroup()
        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .padding(.horizontal, 2)
    }
}

// MARK: - Slot Header
private struct SlotHeader: View {
    let index: Int
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 44, height: 44)
                    .shadow(color: .blue.opacity(0.2), radius: 4, x: 0, y: 2)
                Text("\(index + 1)")
                    .foregroundColor(.blue)
                    .font(.title2.bold())
            }
            Text("Knack Slot \(index + 1)")
                .font(.title3)
                .fontWeight(.medium)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 20)
    }
}

// MARK: - Selected Knack View
private struct SelectedKnackView: View {
    let knack: CleverKnack
    let index: Int
    @Binding var cleverKnackOptions: CleverKnackOptions
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(knack.name)
                    .font(.headline)
                Spacer()
                Button(action: {
                    var updatedOptions = cleverKnackOptions
                    updatedOptions.removeKnack(at: index)
                    cleverKnackOptions = updatedOptions
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                        .font(.title3)
                        .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            .padding(.horizontal)
            
            Text(knack.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.horizontal)
                .fixedSize(horizontal: false, vertical: true)
            
            if knack == .combatExploiter {
                VStack(spacing: 16) {
                    Toggle(isOn: Binding(
                        get: { cleverKnackOptions.isKnackUsed(at: index) },
                        set: { newValue in
                            var updatedOptions = cleverKnackOptions
                            updatedOptions.setKnackUsed(at: index, to: newValue)
                            cleverKnackOptions = updatedOptions
                        }
                    )) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Battle Usage")
                                .fontWeight(.medium)
                            Text(cleverKnackOptions.isKnackUsed(at: index) ?
                                "Already used this battle - resets after battle" :
                                "Available to use this battle")
                                .font(.caption)
                                .foregroundColor(cleverKnackOptions.isKnackUsed(at: index) ? .red : .green)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    
                    if cleverKnackOptions.isKnackUsed(at: index) {
                        HStack(alignment: .top, spacing: 4) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.red)
                                .shadow(color: .red.opacity(0.3), radius: 2, x: 0, y: 1)
                            Text("Knack has been used this battle")
                                .font(.caption)
                                .foregroundColor(.red)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        HStack(alignment: .top, spacing: 4) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .shadow(color: .green.opacity(0.3), radius: 2, x: 0, y: 1)
                            Text("Knack is ready to use")
                                .font(.caption)
                                .foregroundColor(.green)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            } else {
                Spacer()
                    .frame(height: 20)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Empty Slot View
private struct EmptySlotView: View {
    let index: Int
    let availableKnacks: [CleverKnack]
    @Binding var cleverKnackOptions: CleverKnackOptions
    
    var body: some View {
        Menu {
            ForEach(availableKnacks, id: \.self) { knack in
                Button(action: {
                    var updatedOptions = cleverKnackOptions
                    updatedOptions.setKnack(knack, at: index)
                    cleverKnackOptions = updatedOptions
                }) {
                    Text(knack.name)
                }
            }
        } label: {
            HStack {
                Text("Select a Knack")
                    .foregroundColor(.secondary)
                Spacer()
                Image(systemName: "chevron.up.chevron.down")
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity)
    }
}
