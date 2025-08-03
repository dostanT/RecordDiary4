//
//  EmotionCardView.swift
//  RecordDiary4
//
//  Created by Dostan Turlybek on 03.08.2025.
//

import Foundation
import SwiftUI

struct EmotionCardView: View {
    
    @Binding var emotionModel: EmotionModel
    @Binding var selectedEmotionForEditing: EmotionModel?
    
    var body: some View{
        ZStack {
            HStack {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        HStack{
                            if let imageName = emotionModel.iconName,
                               UIImage(systemName: imageName.lowercased()) != nil {
                                
                                Image(systemName: imageName.lowercased())
                                    .font(.title3)
                                    .foregroundStyle(ColorTheme.pink.color)
                                
                            } else {
                                Image(systemName: "xmark")
                                    .font(.title3)
                                    .opacity(0.0001)
                            }
                            Text(emotionModel.iconName ?? "SFSymbol name")
                                .pinkAndCozyTextModifier(fontSize: 16)
                        }
                        Text(emotionModel.name)
                            .pinkAndCozyTextModifier(fontSize: 28)
                        Spacer()
                    }
                }
                .padding()
                
                
                Spacer()
                
                HStack(alignment: .bottom) {
                    VStack {
                        Spacer()
                        Image(systemName: "microphone.fill")
                            .font(.title3)
                            .foregroundStyle(ColorTheme.pink.color)
                    }
                }
                .padding()
                .onTapGesture {
                    print("Microphone")
                }
            }
            .background(ColorTheme.white.color)
            .padding(3)
            .background(emotionModel.color.color)
        }
        
        .background(
            emotionModel.color.color
                .shadow(color: emotionModel.color.color, radius: 2, x: 5, y: 5)
        )
        .frame(maxHeight: UIScreen.main.bounds.height * 0.2)
        .onTapGesture {
            selectedEmotionForEditing = emotionModel
        }
    }
}
