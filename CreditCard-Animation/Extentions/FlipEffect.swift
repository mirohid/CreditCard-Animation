//
//  FlipEffect.swift
//  CreditCard-Animation
//
//  Created by MacMini6 on 11/03/25.
//

import SwiftUI
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
