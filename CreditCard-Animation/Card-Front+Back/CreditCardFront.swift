//
//  CreditCardFront.swift
//  CreditCard-Animation
//
//  Created by MacMini6 on 11/03/25.
//

import SwiftUI
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
