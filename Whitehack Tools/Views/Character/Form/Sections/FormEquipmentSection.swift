import SwiftUI
import PhosphorSwift
#if os(iOS)
import UIKit
#else
import AppKit
#endif

// MARK: - Debug Border Modifier
extension View {
    func debugBorder(_ color: Color = .random) -> some View {
        self.border(color, width: 1)
    }
}

extension Color {
    static var random: Color {
        Color(
            red: Double.random(in: 0...1),
            green: Double.random(in: 0...1),
            blue: Double.random(in: 0...1)
        )
    }
}

public struct FormEquipmentSection: View {
    @Binding var gear: [Gear]
    @State private var editingGearId: UUID?
    @State private var isAddingNew = false {
        didSet {
            if !isAddingNew {
                selectedGearName = nil
                editingNewGear = nil
            }
        }
    }
    @State private var editingNewGear: Gear? {
        didSet {
            selectedGearName = nil
        }
    }
    @State private var selectedGearName: String? {
        didSet {
            if selectedGearName == nil {
            }
        }
    }
    
    private var backgroundColor: Color {
        #if os(iOS)
        return Color(.white)
        #else
        return Color(nsColor: .white)
        #endif
    }
    
    private func createGearFromSelection(_ gearName: String) {
        if gearName == "custom" {
            let gear = Gear(
                id: UUID(),
                name: "",
                weight: "No size",
                special: "",
                quantity: 1,
                isEquipped: false,
                isStashed: false,
                isMagical: false,
                isCursed: false,
                isContainer: false
            )
            editingNewGear = gear
        } else if let gearData = GearData.gear.first(where: { $0.name == gearName }) {
            let newGear = Gear(
                id: UUID(),
                name: gearData.name,
                weight: gearData.weight,
                special: gearData.special,
                quantity: 1,
                isEquipped: false,
                isStashed: false,
                isMagical: false,
                isCursed: false,
                isContainer: gearData.isContainer
            )
            withAnimation {
                gear.append(newGear)
                isAddingNew = false
                selectedGearName = nil
            }
        }
    }
    
    public static func getWeightDisplayText(_ weight: String) -> String {
        switch weight {
        case "No size": return "No size (100/slot)"
        case "Minor": return "Minor (2/slot)"
        case "Regular": return "Regular (1 slot)"
        case "Heavy": return "Heavy (2 slots)"
        default: return weight
        }
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            if !gear.isEmpty {
                equipmentListView
            } else if !isAddingNew && editingNewGear == nil {
                emptyStateView
            }
            
            if let editingGear = editingNewGear {
                editingGearView(editingGear)
            }
            
            if isAddingNew && editingNewGear == nil {
                addGearMenu
            } else if !gear.isEmpty && !isAddingNew && editingNewGear == nil {
                addAnotherButton
            } else if !isAddingNew && editingNewGear == nil {
                addFirstButton
            }
        }
    }
    
    private var equipmentListView: some View {
        VStack(spacing: 12) {
            ForEach(gear) { gearItem in
                Group {
                    if editingGearId == gearItem.id {
                        GearEditRow(gear: gearItem) { updatedGear in
                            if let index = gear.firstIndex(where: { $0.id == gearItem.id }) {
                                gear[index] = updatedGear
                                editingGearId = nil
                            }
                        } onCancel: {
                            editingGearId = nil
                        }
                        .padding()
                        .background(.background)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                        .padding(.bottom, 16)
                    } else {
                        GearRow(
                            gear: gearItem,
                            onEdit: {
                                editingGearId = gearItem.id
                            },
                            onDelete: {
                                gear.removeAll(where: { $0.id == gearItem.id })
                            }
                        )
                    }
                }
            }
        }
        .padding(.bottom, 20)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 8) {
            IconFrame(icon: Ph.prohibit.bold, color: .gray)
            Text("No Equipment")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 4)
        .padding(.bottom, 24)
    }
    
    private func editingGearView(_ editingGear: Gear) -> some View {
        GearEditRow(gear: editingGear) { updatedGear in
            gear.append(updatedGear)
            editingNewGear = nil
            isAddingNew = false
        } onCancel: {
            editingNewGear = nil
            isAddingNew = false
        }
        .padding()
        .background(.background)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        .padding(.bottom, 16)
    }
    
    private var addGearMenu: some View {
        VStack(spacing: 8) {
            Menu {
                ForEach(GearData.gear, id: \.name) { gearItem in
                    Button(gearItem.name) {
                        selectedGearName = gearItem.name
                        createGearFromSelection(gearItem.name)
                    }
                }
                
                Divider()
                
                Button("Custom Item") {
                    selectedGearName = "custom"
                    createGearFromSelection("custom")
                }
            } label: {
                HStack {
                    Text("Select Item")
                        .padding(.horizontal, 8)
                }
                .frame(maxWidth: .infinity, minHeight: 32)
            }
            .menuStyle(.borderlessButton)
            .background(backgroundColor)
            .cornerRadius(4)
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.primary.opacity(0.2), lineWidth: 0.5)
            )
            .padding(.horizontal, 16)
            
            if let selectedGearName = selectedGearName {
                Text(selectedGearName)
            }
            
            Button(action: {
                isAddingNew = false
            }) {
                Label("Cancel", systemImage: "xmark.circle.fill")
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical, 16)
    }
    
    private var addAnotherButton: some View {
        Button(action: {
            withAnimation {
                isAddingNew = true
            }
        }) {
            Label("Add Another Item", systemImage: "plus.circle.fill")
                .foregroundColor(.blue)
        }
    }
    
    private var addFirstButton: some View {
        Button(action: {
            withAnimation {
                isAddingNew = true
            }
        }) {
            Label("Add Your First Item", systemImage: "plus.circle.fill")
                .foregroundColor(.blue)
        }
        .padding(.bottom, 8)
    }
}

