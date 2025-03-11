//
//  AddCardView.swift
//  CreditCard-Animation
//
//  Created by MacMini6 on 11/03/25.
//

import SwiftUI
import RealmSwift
struct AddCardView: View {
    @State private var cardNumber = ""
    @State private var expiryDate = ""
    @State private var cvv = ""
    @State private var cardholderName = ""
    @State private var isCardFlipped = false
    @State private var focusedField: Field? = nil
    @State private var showSaveAlert = false
    @Environment(\.colorScheme) var colorScheme
    
    // Realm setup
    @ObservedResults(CreditCard.self) var savedCards
    
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
                Text("Add New Card")
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
                    
                    // Save button (previously Complete Payment)
                    Button(action: saveCard) {
                        HStack {
                            Image(systemName: "creditcard.and.123")
                                .font(.system(size: 20))
                            Text("Save Card")
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
                    .alert(isPresented: $showSaveAlert) {
                        Alert(
                            title: Text("Card Saved"),
                            message: Text("Your card details have been saved successfully."),
                            dismissButton: .default(Text("OK")) {
                                resetForm()
                            }
                        )
                    }
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
    
    // Save card to Realm database
    private func saveCard() {
        // Validate all fields are filled
        if !cardNumber.isEmpty && !expiryDate.isEmpty && !cvv.isEmpty && !cardholderName.isEmpty {
            let newCard = CreditCard(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cvv: cvv,
                cardholderName: cardholderName
            )
            
            // Save to Realm
            $savedCards.append(newCard)
            
            // Show success alert
            showSaveAlert = true
        }
    }
    
    // Reset form after saving
    private func resetForm() {
        cardNumber = ""
        expiryDate = ""
        cvv = ""
        cardholderName = ""
        isCardFlipped = false
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
