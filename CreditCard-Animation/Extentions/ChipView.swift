//
//  ChipView.swift
//  CreditCard-Animation
//
//  Created by MacMini6 on 11/03/25.
//

import SwiftUI
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
