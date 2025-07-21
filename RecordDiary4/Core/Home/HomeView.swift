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
    @State private var selectedDate = Date()
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 12, alignment: .trailing),
        GridItem(.flexible(), spacing: 12, alignment: .leading),
    ]
    
    
    var body: some View {
        ZStack{
            VStack{
                Text(selectedDate.getformattedDate())
                    .font(.headline)
                Text(selectedDate.getformattedWeekDay())
                    .font(.caption)
                Spacer()
                Button{
                    settingsVM.stopRecording()
                } label: {
                    Circle()
                        .frame(width: 54, height: 54)
                }
                .tint(.blue)
                
                Button{
                    settingsVM.deleteAll()
                } label: {
                    Circle()
                        .frame(width: 54, height: 54)
                }
                .tint(.red)
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
                                if settingsVM.selectedEmotion == nil {
                                    settingsVM.startRecording(selectedEmotion: emotion)
                                }
                            }
                    }
            })
            
            
        }
    }
}
