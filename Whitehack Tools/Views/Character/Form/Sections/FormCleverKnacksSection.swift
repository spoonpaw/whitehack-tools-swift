import SwiftUI

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
                // Daily Power Card
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    HStack {
                        Text("Daily Power")
                            .font(.title3)
                            .fontWeight(.medium)
                        Spacer()
                        ZStack {
                            Circle()
                                .fill(Color.red.opacity(0.2))
                                .frame(width: 44, height: 44)
                            Image(systemName: "sparkles")
                                .foregroundColor(.red)
                                .font(.system(size: 20))
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    Toggle(isOn: $cleverKnackOptions.hasUsedUnorthodoxBonus) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Unorthodox Solution")
                                .fontWeight(.medium)
                            Text("Daily +6 bonus for non-combat problem solving")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal)
                    .toggleStyle(SwitchToggleStyle(tint: .red))
                    
                    HStack {
                        Image(systemName: cleverKnackOptions.hasUsedUnorthodoxBonus ? "exclamationmark.triangle.fill" : "checkmark.circle.fill")
                        Text(cleverKnackOptions.hasUsedUnorthodoxBonus ? "Power has been used today" : "Power is available to use")
                            .font(.caption)
                    }
                    .foregroundColor(cleverKnackOptions.hasUsedUnorthodoxBonus ? .red : .green)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(colorScheme == .dark ? Color(.systemGray6) : .white)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                )
                .shadow(color: Color.primary.opacity(0.05), radius: 2, x: 0, y: 1)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                // Knack Slots
                ForEach(0..<availableSlots, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 20) {
                        // Header
                        HStack(alignment: .center, spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(Color.yellow.opacity(0.2))
                                    .frame(width: 44, height: 44)
                                Image(systemName: "lightbulb.fill")
                                    .foregroundColor(.yellow)
                                    .font(.system(size: 20))
                            }
                            
                            Text("Knack Slot \(index + 1)")
                                .font(.title3)
                                .fontWeight(.medium)
                        }
                        .padding(.horizontal)
                        .padding(.top, 4)
                        
                        // Knack Selection or Display
                        if let selectedKnack = cleverKnackOptions.getKnack(at: index) {
                            VStack(alignment: .leading, spacing: 16) {
                                // Selected Knack Header
                                HStack {
                                    Text(selectedKnack.name)
                                        .font(.headline)
                                        .foregroundColor(.yellow)
                                    
                                    Spacer()
                                    
                                    Menu {
                                        ForEach(availableKnacks(for: index), id: \.self) { knack in
                                            Button(action: {
                                                cleverKnackOptions.setKnack(knack, at: index)
                                            }) {
                                                Text(knack.name)
                                            }
                                        }
                                        
                                        Divider()
                                        
                                        Button(role: .destructive, action: {
                                            cleverKnackOptions.setKnack(nil, at: index)
                                        }) {
                                            Text("Remove Knack")
                                        }
                                    } label: {
                                        Text("Change")
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                // Description
                                Text(selectedKnack.description)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                                
                                // Combat Exploiter Special Case
                                if selectedKnack == .combatExploiter {
                                    VStack(alignment: .leading, spacing: 16) {
                                        Text("Combat Die")
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                        
                                        HStack {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("D10 Damage Die")
                                                    .font(.subheadline)
                                                    .fontWeight(.medium)
                                                Text(cleverKnackOptions.slots[index].hasUsedCombatDie ? "Used this battle" : "Available this battle")
                                                    .font(.subheadline)
                                                    .foregroundColor(cleverKnackOptions.slots[index].hasUsedCombatDie ? .red : .green)
                                            }
                                            
                                            Spacer()
                                            
                                            Toggle("", isOn: Binding(
                                                get: { cleverKnackOptions.slots[index].hasUsedCombatDie },
                                                set: { newValue in
                                                    var updatedOptions = cleverKnackOptions
                                                    updatedOptions.setHasUsedCombatDie(newValue, at: index)
                                                    self.cleverKnackOptions = updatedOptions
                                                }
                                            ))
                                            .toggleStyle(SwitchToggleStyle(tint: .red))
                                        }
                                    }
                                    .padding(.top, 12)
                                }
                            }
                            .padding(20)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .padding(.horizontal)
                        } else {
                            // Empty Slot
                            Menu {
                                ForEach(availableKnacks(for: index), id: \.self) { knack in
                                    Button(action: {
                                        cleverKnackOptions.setKnack(knack, at: index)
                                    }) {
                                        Text(knack.name)
                                    }
                                }
                            } label: {
                                HStack {
                                    Text("Select a Knack")
                                        .font(.headline)
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .padding(.horizontal)
                                .background(Color.yellow.opacity(0.1))
                                .foregroundColor(.yellow)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(colorScheme == .dark ? Color(.systemGray6) : .white)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                    )
                    .shadow(color: Color.primary.opacity(0.05), radius: 2, x: 0, y: 1)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
            } header: {
                Label {
                    Text("Clever Features")
                        .font(.headline)
                        .foregroundColor(.primary)
                } icon: {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(.yellow)
                }
            }
            .listStyle(PlainListStyle())
            .listSectionSeparator(.hidden)
        }
    }
}
