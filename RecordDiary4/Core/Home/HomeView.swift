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
            ColorTheme.white.color.ignoresSafeArea()
            VStack{
                Text(selectedDate.getformattedDate())
                    .pinkBorderedAndCozyTextModifier {
                        router.showScreen { router in
                            CalendarView(selectedDate: $selectedDate)
                        }
                    }
                Text(selectedDate.getformattedWeekDay())
                    .pinkAndCozyTextModifier()
                    .onTapGesture {
                        router.showScreen { router in
                            CalendarView(selectedDate: $selectedDate)
                        }
                    }
                Spacer()
            }
            .padding()
            
            LazyVGrid(
                columns: columns,
                alignment: .center,
                spacing: 12,
                pinnedViews: [],
                content: {
                    ForEach(settingsVM.emotionInUse){ emotion in
                        RecordingEmotionView(emotionModel: emotion, isPremium: settingsVM.isPremium, onTap: {
                            homeVM.stopStartRecording(
                                emotion1: settingsVM.selectedEmotion,
                                emotion2NONOptional: emotion) {
                                    settingsVM.stopRecording(showDate: selectedDate)
                                } startRecording: {
                                    settingsVM.startRecording(selectedEmotion: emotion)
                                }
                        })
                            .opacity(settingsVM.selectedEmotion == nil ? 1 : settingsVM.selectedEmotion!.id == emotion.id ? 1 : 0.2)
                    }
            })
            .padding(.horizontal)
            
            
        }
        .preferredColorScheme(settingsVM.apearanceIsLight ? .light : .dark)
    }
}
