//
//  CardListItem.swift
//  CreditCard-Animation
//
//  Created by MacMini6 on 11/03/25.
//

import SwiftUI
import RealmSwift
  struct CardListItem: View {
        let card: CreditCard
        @Environment(\.colorScheme) var colorScheme
        
        var body: some View {
            HStack(spacing: 15) {
                // Card icon
                Image(systemName: "creditcard.fill")
                    .font(.system(size: 28))
                    .foregroundColor(Color(hex: "1A2980"))
                    .frame(width: 50, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(colorScheme == .dark ? Color(hex: "222222") : Color.white)
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                    )
                
                // Card info
                VStack(alignment: .leading, spacing: 4) {
                    Text(card.cardholderName)
                        .font(.headline)
                    
                    Text("•••• " + card.cardNumber.suffix(4))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text("Expires: " + card.expiryDate)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Tap to view indicator
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(colorScheme == .dark ? Color(hex: "1A1A1A") : Color.white)
                    .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.1), radius: 8, x: 0, y: 4)
            )
        }
    }
