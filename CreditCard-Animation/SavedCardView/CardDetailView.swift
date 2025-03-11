//
//  CardDetailView.swift
//  CreditCard-Animation
//
//  Created by MacMini6 on 11/03/25.
//

import SwiftUI
import RealmSwift
  struct CardDetailView: View {
        let card: CreditCard
        @Binding var isFlipped: Bool
        let onDismiss: () -> Void
        
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
            ZStack {
                // Backdrop
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        onDismiss()
                    }
                
                // Card visualization
                VStack(spacing: 20) {
                    // Card
                    ZStack {
                        // Front of the card
                        CreditCardFront(
                            cardNumber: card.cardNumber,
                            expiryDate: card.expiryDate,
                            cardholderName: card.cardholderName,
                            isActive: !isFlipped,
                            gradient: cardGradient
                        )
                        
                        // Back of the card
                        CreditCardBack(
                            cvv: card.cvv,
                            isActive: isFlipped,
                            gradient: cardGradient
                        )
                    }
                    .frame(width: 340, height: 210)
                    .modifier(FlipEffect(isFlipped: $isFlipped))
                    // Add tap gesture to flip card
                    .onTapGesture {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                            isFlipped.toggle()
                        }
                    }
                    
                    Text("Tap card to flip")
                        .font(.caption)
                        .foregroundColor(.white)
                    
                    // Close button
                    Button(action: onDismiss) {
                        Text("Close")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 30)
                            .background(
                                Capsule()
                                    .fill(Color.gray.opacity(0.6))
                            )
                    }
                    .padding(.top, 20)
                }
                .padding()
            }
        }
    }
