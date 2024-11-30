import SwiftUI
import PhosphorSwift

struct FormEquipmentSection: View {
    @Binding var gear: [Gear]
    @State private var editingGearId: UUID?
    @State private var isAddingNew = false {
        didSet {
            print("📦 isAddingNew changed to: \(isAddingNew)")
            if !isAddingNew {
                print("🧹 Cleaning up gear states")
                selectedGearName = nil
                editingNewGear = nil
            }
        }
    }
    @State private var editingNewGear: Gear? {
        didSet {
            print("📦 editingNewGear changed: \(String(describing: oldValue?.name)) -> \(String(describing: editingNewGear?.name))")
        }
    }
    @State private var selectedGearName: String? {
        didSet {
            print("🎯 selectedGearName changed: \(String(describing: oldValue)) -> \(String(describing: selectedGearName))")
            if selectedGearName == nil {
                print("⚠️ No gear selected")
                editingNewGear = nil
            }
        }
    }
    
    private func createGearFromSelection(_ gearName: String) {
        print("🎯 Creating gear from selection: \(gearName)")
        
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
        } else if let gearItem = GearData.gear.first(where: { $0.name == gearName }) {
            print("📦 Found gear data: \(gearItem)")
            let newGear = Gear(
                id: UUID(),
                name: gearItem.name,
                weight: gearItem.weight,
                special: gearItem.special,
                quantity: 1,
                isEquipped: false,
                isStashed: false,
                isMagical: false,
                isCursed: false,
                isContainer: gearItem.isContainer
            )
            print("🛠️ Created gear:")
            print("   Name: \(newGear.name)")
            print("   Weight: \(newGear.weight)")
            print("   Container: \(newGear.isContainer)")
            
            withAnimation {
                editingNewGear = newGear
            }
        }
    }
    
    var body: some View {
        Section {
            if gear.isEmpty && !isAddingNew {
                VStack(spacing: 12) {
                    Image(systemName: "bag.badge.minus")
                        .font(.system(size: 40))
                        .foregroundColor(.secondary)
                    
                    Text("No Equipment")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Button(action: {
                        print("📱 Add First Item tapped")
                        withAnimation {
                            isAddingNew = true
                        }
                    }) {
                        Label("Add Your First Item", systemImage: "plus.circle.fill")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            } else {
                if isAddingNew {
                    if let editingGear = editingNewGear {
                        GearEditRow(gear: editingGear) { newGear in
                            print("🟢 [FormEquipmentSection] Save action received for: \(newGear.name)")
                            gear.append(newGear)
                            print("✅ [FormEquipmentSection] Gear added to array")
                            withAnimation {
                                print("🔄 [FormEquipmentSection] Resetting form state after save")
                                isAddingNew = false
                            }
                        } onCancel: {
                            print("🔴 [FormEquipmentSection] Cancel action received")
                            withAnimation {
                                print("🔄 [FormEquipmentSection] Resetting form state after cancel")
                                selectedGearName = nil
                                editingNewGear = nil
                                isAddingNew = false
                            }
                        }
                        .id("\(editingGear.id)-\(editingGearId != nil)")
                    } else {
                        VStack(spacing: 12) {
                            Text("Select Item Type")
                                .font(.headline)
                            
                            Picker("Select Item", selection: $selectedGearName) {
                                Text("Select an Item").tag(nil as String?)
                                ForEach(GearData.gear.map { $0.name }.sorted(), id: \.self) { name in
                                    Text(name).tag(name as String?)
                                }
                                Text("Custom Item").tag("custom" as String?)
                            }
                            .pickerStyle(.menu)
                            .labelsHidden()
                            .onChange(of: selectedGearName) { newValue in
                                if let gearName = newValue {
                                    createGearFromSelection(gearName)
                                }
                            }
                            
                            HStack {
                                Spacer()
                                Button(action: {
                                    print("❌ Cancel button tapped")
                                    withAnimation {
                                        isAddingNew = false
                                    }
                                }) {
                                    Text("Cancel")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                ForEach(gear) { gearItem in
                    Group {
                        if editingGearId == gearItem.id {
                            GearEditRow(gear: gearItem) { updatedGear in
                                print("💾 Saving updated gear: \(updatedGear.name)")
                                if let index = gear.firstIndex(where: { $0.id == gearItem.id }) {
                                    print("🔄 Updating gear at index: \(index)")
                                    gear[index] = updatedGear
                                }
                                editingGearId = nil
                            } onCancel: {
                                print("❌ Canceling gear edit - reverting to original state")
                                editingGearId = nil
                            }
                            .id("\(gearItem.id)-\(editingGearId != nil)")
                        } else {
                            GearRow(gear: gearItem,
                                onEdit: {
                                    print("✏️ Starting edit for gear: \(gearItem.name)")
                                    editingGearId = gearItem.id
                                },
                                onDelete: {
                                    gear.removeAll(where: { $0.id == gearItem.id })
                                }
                            )
                        }
                    }
                }
                
                if !isAddingNew {
                    Button(action: {
                        print("🔄 Adding new gear")
                        withAnimation {
                            isAddingNew = true
                        }
                    }) {
                        Label("Add Another Item", systemImage: "plus.circle.fill")
                    }
                }
            }
        } header: {
            Label("Equipment", systemImage: "bag.fill")
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
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Item Name")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Label {
                                Text(gear.name)
                            } icon: {
                                IconFrame(icon: Ph.package.bold, color: .blue)
                            }
                            if gear.quantity > 1 {
                                Text("× \(gear.quantity)")
                                    .foregroundColor(.secondary)
                                    .font(.subheadline)
                            }
                        }
                    }
                    
                    // Weight Section
                    VStack(alignment: .leading, spacing: 12) {
                        Label {
                            Text(FormEquipmentSection.getWeightDisplayText(gear.weight))
                                .font(.subheadline)
                        } icon: {
                            IconFrame(icon: Ph.scales.bold, color: .secondary)
                        }
                        .foregroundColor(.secondary)
                    }
                    
                    // Special Section
                    if !gear.special.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Label {
                                Text(gear.special)
                                    .font(.subheadline)
                            } icon: {
                                IconFrame(icon: Ph.star.bold, color: .yellow)
                            }
                            .foregroundColor(.secondary)
                        }
                    }
                    
                    // Status Flags
                    HStack(spacing: 16) {
                        // Equipped Status
                        Label {
                            Text(gear.isEquipped ? "Equipped" : "Not Equipped")
                                .font(.subheadline)
                        } icon: {
                            IconFrame(icon: gear.isEquipped ? Ph.checkCircle.bold : Ph.circle.bold,
                                    color: gear.isEquipped ? .green : .secondary)
                        }
                        .foregroundColor(gear.isEquipped ? .green : .secondary)
                        
                        // Stashed Status
                        Label {
                            Text(gear.isStashed ? "Stashed" : "On Person")
                                .font(.subheadline)
                        } icon: {
                            IconFrame(icon: gear.isStashed ? Ph.warehouse.bold : Ph.user.bold, color: gear.isStashed ? .orange : .secondary)
                        }
                        .foregroundColor(gear.isStashed ? .orange : .secondary)
                    }
                    
                    // Container Status
                    if gear.isContainer {
                        Label {
                            Text("Container")
                                .font(.subheadline)
                        } icon: {
                            IconFrame(icon: Ph.package.bold, color: .blue)
                        }
                        .foregroundColor(.blue)
                    }
                    
                    // Magical and Cursed Status
                    if gear.isMagical || gear.isCursed {
                        HStack(spacing: 16) {
                            if gear.isMagical {
                                Label {
                                    Text("Magical")
                                        .font(.subheadline)
                                } icon: {
                                    IconFrame(icon: Ph.sparkle.bold, color: .purple)
                                }
                                .foregroundColor(.purple)
                            }
                            
                            if gear.isCursed {
                                Label {
                                    Text("Cursed")
                                        .font(.subheadline)
                                } icon: {
                                    IconFrame(icon: Ph.skull.bold, color: .red)
                                }
                                .foregroundColor(.red)
                            }
                        }
                    }
                }
                .allowsHitTesting(false)  // Disable touch interaction for content area only
                
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
                .buttonStyle(.plain)
                .padding(.horizontal)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
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
        @State private var isEquipped: Bool
        @State private var isStashed: Bool
        @State private var isMagical: Bool
        @State private var isCursed: Bool
        @State private var isContainer: Bool
        @State private var quantity: Int
        
        // Button state tracking
        @State private var isProcessingAction = false
        
        // Initialize with gear
        init(gear: Gear, onSave: @escaping (Gear) -> Void, onCancel: @escaping () -> Void) {
            self.gear = gear
            self.onSave = onSave
            self.onCancel = onCancel
            
            // Initialize state properties
            _name = State(initialValue: gear.name)
            _weight = State(initialValue: gear.weight)
            _special = State(initialValue: gear.special)
            _isEquipped = State(initialValue: gear.isEquipped)
            _isStashed = State(initialValue: gear.isStashed)
            _isMagical = State(initialValue: gear.isMagical)
            _isCursed = State(initialValue: gear.isCursed)
            _isContainer = State(initialValue: gear.isContainer)
            _quantity = State(initialValue: gear.quantity)
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                // Name Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Item Name")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Label {
                        TextField("Item Name", text: $name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    } icon: {
                        IconFrame(icon: Ph.package.bold, color: .blue)
                    }
                }
                
                // Weight Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Weight")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Picker("Weight", selection: $weight) {
                        ForEach(["No size", "Minor", "Regular", "Heavy"], id: \.self) { option in
                            Text(FormEquipmentSection.getWeightDisplayText(option))
                                .tag(option)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                // Special Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Special Properties")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Label {
                        TextField("Special Properties", text: $special)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    } icon: {
                        IconFrame(icon: Ph.star.bold, color: .yellow)
                    }
                }
                
                // Status Section
                Section {
                    // Equipped Toggle with Icon
                    HStack {
                        IconFrame(icon: Ph.bagSimple.bold, color: isEquipped ? .green : .gray)
                        Toggle(isEquipped ? "Equipped" : "Unequipped", isOn: $isEquipped)
                    }
                    
                    // Stashed Toggle with Icon
                    HStack {
                        IconFrame(icon: isStashed ? Ph.warehouse.bold : Ph.user.bold,
                                color: isStashed ? .orange : .gray)
                        Toggle(isStashed ? "Stashed" : "On Person", isOn: $isStashed)
                    }
                }
                
                // Magical Properties Section
                Section {
                    // Magical Toggle with Icon
                    HStack {
                        IconFrame(icon: Ph.sparkle.bold, color: isMagical ? .purple : .gray)
                        Toggle("Magical", isOn: $isMagical)
                    }
                    
                    // Cursed Toggle with Icon
                    HStack {
                        IconFrame(icon: Ph.skull.bold, color: isCursed ? .red : .gray)
                        Toggle(isOn: $isCursed) {
                            Text("Cursed")
                        }
                    }
                    
                    // Container Toggle with Icon
                    HStack {
                        IconFrame(icon: Ph.package.bold, color: isContainer ? .blue : .gray)
                        Toggle(isOn: $isContainer) {
                            Text("Container")
                        }
                    }
                }
                
                // Quantity Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Quantity")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    HStack {
                        TextField("Quantity", value: $quantity, format: .number)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                        Stepper("", value: $quantity, in: 1...Int.max)
                            .labelsHidden()
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
                        isProcessingAction = false
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
                        guard !isProcessingAction else { return }
                        isProcessingAction = true
                        print("🟢 Save action starting")
                        
                        // Create new gear with updated values
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
                        isProcessingAction = false
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
                .buttonStyle(.plain)
                .padding(.horizontal)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
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
    
    static func getWeightDisplayText(_ weight: String) -> String {
        switch weight {
        case "No size": return "No size (100/slot)"
        case "Minor": return "Minor (2/slot)"
        case "Regular": return "Regular (1 slot)"
        case "Heavy": return "Heavy (2 slots)"
        default: return weight
        }
    }
}
