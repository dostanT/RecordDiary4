//
//  SettingsRow.swift
//  RecordDiary
//
//  Created by Dostan Turlybek on 13.07.2025.
//
import SwiftUI

struct SettingsRow<Content: View>: View {
    var icon: String
    var title: String
    var subtitle: String
    
    @ViewBuilder var content: Content
    @Binding var selectedSettingsForShowDescription: String?

    var body: some View {
        VStack() {
            HStack{
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(ColorTheme.pink.color)
                    .frame(width: 32, height: 32)
                    .background(ColorTheme.pink.color.opacity(0.15))
                
                Text(title)
                    .pinkAndCozyTextModifier(fontSize: 20)
                    .onTapGesture {
                        selectedSettingsForShowDescription = selectedSettingsForShowDescription == title ? nil : title
                    }
                Spacer()
                content
            }
            HStack() {
                if selectedSettingsForShowDescription == title {
                    Rectangle()
                        .frame(width: 32, height: 32)
                        .opacity(0.0001)
                    Text(subtitle)
                        .pinkAndCozyTextModifier(fontSize: 16)
                        .opacity(0.7)
                    Spacer()
                }
            }
        }
        .padding()
        .background(ColorTheme.white.color)
        .padding(2)
        .background(ColorTheme.pink.color)
    }
}
