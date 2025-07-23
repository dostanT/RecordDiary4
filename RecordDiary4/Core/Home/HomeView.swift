//
//  HomeView.swift
//  RecordDiary
//
//  Created by Dostan Turlybek on 11.07.2025.
//

import SwiftUI
import SwiftfulRouting

struct HomeView: View {
    @Environment(\.router) var router
    @EnvironmentObject private var settingsVM: SettingsViewModel
    @StateObject private var homeVM: HomeViewModel = HomeViewModel()
    @State private var selectedDate: Date = Date()
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 12, alignment: .trailing),
        GridItem(.flexible(), spacing: 12, alignment: .leading),
    ]
    
    
    var body: some View {
        ZStack{
            VStack{
                Text(selectedDate.getformattedDate())
                    .pinkBorderedAndCozyTextModifier()
                Text(selectedDate.getformattedWeekDay())
                    .pinkAndCozyTextModifier()
                Spacer()
            }
            .padding()
            .onTapGesture {
                router.showScreen { router in
                    CalendarView(selectedDate: $selectedDate)
                }
            }
            LazyVGrid(
                columns: columns,
                alignment: .center,
                spacing: 12,
                pinnedViews: [],
                content: {
                    ForEach(settingsVM.emotionInUse){ emotion in
                        RecordingEmotionView(emotionModel: emotion, isPremium: settingsVM.isPremium)
                            .opacity(settingsVM.selectedEmotion == nil ? 1 : settingsVM.selectedEmotion!.id == emotion.id ? 1 : 0.2)
                            .onTapGesture {
//                                if settingsVM.selectedEmotion == nil {
//                                    settingsVM.startRecording(selectedEmotion: emotion)
//                                } else {
//                                    if settingsVM.selectedEmotion == emotion{
//                                        settingsVM.stopRecording(showDate: selectedDate)
//                                    }
//                                }
                                homeVM.stopRecording(
                                    emotion1: settingsVM.selectedEmotion,
                                    emotion2NONOptional: emotion) {
                                        settingsVM.stopRecording(showDate: selectedDate)
                                    } startRecording: {
                                        settingsVM.startRecording(selectedEmotion: emotion)
                                    }

                                
                            }
                    }
            })
            
            
        }
    }
}
