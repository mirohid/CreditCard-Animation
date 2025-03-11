import SwiftUI

struct CreditCardView: View {
    @State private var cardNumber = ""
    @State private var expiryDate = ""
    @State private var cvv = ""
    @State private var cardholderName = ""
    @State private var isCardFlipped = false
    @State private var focusedField: Field? = nil
    @Environment(\.colorScheme) var colorScheme
    
    enum Field: Hashable {
        case cardNumber, expiryDate, cvv, cardholderName
    }
    
    // Custom colors for the card
    private var cardGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "1A2980"),
                Color(hex: "26D0CE")
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Text("Payment Details")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 20)
                
                // Card visualization
                ZStack {
                    // Credit card view with 3D rotation
                    ZStack {
                        // Front of the card
                        CreditCardFront(
                            cardNumber: cardNumber,
                            expiryDate: expiryDate,
                            cardholderName: cardholderName,
                            isActive: !isCardFlipped,
                            gradient: cardGradient
                        )
                        
                        // Back of the card
                        CreditCardBack(
                            cvv: cvv,
                            isActive: isCardFlipped,
                            gradient: cardGradient
                        )
                    }
                    .frame(width: 340, height: 210)
                    .modifier(FlipEffect(isFlipped: $isCardFlipped))
                    // Add tap gesture to flip card
                    .onTapGesture {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                            isCardFlipped.toggle()
                        }
                    }
                }
                .padding(.top, 10)
                .padding(.bottom, 20)
                
                // Form fields
                VStack(spacing: 25) {
                    // Card Number field
                    FormField(
                        icon: "creditcard",
                        title: "Card Number",
                        placeholder: "1234 5678 9012 3456",
                        text: $cardNumber,
                        keyboardType: .numberPad,
                        onTap: {
                            focusedField = .cardNumber
                            withAnimation {
                                isCardFlipped = false
                            }
                        }
                    )
                    .onChange(of: cardNumber) { newValue in
                        cardNumber = formatCardNumber(newValue)
                    }
                    
                    HStack(spacing: 16) {
                        // Expiry Date field
                        FormField(
                            icon: "calendar",
                            title: "Expiry Date",
                            placeholder: "MM/YY",
                            text: $expiryDate,
                            keyboardType: .numberPad,
                            onTap: {
                                focusedField = .expiryDate
                                withAnimation {
                                    isCardFlipped = false
                                }
                            }
                        )
                        .onChange(of: expiryDate) { newValue in
                            expiryDate = formatExpiryDate(newValue)
                        }
                        
                        // CVV field
                        FormField(
                            icon: "lock.shield",
                            title: "CVV",
                            placeholder: "123",
                            text: $cvv,
                            keyboardType: .numberPad,
                            onTap: {
                                focusedField = .cvv
                                withAnimation {
                                    isCardFlipped = true
                                }
                            }
                        )
                        .onChange(of: cvv) { newValue in
                            if newValue.count > 3 {
                                cvv = String(newValue.prefix(3))
                            } else {
                                cvv = newValue
                            }
                        }
                    }
                    
                    // Cardholder Name field
                    FormField(
                        icon: "person.fill",
                        title: "Cardholder Name",
                        placeholder: "JOHN DOE",
                        text: $cardholderName,
                        keyboardType: .default,
                        onTap: {
                            focusedField = .cardholderName
                            withAnimation {
                                isCardFlipped = false
                            }
                        }
                    )
                    .onChange(of: cardholderName) { newValue in
                        cardholderName = newValue.uppercased()
                    }
                    
                    // Submit button
                    Button(action: {
                        // Submit payment logic
                    }) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 20))
                            Text("Complete Payment")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(hex: "3494E6"), Color(hex: "EC6EAD")]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: Color(hex: "3494E6").opacity(0.4), radius: 10, x: 0, y: 5)
                    }
                    .padding(.top, 10)
                }
                .padding(.horizontal, 24)
                
                Spacer(minLength: 50)
            }
        }
        .background(
            colorScheme == .dark ?
                Color.black :
                Color(hex: "F8F9FA")
        )
        .edgesIgnoringSafeArea(.bottom)
    }
    
    // Format card number with spaces
    private func formatCardNumber(_ number: String) -> String {
        let digitsOnly = number.filter { $0.isNumber }
        let formattedString = digitsOnly.enumerated().map { index, char in
            return index > 0 && index % 4 == 0 ? " \(char)" : String(char)
        }.joined()
        
        return formattedString.count > 19 ? String(formattedString.prefix(19)) : formattedString
    }
    
    // Format expiry date with a slash
    private func formatExpiryDate(_ date: String) -> String {
        let digitsOnly = date.filter { $0.isNumber }
        if digitsOnly.count > 2 {
            let month = digitsOnly.prefix(2)
            let year = digitsOnly.dropFirst(2).prefix(2)
            return "\(month)/\(year)"
        } else {
            return digitsOnly
        }
    }
}

// Reusable form field component
struct FormField: View {
    let icon: String
    let title: String
    let placeholder: String
    @Binding var text: String
    let keyboardType: UIKeyboardType
    let onTap: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(Color.primary.opacity(0.8))
            
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(Color.primary.opacity(0.6))
                
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        colorScheme == .dark ?
                            Color(hex: "1A1A1A") :
                            Color.white
                    )
                    .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.06), radius: 8, x: 0, y: 4)
            )
            .onTapGesture {
                onTap()
            }
        }
    }
}

