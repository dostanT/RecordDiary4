//
//  TextModifier.swift
//  RecordDiary4
//
//  Created by Dostan Turlybek on 23.07.2025.
//

import SwiftUI

struct PinkBorderedAndCozyTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("BebasNeue-Regular", size: 30))
            .foregroundStyle(ColorTheme.pink.color)
            .padding(6)
            .padding(.horizontal)
            .background(ColorTheme.white.color)
            .padding(3)
            .background(
                ColorTheme.pink.color
                    .shadow(color: ColorTheme.pink.color, radius: 2, x: 5, y: 5)
            )
            
    }
}

struct PinkAndCozyTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("BebasNeue-Regular", size: 20))
            .foregroundStyle(ColorTheme.pink.color)
    }
}

extension View {
    func pinkBorderedAndCozyTextModifier() -> some View {
        modifier(PinkBorderedAndCozyTextModifier())
    }
    
    func pinkAndCozyTextModifier() -> some View {
        modifier(PinkAndCozyTextModifier())
    }
}