struct GearRow: View {
    let gear: Gear
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Item Name")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Label {
                        Text(gear.name)
                    } icon: {
                        IconFrame(icon: gear.isContainer ? Ph.package.bold : Ph.bagSimple.bold,
                                color: gear.isContainer ? .orange : .purple)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Quantity")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Label {
                        Text("\(gear.quantity)")
                    } icon: {
                        IconFrame(icon: Ph.stack.bold, color: .green)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Weight")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Label {
                        Text(FormEquipmentSection.getWeightDisplayText(gear.weight))
                    } icon: {
                        IconFrame(icon: Ph.scales.bold, color: .blue)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Status")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    HStack(spacing: 16) {
                        Label {
                            Text(gear.isEquipped ? "Equipped" : "Unequipped")
                        } icon: {
                            IconFrame(icon: Ph.bagSimple.bold, color: gear.isEquipped ? .green : .gray)
                        }
                        Label {
                            Text(gear.isStashed ? "Stashed" : "On Person")
                        } icon: {
                            IconFrame(icon: gear.isStashed ? Ph.warehouse.bold : Ph.user.bold,
                                    color: gear.isStashed ? .orange : .gray)
                        }
                    }
                }
                
                if gear.isMagical || gear.isCursed || gear.isContainer {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Properties")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 12) {
                            if gear.isContainer {
                                Label {
                                    Text("Container")
                                } icon: {
                                    IconFrame(icon: Ph.package.bold, color: .orange)
                                }
                            }
                            
                            if gear.isMagical {
                                Label {
                                    Text("Magical")
                                } icon: {
                                    IconFrame(icon: Ph.sparkle.bold, color: .blue)
                                }
                            }
                            
                            if gear.isCursed {
                                Label {
                                    Text("Cursed")
                                } icon: {
                                    IconFrame(icon: Ph.skull.bold, color: .red)
                                }
                            }
                        }
                    }
                }
                
                if !gear.special.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Special Properties")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Label {
                            Text(gear.special)
                        } icon: {
                            IconFrame(icon: Ph.star.bold, color: .purple)
                        }
                    }
                }
            }
            .allowsHitTesting(false)
            
            Divider()
            
            HStack {
                Button(action: onEdit) {
                    Label {
                        Text("Edit")
                            .fontWeight(.medium)
                    } icon: {
                        Image(systemName: "pencil.circle.fill")
                    }
                    .foregroundColor(.blue)
                }
                
                Spacer()
                
                Button(action: onDelete) {
                    Label {
                        Text("Delete")
                            .fontWeight(.medium)
                    } icon: {
                        Image(systemName: "trash.circle.fill")
                    }
                    .foregroundColor(.red)
                }
            }
            .padding(.top, 4)
        }
        .groupCardStyle()
    }
}