// Credit card front view
struct CreditCardFront: View {
    let cardNumber: String
    let expiryDate: String
    let cardholderName: String
    let isActive: Bool
    let gradient: LinearGradient
    
    var body: some View {
        ZStack {
            // Card background
            RoundedRectangle(cornerRadius: 16)
                .fill(gradient)
                .overlay(
                    // Pattern overlay for visual interest
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.03))
                            .frame(width: 250)
                            .offset(x: -120, y: -100)
                        
                        Circle()
                            .fill(Color.white.opacity(0.05))
                            .frame(width: 200)
                            .offset(x: 150, y: 100)
                        
                        Circle()
                            .fill(Color.white.opacity(0.03))
                            .frame(width: 100)
                            .offset(x: 120, y: -80)
                    }
                )
                .shadow(color: Color.black.opacity(0.3), radius: 15, x: 0, y: 8)
                .opacity(isActive ? 1.0 : 0.0)
            
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    // Modern network icon
                    Image(systemName: "wave.3.right")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                // Card chip and wireless indicator
                HStack(spacing: 12) {
                    // Chip design
                    ChipView()
                        .frame(width: 45, height: 35)
                    
                    // Wireless payment indicator
                    Image(systemName: "wave.3.right.circle")
                        .font(.system(size: 24))
                        .foregroundColor(.white.opacity(0.9))
                    
                    Spacer()
                }
                
                Spacer()
                
                // Card number
                Text(cardNumber.isEmpty ? "•••• •••• •••• ••••" : cardNumber)
                    .font(.system(size: 22, weight: .medium, design: .monospaced))
                    .foregroundColor(.white)
                    .padding(.bottom, 12)
                
                // Expiry date and cardholder name
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("VALID THRU")
                            .font(.system(size: 8, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                        
                        Text(expiryDate.isEmpty ? "MM/YY" : expiryDate)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 3) {
                        Text("CARDHOLDER")
                            .font(.system(size: 8, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                        
                        Text(cardholderName.isEmpty ? "YOUR NAME" : cardholderName)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .lineLimit(1)
                    }
                }
            }
            .padding(24)
            .opacity(isActive ? 1.0 : 0.0)
        }
    }
}

// Realistic chip design
struct ChipView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "FFD700").opacity(0.8), Color(hex: "DAA520").opacity(0.9)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                Grid(horizontalSpacing: 3, verticalSpacing: 4) {
                    GridRow {
                        Rectangle().fill(Color(hex: "444444").opacity(0.3))
                        Rectangle().fill(Color(hex: "444444").opacity(0.3))
                    }
                    GridRow {
                        Rectangle().fill(Color(hex: "444444").opacity(0.3))
                        Rectangle().fill(Color(hex: "444444").opacity(0.3))
                    }
                }
                .padding(6)
            )
            .shadow(color: Color.black.opacity(0.2), radius: 1, x: 0, y: 1)
    }
}

// Credit card back view
struct CreditCardBack: View {
    let cvv: String
    let isActive: Bool
    let gradient: LinearGradient
    
    var body: some View {
        ZStack {
            // Card background
            RoundedRectangle(cornerRadius: 16)
                .fill(gradient)
                .overlay(
                    // Pattern overlay
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.03))
                            .frame(width: 250)
                            .offset(x: 120, y: -100)
                        
                        Circle()
                            .fill(Color.white.opacity(0.05))
                            .frame(width: 200)
                            .offset(x: -150, y: 100)
                        
                        Circle()
                            .fill(Color.white.opacity(0.03))
                            .frame(width: 100)
                            .offset(x: -120, y: -80)
                    }
                )
                .shadow(color: Color.black.opacity(0.3), radius: 15, x: 0, y: 8)
                .opacity(isActive ? 1.0 : 0.0)
            
            VStack(spacing: 25) {
                // Black magnetic stripe with subtle gradient
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.black, Color(hex: "222222")]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 50)
                    .padding(.top, 20)
                
                // Signature strip with CVV
                HStack {
                    Spacer()
                    
                    ZStack(alignment: .trailing) {
                        // Signature strip with subtle pattern
                        Rectangle()
                            .fill(Color.white)
                            .overlay(
                                HStack {
                                    Text("AUTHORIZED SIGNATURE")
                                        .font(.system(size: 8, weight: .regular))
                                        .foregroundColor(.gray)
                                        .padding(.leading, 8)
                                    
                                    Spacer()
                                }
                            )
                            .frame(height: 40)
                        
                        // CVV box with secure styling
                        HStack {
                            Spacer()
                            Text(cvv.isEmpty ? "CVV" : cvv)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.white.opacity(0.9))
                                        .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                                )
                                .padding(.trailing, 12)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                Spacer()
                
                VStack(spacing: 8) {
                    Text("This card is property of your bank.")
                        .font(.system(size: 8, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("Unauthorized use is prohibited.")
                        .font(.system(size: 8, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.bottom, 20)
            }
            .opacity(isActive ? 1.0 : 0.0)
        }
    }
}

// 3D Flip animation
struct FlipEffect: ViewModifier {
    @Binding var isFlipped: Bool
    
    func body(content: Content) -> some View {
        content
            .rotation3DEffect(
                .degrees(isFlipped ? 180 : 0),
                axis: (x: 0.0, y: 1.0, z: 0.0)
            )
            .animation(.spring(response: 0.35, dampingFraction: 0.7), value: isFlipped)
    }
}

// Color extension for hex code support
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct CreditCardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CreditCardView()
                .preferredColorScheme(.light)
            
            CreditCardView()
                .preferredColorScheme(.dark)
        }
    }
}
