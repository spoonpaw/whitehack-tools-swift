import SwiftUI
import PhosphorSwift

public struct FormEquipmentSection: View {
    @Binding var gear: [Gear]
    @State private var editingGearId: UUID?
    @State private var isAddingNew = false {
        didSet {
            print("📦 Equipment: isAddingNew changed from \(oldValue) to \(isAddingNew)")
            if !isAddingNew {
                print("🧹 Equipment: Cleaning up states")
                selectedGearName = nil
                editingNewGear = nil
            }
        }
    }
    @State private var editingNewGear: Gear? {
        didSet {
            print("📦 Equipment: editingNewGear changed from \(String(describing: oldValue?.name)) to \(String(describing: editingNewGear?.name))")
        }
    }
    @State private var selectedGearName: String? {
        didSet {
            print("🎯 Equipment: selectedGearName changed from \(String(describing: oldValue)) to \(String(describing: selectedGearName))")
            if selectedGearName == nil {
                print("⚠️ Equipment: No gear selected")
            }
        }
    }
    
    private func createGearFromSelection(_ gearName: String) {
        print("🎯 Equipment: Creating gear from selection: \(gearName)")
        
        if gearName == "custom" {
            // Handle custom gear creation
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
            print("📦 Equipment: Found gear data: \(gearData)")
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
            print("🛠️ Equipment: Created gear:")
            print("   Name: \(newGear.name)")
            print("   Weight: \(newGear.weight)")
            print("   Special: \(newGear.special)")
            print("   Container: \(newGear.isContainer)")
            
            withAnimation {
                // For non-custom items, add them directly to the gear array
                gear.append(newGear)
                // Reset the adding state
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
        VStack(spacing: 16) {
            // Equipment list
            if !gear.isEmpty {
                VStack(spacing: 12) {
                    ForEach(gear) { gearItem in
                        Group {
                            if editingGearId == gearItem.id {
                                GearEditRow(
                                    gear: gearItem,
                                    onSave: { updatedGear in
                                        if let index = gear.firstIndex(where: { $0.id == gearItem.id }) {
                                            gear[index] = updatedGear
                                        }
                                        editingGearId = nil
                                    },
                                    onCancel: {
                                        editingGearId = nil
                                    }
                                )
                            } else {
                                GearRow(
                                    gear: gearItem,
                                    onEdit: {
                                        editingGearId = gearItem.id
                                    },
                                    onDelete: {
                                        gear.removeAll { $0.id == gearItem.id }
                                    }
                                )
                            }
                        }
                    }
                }
                .padding()
                #if os(macOS)
                .background(Color(nsColor: .windowBackgroundColor))
                .cornerRadius(12)
                #endif
            } else if !isAddingNew && editingNewGear == nil {
                VStack(spacing: 8) {
                    IconFrame(icon: Ph.bagSimple.bold, color: .gray)
                    Text("No Equipment")
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                #if os(macOS)
                .background(Color(nsColor: .windowBackgroundColor))
                .cornerRadius(12)
                #endif
            }
            
            if let editingGear = editingNewGear {
                GearEditRow(
                    gear: editingGear,
                    onSave: { newGear in
                        gear.append(newGear)
                        editingNewGear = nil
                        isAddingNew = false
                    },
                    onCancel: {
                        editingNewGear = nil
                        isAddingNew = false
                    }
                )
                .padding()
                #if os(macOS)
                .background(Color(nsColor: .windowBackgroundColor))
                .cornerRadius(12)
                #endif
            }
            
            if isAddingNew && editingNewGear == nil {
                VStack {
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
                        Text("Select Item")
                            .frame(maxWidth: .infinity)
                    }
                    .menuStyle(.borderlessButton)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    
                    Button(action: {
                        isAddingNew = false
                    }) {
                        Label("Cancel", systemImage: "xmark.circle.fill")
                            .foregroundColor(.red)
                    }
                }
            } else if !gear.isEmpty {
                Button(action: {
                    print("➕ Equipment: Add Another Item tapped")
                    withAnimation {
                        isAddingNew = true
                    }
                }) {
                    Label("Add Another Item", systemImage: "plus.circle.fill")
                        .foregroundColor(.blue)
                }
            } else {
                Button(action: {
                    print("➕ Equipment: Add First Item tapped")
                    withAnimation {
                        isAddingNew = true
                    }
                }) {
                    Label("Add Your First Item", systemImage: "plus.circle.fill")
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

struct GearRow: View {
    let gear: Gear
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Content Area
            VStack(alignment: .leading, spacing: 12) {
                // Name Section
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
                
                // Weight Section
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
                
                // Quantity Section
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
                
                // Status Section
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
            
            // Action Buttons
            HStack(spacing: 20) {
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
            .padding(.horizontal)
            .padding(.top, 4)
        }
        .padding()
        #if os(iOS)
        .background(Color(.secondarySystemBackground))
        #else
        .background(Color(nsColor: .controlBackgroundColor))
        #endif
        .cornerRadius(10)
    }
}

struct GearEditRow: View {
    @Environment(\.dismiss) private var dismiss
    
    let gear: Gear
    let onSave: (Gear) -> Void
    let onCancel: () -> Void
    
    @State private var name: String
    @State private var weight: String
    @State private var special: String
    @State private var isEquipped: Bool
    @State private var isStashed: Bool
    @State private var isMagical: Bool
    @State private var isCursed: Bool
    @State private var isContainer: Bool
    @State private var quantity: Int
    @State private var quantityString: String
    @State private var isProcessingAction = false
    @FocusState private var focusedField: Field?
    
    private enum Field {
        case quantity
    }
    
    init(gear: Gear, onSave: @escaping (Gear) -> Void, onCancel: @escaping () -> Void) {
        self.gear = gear
        self.onSave = onSave
        self.onCancel = onCancel
        
        _name = State(initialValue: gear.name)
        _weight = State(initialValue: gear.weight)
        _special = State(initialValue: gear.special)
        _isEquipped = State(initialValue: gear.isEquipped)
        _isStashed = State(initialValue: gear.isStashed)
        _isMagical = State(initialValue: gear.isMagical)
        _isCursed = State(initialValue: gear.isCursed)
        _isContainer = State(initialValue: gear.isContainer)
        _quantity = State(initialValue: gear.quantity)
        _quantityString = State(initialValue: "\(gear.quantity)")
    }
    
    private func validateQuantity() {
        if let newValue = Int(quantityString) {
            quantity = max(1, min(99, newValue))
        } else if quantityString.isEmpty {
            quantity = 1
        }
        quantityString = "\(quantity)"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Name Section
            VStack(alignment: .leading, spacing: 4) {
                Text("Item Name")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                TextField("Item name", text: $name)
                    .textFieldStyle(.roundedBorder)
            }
            
            // Weight Section
            VStack(alignment: .leading, spacing: 4) {
                Text("Weight")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Label {
                    Picker("", selection: $weight) {
                        Text("No size (100/slot)").tag("No size")
                        Text("Minor (2/slot)").tag("Minor")
                        Text("Regular (1 slot)").tag("Regular")
                        Text("Heavy (2 slots)").tag("Heavy")
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                } icon: {
                    IconFrame(icon: Ph.scales.bold, color: .blue)
                }
            }
            
            // Quantity Section
            VStack(alignment: .leading, spacing: 4) {
                Text("Quantity")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Label {
                    HStack {
                        TextField("Quantity", text: $quantityString)
                            .textFieldStyle(.roundedBorder)
                            #if os(iOS)
                            .keyboardType(.numberPad)
                            #endif
                            .frame(maxWidth: 80)
                            .focused($focusedField, equals: .quantity)
                            .onChange(of: quantityString) { newValue in
                                // Only allow numeric characters
                                let filtered = newValue.filter { $0.isNumber }
                                if filtered != newValue {
                                    quantityString = filtered
                                }
                            }
                            .onChange(of: focusedField) { field in
                                if field != .quantity {
                                    validateQuantity()
                                }
                            }
                        Stepper("", value: $quantity, in: 1...99)
                            .labelsHidden()
                            .onChange(of: quantity) { newValue in
                                quantityString = "\(newValue)"
                            }
                    }
                } icon: {
                    IconFrame(icon: Ph.stack.bold, color: .blue)
                }
            }
            
            // Special Section
            VStack(alignment: .leading, spacing: 4) {
                Text("Special Properties")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                TextField("Special properties", text: $special)
                    .textFieldStyle(.roundedBorder)
            }
            
            // Toggles Section
            VStack(alignment: .leading, spacing: 8) {
                // Container Toggle
                HStack {
                    IconFrame(icon: Ph.package.bold, color: isContainer ? .orange : .gray)
                    Toggle(isContainer ? "Container" : "Not a Container", isOn: $isContainer)
                }
                
                // Equipped Toggle
                HStack {
                    IconFrame(icon: Ph.bagSimple.bold, color: isEquipped ? .green : .gray)
                    Toggle(isEquipped ? "Equipped" : "Unequipped", isOn: Binding(
                        get: { isEquipped },
                        set: { newValue in
                            print("🔄 Equipment: Equipped status changed to: \(newValue)")
                            isEquipped = newValue
                            if newValue {
                                isStashed = false
                            }
                        }
                    ))
                }
                
                // Location Toggle
                HStack {
                    IconFrame(icon: isStashed ? Ph.warehouse.bold : Ph.user.bold,
                            color: isStashed ? .orange : .gray)
                    Toggle(isStashed ? "Stashed" : "On Person", isOn: Binding(
                        get: { isStashed },
                        set: { newValue in
                            print("🔄 Equipment: Stashed status changed to: \(newValue)")
                            isStashed = newValue
                            if newValue {
                                isEquipped = false
                            }
                        }
                    ))
                }
                
                // Magical Toggle
                HStack {
                    IconFrame(icon: Ph.sparkle.bold, color: isMagical ? .blue : .gray)
                    Toggle(isMagical ? "Magical" : "Not Magical", isOn: $isMagical)
                }
                
                // Cursed Toggle
                HStack {
                    IconFrame(icon: Ph.skull.bold, color: isCursed ? .red : .gray)
                    Toggle(isCursed ? "Cursed" : "Not Cursed", isOn: $isCursed)
                }
            }
            
            Divider()
            
            // Action Buttons
            HStack(spacing: 20) {
                Button {
                    guard !isProcessingAction else { return }
                    isProcessingAction = true
                    print("🔴 Cancel action starting")
                    onCancel()
                } label: {
                    Label("Cancel", systemImage: "xmark.circle.fill")
                        .foregroundColor(.red)
                }
                
                Spacer()
                
                Button {
                    guard !isProcessingAction else { return }
                    isProcessingAction = true
                    print("✅ Save action starting")
                    
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
                    Label("Save", systemImage: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
        }
        .padding()
        #if os(iOS)
        .background(Color(uiColor: .secondarySystemBackground))
        #else
        .background(Color(nsColor: .controlBackgroundColor))
        #endif
        .cornerRadius(10)
        .onAppear {
            // Reset state to match the input gear
            name = gear.name
            weight = gear.weight
            special = gear.special
            isEquipped = gear.isEquipped
            isStashed = gear.isStashed
            isMagical = gear.isMagical
            isCursed = gear.isCursed
            isContainer = gear.isContainer
            quantity = gear.quantity
        }
    }
}

private extension View {
    func groupCardStyle() -> some View {
        self
            #if os(iOS)
            .background(Color(.systemBackground))
            #else
            .background(Color(nsColor: .windowBackgroundColor))
            #endif
            .cornerRadius(12)
    }
}