struct GearEditRow: View {
    @Environment(\.dismiss) private var dismiss
    
    let gear: Gear
    let onSave: (Gear) -> Void
    let onCancel: () -> Void
    
    // Basic Properties
    @State private var name: String
    @State private var weight: String
    @State private var special: String
    @State private var quantity: Int
    @State private var quantityString: String
    @State private var isEquipped: Bool
    @State private var isStashed: Bool
    @State private var isMagical: Bool
    @State private var isCursed: Bool
    @State private var isContainer: Bool
    
    // Focus state for text fields
    @FocusState private var focusedField: CharacterFormView.Field?
    
    init(gear: Gear, onSave: @escaping (Gear) -> Void, onCancel: @escaping () -> Void) {
        self.gear = gear
        self.onSave = onSave
        self.onCancel = onCancel
        
        _name = State(initialValue: gear.name)
        _weight = State(initialValue: gear.weight)
        _special = State(initialValue: gear.special)
        _quantity = State(initialValue: gear.quantity)
        _quantityString = State(initialValue: "\(gear.quantity)")
        _isEquipped = State(initialValue: gear.isEquipped)
        _isStashed = State(initialValue: gear.isStashed)
        _isMagical = State(initialValue: gear.isMagical)
        _isCursed = State(initialValue: gear.isCursed)
        _isContainer = State(initialValue: gear.isContainer)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Name Section
            VStack(alignment: .leading, spacing: 4) {
                Text("Item Name")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Label {
                    TextField("Item Name", text: $name)
                        .textFieldStyle(.roundedBorder)
                } icon: {
                    IconFrame(icon: Ph.bagSimple.bold, color: .purple)
                }
            }
            
            // Quantity Section
            VStack(alignment: .leading, spacing: 4) {
                Text("Quantity")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Label {
                    HStack {
                        NumericTextField(text: $quantityString, field: .equipmentQuantity, minValue: 1, maxValue: 99, focusedField: $focusedField)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 60)
                            .focused($focusedField, equals: .equipmentQuantity)
                            .onChange(of: focusedField) { newValue in
                                print("🔥 FOCUS CHANGED - current quantity: \(quantity), string: '\(quantityString)'")
                                if newValue != .equipmentQuantity && quantityString.isEmpty {  // Field lost focus and is empty
                                    print("🔥 SETTING EMPTY TO 1")
                                    quantityString = "1"
                                    quantity = 1
                                }
                            }
                            .onChange(of: quantityString) { newValue in
                                print("🔥 STRING CHANGED TO: '\(newValue)'")
                                if let value = Int(newValue) {
                                    print("🔥 PARSED INT: \(value)")
                                    quantity = max(1, min(99, value))
                                    print("🔥 SET QUANTITY TO: \(quantity)")
                                }
                            }
                        Stepper("", value: Binding(
                            get: { quantity },
                            set: { newValue in
                                print("🔥 STEPPER SETTING TO: \(newValue)")
                                quantity = newValue
                                quantityString = "\(newValue)"
                            }
                        ), in: 1...99)
                            .labelsHidden()
                    }
                } icon: {
                    IconFrame(icon: Ph.stack.bold, color: .green)
                }
            }
            
            // Weight Section
            weightSection
            
            // Special Properties Section
            VStack(alignment: .leading, spacing: 4) {
                Text("Special Properties")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                TextField("Special Properties", text: $special)
                    .textFieldStyle(.roundedBorder)
            }
            
            // Status Section
            GearEditTogglesSection(
                isEquipped: $isEquipped,
                isStashed: $isStashed,
                isMagical: $isMagical,
                isCursed: $isCursed,
                isContainer: $isContainer
            )
            
            Spacer()
            
            // Save/Cancel Buttons
            Divider()
            
