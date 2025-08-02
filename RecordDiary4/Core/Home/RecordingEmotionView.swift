//
//  RecordingView.swift
//  RecordDiary
//
//  Created by Dostan Turlybek on 14.07.2025.
//
import SwiftUI

struct RecordingEmotionViewOldVersion: View {
    
    let emotionModel: EmotionModel
    let isPremium: Bool
    let onTap: () -> Void
    
    var body: some View {        
        ZStack{
            HStack{
                HStack(alignment: .top){
                    VStack(alignment: .leading){
                        if let imageName = emotionModel.iconName {
                            Image(systemName: imageName)
                                .font(.title3)
                        }
                        Text(emotionModel.name)
                            .pinkAndCozyTextModifier(fontSize: 28)
                        Spacer()
                    }
                }
                .padding()
                Spacer()
                HStack(alignment: .bottom){
                    VStack{
                        Spacer()
                        Image(systemName: "microphone.fill")
                            .font(.title3)
                    }
                }
                .padding()
            }
            .background(ColorTheme.white.color)
        }
        .padding(3)
        .background(emotionModel.color.color)
    }
}


struct RecordingEmotionView: View {
    
    @GestureState private var isDetectingLongPress = false
    let emotionModel: EmotionModel
    let isPremium: Bool
    let onTap: () -> Void
    
    @State private var didTriggerStartHaptic = false
    
    var body: some View {
        let pressGesture = DragGesture(minimumDistance: 0)
            .updating($isDetectingLongPress) { _, state, _ in
                state = true
            }
            .onChanged { _ in
                if !didTriggerStartHaptic {
                    HapticService.instance.light()
                    didTriggerStartHaptic = true
                }
            }
            .onEnded { _ in
                HapticService.instance.light()
                onTap()
                didTriggerStartHaptic = false
            }
        
        ZStack {
            HStack {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        if let imageName = emotionModel.iconName {
                            Image(systemName: imageName)
                                .font(.title3)
                                .foregroundStyle(ColorTheme.pink.color)
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
            }
            .background(isDetectingLongPress ? emotionModel.color.color : ColorTheme.white.color)
            .padding(3)
            .background(!isDetectingLongPress ? emotionModel.color.color : ColorTheme.white.color)
            .offset(x: isDetectingLongPress ? 5 : 0,
                    y: isDetectingLongPress ? 5 : 0)
        }
        .background(
            emotionModel.color.color
                .offset(x: isDetectingLongPress ? 5 : 0,
                        y: isDetectingLongPress ? 5 : 0)
        )
        .background(
            emotionModel.color.color
                .opacity(isDetectingLongPress ? 0 : 1)
                .shadow(color: emotionModel.color.color, radius: 2, x: 5, y: 5)
        )
        .gesture(pressGesture)
    }
}

//
//struct RouterLink_Previews: PreviewProvider {
//    static var previews: some View {
//        RecordingVi
//    }
//}
