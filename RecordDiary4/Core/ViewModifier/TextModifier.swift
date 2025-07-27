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
    let fontSize: CGFloat

    func body(content: Content) -> some View {
        let pressGesture = DragGesture(minimumDistance: 0)
            .updating($isDetectingLongPress) { _, state, _ in
                state = true
            }
            .onEnded { _ in
                onTap()
            }
        
        content
            .font(.custom("BebasNeue-Regular", size: fontSize))
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

struct PinkBorderedAndCozyImageTextButtonModifier: ViewModifier {
    
    @GestureState private var isDetectingLongPress = false
    let onTap: () -> Void
    let fontSize: CGFloat

    func body(content: Content) -> some View {
        let pressGesture = DragGesture(minimumDistance: 0)
            .updating($isDetectingLongPress) { _, state, _ in
                state = true
            }
            .onEnded { _ in
                onTap()
            }
        
        content
            .font(.system(size: fontSize))
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
    var fontSize: CGFloat
    func body(content: Content) -> some View {
        content
            .font(.custom("BebasNeue-Regular", size: fontSize))
            .foregroundStyle(ColorTheme.pink.color)
    }
}

struct WhiteAndCozyTextModifier: ViewModifier {
    var fontSize: CGFloat
    func body(content: Content) -> some View {
        content
            .font(.custom("BebasNeue-Regular", size: fontSize))
            .foregroundStyle(ColorTheme.white.color)
    }
}

struct CustomAndCozyTextModifier: ViewModifier {
    var fontSize: CGFloat
    var color: Color
    func body(content: Content) -> some View {
        content
            .font(.custom("BebasNeue-Regular", size: fontSize))
            .foregroundStyle(color)
    }
}

extension View {
    func pinkBorderedAndCozyImageTextButtonModifier(fontSize: CGFloat = 28, onTap: @escaping () -> Void) -> some View {
        modifier(PinkBorderedAndCozyImageTextButtonModifier(onTap: onTap, fontSize: fontSize))
    }
    
    func pinkBorderedAndCozyTextModifier(fontSize: CGFloat = 28, onTap: @escaping () -> Void) -> some View {
        modifier(PinkBorderedAndCozyTextModifier(onTap: onTap, fontSize: fontSize))
    }
    
    func pinkAndCozyTextModifier(fontSize: CGFloat = 20) -> some View {
        modifier(PinkAndCozyTextModifier(fontSize: fontSize))
    }
    
    func whiteAndCozyTextModifier(fontSize: CGFloat = 20) -> some View {
        modifier(WhiteAndCozyTextModifier(fontSize: fontSize))
    }
    
    func customAndCozyTextModifier(fontSize: CGFloat = 20, color: Color = ColorTheme.pink.color) -> some View {
        modifier(CustomAndCozyTextModifier(fontSize: fontSize, color: color))
    }
}
