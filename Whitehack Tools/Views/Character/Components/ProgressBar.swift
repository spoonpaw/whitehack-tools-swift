import SwiftUI

struct ProgressBar: View {
    let value: Double
    let maxValue: Double
    let label: String
    var foregroundColor: Color = .blue
    var backgroundColor: Color = .gray.opacity(0.3)
    var showPercentage: Bool = true
    var isComplete: Bool = false
    var completionMessage: String? = nil
    
    private var progress: Double {
        guard maxValue > 0 else { return 0.0 }
        return min(max(value / maxValue, 0.0), 1.0)  // Clamp between 0 and 1
    }
    
    private var percentage: Int {
        guard maxValue > 0 else { return 0 }
        return min(Int(value / maxValue * 100), 100)  // Cap at 100%
    }
    
    private var barColor: Color {
        isComplete ? .yellow : foregroundColor
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(label)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if showPercentage {
                    Text("\(percentage)%")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 4)
                        .fill(backgroundColor)
                        .frame(maxWidth: .infinity)
                        .frame(height: 8)
                    
                    // Progress
                    RoundedRectangle(cornerRadius: 4)
                        .fill(barColor)
                        .frame(width: max(0, min(geometry.size.width * progress, geometry.size.width)))
                        .frame(height: 8)
                        .shadow(color: isComplete ? barColor.opacity(0.6) : .clear, radius: 3, x: 0, y: 0)
                }
            }
            .frame(height: 8)
            
            // Completion message
            if isComplete && !(completionMessage?.isEmpty ?? true) {
                Text(completionMessage ?? "")
                    .font(.caption)
                    .foregroundColor(.yellow)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .shadow(color: .yellow.opacity(0.5), radius: 2, x: 0, y: 0)
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        ProgressBar(value: 75, maxValue: 100, label: "Health", foregroundColor: .red)
        ProgressBar(
            value: 120,  // Test over 100%
            maxValue: 100,
            label: "Experience",
            foregroundColor: .purple,
            isComplete: true,
            completionMessage: "Level up available!"
        )
    }
    .padding()
}
