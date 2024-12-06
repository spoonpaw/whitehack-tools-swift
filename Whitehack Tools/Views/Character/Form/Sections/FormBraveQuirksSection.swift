import SwiftUI
import PhosphorSwift

struct QuirkSlotView: View {
    let slotIndex: Int
    @Binding var braveQuirkOptions: BraveQuirkOptions
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "sparkles")
                    .foregroundColor(.orange)
                Text("Slot \(slotIndex + 1)")
                    .font(.headline)
                    .foregroundColor(.orange)
            }
            .padding(.bottom, 4)
            
            Menu {
                Button("None") {
                    braveQuirkOptions.setQuirk(nil, at: slotIndex)
                }
                
                ForEach(BraveQuirk.allCases) { quirk in
                    if !braveQuirkOptions.isActive(quirk) || braveQuirkOptions.getQuirk(at: slotIndex) == quirk {
                        Button(quirk.name) {
                            braveQuirkOptions.setQuirk(quirk, at: slotIndex)
                        }
                    }
                }
            } label: {
                HStack {
                    Text(braveQuirkOptions.getQuirk(at: slotIndex)?.name ?? "Select Quirk")
                        .foregroundColor(braveQuirkOptions.getQuirk(at: slotIndex) == nil ? .secondary : .primary)
                    Spacer()
                    Image(systemName: "chevron.up.chevron.down")
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background({
                    #if os(iOS)
                    Color(uiColor: .systemBackground)
                    #else
                    Color(nsColor: .windowBackgroundColor)
                    #endif
                }())
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke({
                            #if os(iOS)
                            Color(uiColor: .systemGray4)
                            #else
                            Color(nsColor: .separatorColor)
                            #endif
                        }(), lineWidth: 1)
                )
            }
            
            if let quirk = braveQuirkOptions.getQuirk(at: slotIndex) {
                Text(quirk.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 4)
                
                if quirk == .protectAlly {
                    TextField("Protected Ally's Name", text: Binding(
                        get: { braveQuirkOptions.getProtectedAlly(at: slotIndex) },
                        set: { braveQuirkOptions.setProtectedAlly($0, at: slotIndex) }
                    ))
                    .textFieldStyle(.roundedBorder)
                    .padding(.top, 4)
                }
            }
        }
        .padding(16)
        .background({
            #if os(iOS)
            Color(uiColor: .systemBackground)
            #else
            Color(nsColor: .windowBackgroundColor)
            #endif
        }())
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
        .padding(.vertical, 4)
    }
}

struct ComebackDiceView: View {
    @Binding var comebackDice: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "dice.fill")
                    .foregroundColor(.green)
                Text("Comeback Dice")
                    .font(.headline)
                    .foregroundColor(.green)
                Spacer()
                Text("\(comebackDice)d6")
                    .font(.title2)
                    .foregroundColor(.green)
            }
            
            Text("Gain a d6 when losing an auction, failing a task roll, or failing a save (not attacks). Can be added to any attribute, saving throw, attack value, or to supplant a damage die. Only the best die counts when using multiple dice.")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Stepper("Available Dice: \(comebackDice)", value: $comebackDice, in: 0...10)
        }
        .padding(16)
        .background({
            #if os(iOS)
            Color(uiColor: .systemBackground)
            #else
            Color(nsColor: .windowBackgroundColor)
            #endif
        }())
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
        .padding(.vertical, 4)
    }
}

struct SayNoPowerView: View {
    @Binding var hasUsedSayNo: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "hand.raised.fill")
                    .foregroundColor(.red)
                Text("Say No Power")
                    .font(.headline)
                    .foregroundColor(.red)
                Spacer()
            }
            
            Text("Once per session, you can say no to one thing that would affect you negatively.")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Toggle(isOn: $hasUsedSayNo) {
                HStack {
                    Image(systemName: hasUsedSayNo ? "xmark.circle.fill" : "checkmark.circle.fill")
                    Text(hasUsedSayNo ? "USED - No longer available this session" : "AVAILABLE - Not yet used this session")
                }
                .foregroundColor(hasUsedSayNo ? .red : .green)
                .font(.subheadline.bold())
            }
            .toggleStyle(SwitchToggleStyle(tint: .red))
        }
        .padding(16)
        .background({
            #if os(iOS)
            Color(uiColor: .systemBackground)
            #else
            Color(nsColor: .windowBackgroundColor)
            #endif
        }())
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
        .padding(.vertical, 4)
    }
}

struct FormBraveQuirksSection: View {
    @Binding var braveQuirkOptions: BraveQuirkOptions
    @Binding var hasUsedSayNo: Bool
    @Binding var comebackDice: Int
    @Binding var hasArmorPenalty: Bool
    
    var body: some View {
        Section {
            VStack(spacing: 16) {
                ForEach(0..<3) { index in
                    QuirkSlotView(slotIndex: index, braveQuirkOptions: $braveQuirkOptions)
                }
                
                ComebackDiceView(comebackDice: $comebackDice)
                SayNoPowerView(hasUsedSayNo: $hasUsedSayNo)
            }
            .padding(.vertical, 8)
        } header: {
            HStack(spacing: 8) {
                Ph.sparkle.bold
                    .frame(width: 20, height: 20)
                Text("The Brave")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            .padding(.vertical, 4)
        } footer: {
            if hasArmorPenalty {
                Text("Wearing armor heavier than cloth: -2 penalty to all task rolls")
                    .foregroundColor(.secondary)
            }
        }
    }
}
