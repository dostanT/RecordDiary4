//
//  EmotionControllerView.swift
//  RecordDiary4
//
//  Created by Dostan Turlybek on 31.07.2025.
//

import SwiftUI
import SwiftfulRouting

struct EmotionControllerView: View {
    
    @Environment(\.router) var router
    @StateObject private var emotionControllerVM = EmotionControllerViewModel()
    @EnvironmentObject private var settingsVM: SettingsViewModel
    
    @State var emotionInediting: [EmotionModel]
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 12, alignment: .center),
    ]
    
    var body: some View {
        ZStack{
            ColorTheme.white.color.ignoresSafeArea()
            
            LazyVGrid(
                columns: columns,
                alignment: .center,
                spacing: 12,
                pinnedViews: [],
                content: {
                    ForEach(0..<emotionInediting.count, id: \.self){ index in
                        EmotionCardView(emotionModel: $emotionInediting[index])
                    }
            })
            .padding(.horizontal)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Text("Save")
                    .pinkBorderedAndCozyTextModifier(fontSize: 12, onTap: {
                        emotionControllerVM.checkEmotionItemsAreNotSimilar(emotions: emotionInediting) { checker in
                            if checker {
                                settingsVM.emotionInUse = emotionInediting
                            } else {
                                showAlertRouter()
                            }
                        }
                    })
            }
        }
    }
    
    func showAlertRouter() {
        router.showAlert(.alert, title: "Warning", subtitle: "It looks like you have duplicate emotions. Please make sure each emotion is unique.") {
            Button("Okay") {
                router.dismissAlert()
            }
        }
    }

}

struct EmotionCardView: View {
    
    @Binding var emotionModel: EmotionModel
    
    var body: some View{
        ZStack {
            HStack {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        if let imageName = emotionModel.iconName {
                            Image(systemName: imageName)
                                .font(.title3)
                                .foregroundStyle(ColorTheme.pink.color)
                        }
                        TextField("Emotion name", text: $emotionModel.name)
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
            .background(ColorTheme.white.color)
            .padding(3)
            .background(emotionModel.color.color)
        }
        
        .background(
            emotionModel.color.color
                .shadow(color: emotionModel.color.color, radius: 2, x: 5, y: 5)
        )
    }
}
