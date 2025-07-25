//
//  SortingView.swift
//  RecordDiary4
//
//  Created by Dostan Turlybek on 25.07.2025.
//
import SwiftUI

struct SortingView: View {
    
    let name: String
    let isPressed: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack{
            Text(name)
                .font(.custom("BebasNeue-Regular", size: 20))
                .foregroundStyle(ColorTheme.pink.color)
                .padding(2)
                .padding(.horizontal)
                .background(ColorTheme.white.color)
                .offset(x: isPressed ? 5 : 0, y: isPressed ? 5 : 0)
                .padding(1)
                .background(
                    ColorTheme.pink.color
                        .offset(x: isPressed ? 5 : 0, y: isPressed ? 5 : 0)
                )
                .background(
                    ColorTheme.pink.color
                        .opacity(isPressed ? 0 : 1)
                        .shadow(color: ColorTheme.pink.color, radius: 2, x: 5, y: 5)
                )
        }
        .onTapGesture {
            onTap()
        }
    }
}
