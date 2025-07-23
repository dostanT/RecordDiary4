//
//  TextModifier.swift
//  RecordDiary4
//
//  Created by Dostan Turlybek on 23.07.2025.
//

import SwiftUI

struct PinkBorderedAndCozyTextModifier: ViewModifier {
    
    @GestureState private var isDetectingLongPress = false
    let onTap: () -> Void

    func body(content: Content) -> some View {
        let pressGesture = DragGesture(minimumDistance: 0)
            .updating($isDetectingLongPress) { _, state, _ in
                state = true
            }
            .onEnded { _ in
                onTap()
            }
        
        content
            .font(.custom("BebasNeue-Regular", size: 30))
            .foregroundStyle(ColorTheme.pink.color)
            .padding(6)
            .padding(.horizontal)
            .background(ColorTheme.white.color)
            .offset(x: isDetectingLongPress ? 5 : 0, y: isDetectingLongPress ? 5 : 0)
            .padding(3)
            .background(
                ColorTheme.pink.color
                    .offset(x: isDetectingLongPress ? 5 : 0, y: isDetectingLongPress ? 5 : 0)
            )
            .background(
                ColorTheme.pink.color
                    .opacity(isDetectingLongPress ? 0 : 1)
                    .shadow(color: ColorTheme.pink.color, radius: 2, x: 5, y: 5)
            )
            .gesture(pressGesture)
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
    func pinkBorderedAndCozyTextModifier(onTap: @escaping () -> Void) -> some View {
        modifier(PinkBorderedAndCozyTextModifier(onTap: onTap))
    }
    
    func pinkAndCozyTextModifier() -> some View {
        modifier(PinkAndCozyTextModifier())
    }
}
