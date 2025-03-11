//
//  CreditCardBack.swift
//  CreditCard-Animation
//
//  Created by MacMini6 on 11/03/25.
//

import SwiftUI
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
                            gradient: Gradient(colors: [Color.black, Color("222222")]),
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
