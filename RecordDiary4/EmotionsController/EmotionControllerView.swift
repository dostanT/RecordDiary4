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
    
    @State private var selectedEmotionForEditing: EmotionModel? = nil
    
    @State var emotionInediting: [EmotionModel]
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 12, alignment: .center),
    ]
    
    var body: some View {
        ZStack{
            ColorTheme.white.color.ignoresSafeArea()
            
            if let selectedEmotionForEditing = selectedEmotionForEditing {
                EmotionCardEditView(emotionModel: $emotionInediting[emotionInediting.firstIndex(where: {$0.id == selectedEmotionForEditing.id}) ?? 0], selectedEmotionForEditing: $selectedEmotionForEditing)
            } else {
                LazyVGrid(
                    columns: columns,
                    alignment: .center,
                    spacing: 12,
                    pinnedViews: [],
                    content: {
                        ForEach(0..<emotionInediting.count, id: \.self){ index in
                            EmotionCardView(emotionModel: $emotionInediting[index], selectedEmotionForEditing: $selectedEmotionForEditing)
                        }
                })
            }
        }
        .onTapGesture {
            selectedEmotionForEditing = nil
        }
        .padding(.horizontal)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack{
                    Text("SFSymbols")
                        .pinkBorderedAndCozyTextModifier(fontSize: 16, onTap: {
                            router.showScreen { router in
                                SFSymbolView(names: emotionControllerVM.emotionSymbols)
                            }
                        })
                    Text("Save")
                        .pinkBorderedAndCozyTextModifier(fontSize: 16, onTap: {
                            emotionControllerVM.checkEmotionItemsAreNotSimilar(emotions: emotionInediting) { checker in
                                if checker {
                                    settingsVM.emotionInUse = emotionInediting
                                    router.dismissScreen()
                                } else {
                                    showAlertRouter()
                                }
                            }
                        })
                }
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


