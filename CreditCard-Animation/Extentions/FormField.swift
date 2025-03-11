//
//  FormField.swift
//  CreditCard-Animation
//
//  Created by MacMini6 on 11/03/25.
//

import SwiftUI
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
