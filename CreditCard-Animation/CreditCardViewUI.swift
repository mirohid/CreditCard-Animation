//
//  CreditCardView.swift
//  CreditCard-Animation
//
//  Created by MacMini6 on 10/03/25.
//


import SwiftUI

struct CreditCardView: View {
    @State private var cardNumber = ""
    @State private var expiryDate = ""
    @State private var cvv = ""
    @State private var cardholderName = ""
    @State private var isCardFlipped = false
    @State private var focusedField: Field? = nil
    
    enum Field: Hashable {
        case cardNumber, expiryDate, cvv, cardholderName
    }
    
    var body: some View {
        VStack(spacing: 30) {
            ZStack {
                // Credit card view with 3D rotation
                ZStack {
                    // Front of the card
                    CreditCardFront(
                        cardNumber: cardNumber,
                        expiryDate: expiryDate,
                        cardholderName: cardholderName,
                        isActive: !isCardFlipped
                    )
                    
                    // Back of the card
                    CreditCardBack(
                        cvv: cvv,
                        isActive: isCardFlipped
                    )
                }
                .frame(width: 320, height: 200)
                .modifier(FlipEffect(isFlipped: $isCardFlipped))
                // Add tap gesture to flip card
                .onTapGesture {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                        isCardFlipped.toggle()
                    }
                }
                .overlay(
                    // Subtle visual indicator that card is tappable
                    Image(systemName: "arrow.2.squarepath")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.7))
                        .padding(8)
                        .background(Circle().fill(Color.black.opacity(0.2)))
                        .padding(8),
                    alignment: .topLeading
                )
            }
            .padding(.top, 20)
            
            // Form fields
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Card Number")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    TextField("1234 5678 9012 3456", text: $cardNumber)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .onChange(of: cardNumber) { newValue in
                            cardNumber = formatCardNumber(newValue)
                        }
                        .onTapGesture {
                            focusedField = .cardNumber
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                isCardFlipped = false
                            }
                        }
                }
                
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Expiry Date")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        TextField("MM/YY", text: $expiryDate)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .frame(maxWidth: .infinity)
                            .onChange(of: expiryDate) { newValue in
                                expiryDate = formatExpiryDate(newValue)
                            }
                            .onTapGesture {
                                focusedField = .expiryDate
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                    isCardFlipped = false
                                }
                            }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("CVV")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        TextField("123", text: $cvv)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .frame(maxWidth: .infinity)
                            .onChange(of: cvv) { newValue in
                                // Auto-trigger card flip when user starts typing CVV
                                if !isCardFlipped && !newValue.isEmpty {
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                        isCardFlipped = true
                                    }
                                }
                                
                                // Limit to 3 digits
                                if newValue.count > 3 {
                                    cvv = String(newValue.prefix(3))
                                } else {
                                    cvv = newValue
                                }
                            }
                            .onTapGesture {
                                focusedField = .cvv
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                    isCardFlipped = true
                                }
                            }
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Cardholder Name")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    TextField("JOHN DOE", text: $cardholderName)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .onChange(of: cardholderName) { newValue in
                            cardholderName = newValue.uppercased()
                        }
                        .onTapGesture {
                            focusedField = .cardholderName
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                isCardFlipped = false
                            }
                        }
                }
                
                Button(action: {
                    // Submit payment logic would go here
                }) {
                    Text("Submit Payment")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.top, 10)
            }
            .padding(.horizontal)
        }
        .padding()
        .navigationTitle("Payment Details")
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

// Credit card front view
struct CreditCardFront: View {
    let cardNumber: String
    let expiryDate: String
    let cardholderName: String
    let isActive: Bool
    
    var body: some View {
        ZStack {
            // Card background
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.7, alpha: 1)), Color(#colorLiteral(red: 0.3, green: 0.3, blue: 0.8, alpha: 1))]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                .opacity(isActive ? 1.0 : 0.0)
            
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Image(systemName: "creditcard.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                // Card chip
                HStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.yellow.opacity(0.8))
                        .frame(width: 50, height: 40)
                        .overlay(
                            ZStack {
                                // Simple chip design
                                Grid(horizontalSpacing: 2, verticalSpacing: 2) {
                                    GridRow {
                                        Rectangle().fill(Color.gray.opacity(0.5))
                                        Rectangle().fill(Color.gray.opacity(0.5))
                                    }
                                    GridRow {
                                        Rectangle().fill(Color.gray.opacity(0.5))
                                        Rectangle().fill(Color.gray.opacity(0.5))
                                    }
                                }
                            }
                        )
                    Spacer()
                }
                
                Spacer()
                
                // Card number
                Text(cardNumber.isEmpty ? "•••• •••• •••• ••••" : cardNumber)
                    .font(.system(size: 20, weight: .medium, design: .monospaced))
                    .foregroundColor(.white)
                    .padding(.bottom, 8)
                
                // Expiry date and cardholder name
                HStack {
                    VStack(alignment: .leading) {
                        Text("EXPIRES")
                            .font(.system(size: 8))
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text(expiryDate.isEmpty ? "MM/YY" : expiryDate)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("CARDHOLDER")
                            .font(.system(size: 8))
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text(cardholderName.isEmpty ? "YOUR NAME" : cardholderName)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding()
            .opacity(isActive ? 1.0 : 0.0)
        }
    }
}

// Credit card back view
struct CreditCardBack: View {
    let cvv: String
    let isActive: Bool
    
    var body: some View {
        ZStack {
            // Card background
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.7, alpha: 1)), Color(#colorLiteral(red: 0.3, green: 0.3, blue: 0.8, alpha: 1))]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                .opacity(isActive ? 1.0 : 0.0)
            
            VStack(spacing: 20) {
                // Black magnetic stripe
                Rectangle()
                    .fill(Color.black)
                    .frame(height: 50)
                    .padding(.top, 20)
                
                // Signature strip with CVV
                HStack {
                    ZStack(alignment: .trailing) {
                        Rectangle()
                            .fill(Color.white)
                            .frame(height: 40)
                        
                        // Dynamic CVV display
                        HStack {
                            Spacer()
                            Text(cvv.isEmpty ? "CVV" : cvv)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.trailing, 8)
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                Text("This card is property of your bank. Unauthorized use is prohibited.")
                    .font(.system(size: 8))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 10)
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

struct CreditCardView_Previews: PreviewProvider {
    static var previews: some View {
        CreditCardView()
    }
}