            HStack(spacing: 20) {
                Button {
                    onCancel()
                } label: {
                    Label {
                        Text("Cancel")
                            .fontWeight(.medium)
                    } icon: {
                        Image(systemName: "xmark.circle.fill")
                    }
                    .foregroundColor(.red)
                }
                
                Spacer()
                
                Button {
                    let updatedGear = Gear(
                        id: gear.id,
                        name: name,
                        weight: weight,
                        special: special,
                        quantity: quantity,
                        isEquipped: isEquipped,
                        isStashed: isStashed,
                        isMagical: isMagical,
                        isCursed: isCursed,
                        isContainer: isContainer
                    )
                    onSave(updatedGear)
                } label: {
                    Label {
                        Text("Save")
                            .fontWeight(.medium)
                    } icon: {
                        Image(systemName: "checkmark.circle.fill")
                    }
                    .foregroundColor(.blue)
                }
            }
            .padding(.top, 12)
        }
    }
    
    private var weightSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Weight")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Label {
                Menu {
                    Button("No size (100/slot)") {
                        weight = "No size"
                    }
                    Button("Minor (2/slot)") {
                        weight = "Minor"
                    }
                    Button("Regular (1 slot)") {
                        weight = "Regular"
                    }
                    Button("Heavy (2 slots)") {
                        weight = "Heavy"
                    }
                } label: {
                    Text(FormEquipmentSection.getWeightDisplayText(weight))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .menuStyle(.borderlessButton)
                .frame(maxWidth: .infinity)
            } icon: {
                IconFrame(icon: Ph.scales.bold, color: .blue)
            }
        }
    }
}

struct GearEditTogglesSection: View {
    @Binding var isEquipped: Bool
    @Binding var isStashed: Bool
    @Binding var isMagical: Bool
    @Binding var isCursed: Bool
    @Binding var isContainer: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                IconFrame(icon: Ph.package.bold, color: isContainer ? .orange : .gray)
                #if os(macOS)
                Toggle("", isOn: $isContainer)
                    .toggleStyle(.switch)
                    .labelsHidden()
                Text(isContainer ? "Container" : "Not a Container")
                #else
                Toggle(isContainer ? "Container" : "Not a Container", isOn: $isContainer)
                #endif
            }
            
            HStack {
                IconFrame(icon: Ph.bagSimple.bold, color: isEquipped ? .green : .gray)
                #if os(macOS)
                Toggle("", isOn: Binding(
                    get: { isEquipped },
                    set: { newValue in
                        isEquipped = newValue
                        if newValue {
                            isStashed = false
                        }
                    }
                ))
                .toggleStyle(.switch)
                .labelsHidden()
                Text(isEquipped ? "Equipped" : "Unequipped")
                #else
                Toggle(isEquipped ? "Equipped" : "Unequipped", isOn: Binding(
                    get: { isEquipped },
                    set: { newValue in
                        isEquipped = newValue
                        if newValue {
                            isStashed = false
                        }
                    }
                ))
                #endif
            }
            
            HStack {
                IconFrame(icon: isStashed ? Ph.warehouse.bold : Ph.user.bold,
                        color: isStashed ? .orange : .gray)
                #if os(macOS)
                Toggle("", isOn: Binding(
                    get: { isStashed },
                    set: { newValue in
                        isStashed = newValue
                        if newValue {
                            isEquipped = false
                        }
                    }
                ))
                .toggleStyle(.switch)
                .labelsHidden()
                Text(isStashed ? "Stashed" : "On Person")
                #else
                Toggle(isStashed ? "Stashed" : "On Person", isOn: Binding(
                    get: { isStashed },
                    set: { newValue in
                        isStashed = newValue
                        if newValue {
                            isEquipped = false
                        }
                    }
                ))
                #endif
            }
            
            HStack {
                IconFrame(icon: Ph.sparkle.bold, color: isMagical ? .purple : .gray)
                #if os(macOS)
                Toggle("", isOn: $isMagical)
                    .toggleStyle(.switch)
                    .labelsHidden()
                Text(isMagical ? "Magical" : "Not Magical")
                #else
                Toggle(isMagical ? "Magical" : "Not Magical", isOn: $isMagical)
                #endif
            }
            
            HStack {
                IconFrame(icon: Ph.skull.bold, color: isCursed ? .red : .gray)
                #if os(macOS)
                Toggle("", isOn: $isCursed)
                    .toggleStyle(.switch)
                    .labelsHidden()
                Text(isCursed ? "Cursed" : "Not Cursed")
                #else
                Toggle(isCursed ? "Cursed" : "Not Cursed", isOn: $isCursed)
                #endif
            }
        }
    }
}

private extension View {
    func groupCardStyle() -> some View {
        self
            .padding()
            .background(.background)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
}
