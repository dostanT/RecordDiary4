//
//  RecentDeletedView.swift
//  RecordDiary4
//
//  Created by Dostan Turlybek on 28.07.2025.
//

import SwiftUI
/*
 Deleting and recovering . будет появлятся две кнопки
 Можно будет Select и или удалить все или востановить все
 */

struct RecentDeletedView: View {
    
    @EnvironmentObject private var settingsVM: SettingsViewModel
    @EnvironmentObject var calendarVM: CalendarViewModel
    @State private var isEditing: Bool = false
    @State private var selectedData: [RecordDataModel] = []
    
    @State private var selectedRecord: RecordDataModel?
    
    var body: some View {
        ZStack{
            ScrollView{
                ForEach(settingsVM.recentDeleted) { record in
                    RecordDeletedCardView(record: record, isEditing: $isEditing, selectedRecord: $selectedRecord, selectedData: $selectedData)
                }
            }
            .listStyle(PlainListStyle())
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if isEditing {
                    HStack{
                        Text("Restore")
                            .pinkBorderedAndCozyTextModifier(fontSize: 16) {
                                isEditing = false
                            }
                        Text("Delete")
                            .pinkBorderedAndCozyTextModifier(fontSize: 16) {
                                isEditing = false
                            }
                        Text("Cancel")
                            .pinkBorderedAndCozyTextModifier(fontSize: 16) {
                                isEditing = false
                                selectedData = []
                            }
                    }
                } else {
                    Text("Select")
                        .pinkBorderedAndCozyTextModifier(fontSize: 16) {
                            isEditing = true
                        }
                }
            }
        }
    }
}

struct RecordDeletedCardView: View {
    
    @EnvironmentObject private var settingsVM: SettingsViewModel
    @EnvironmentObject var calendarVM: CalendarViewModel
    let record: RecordDataModel
    
    
    @Binding var isEditing: Bool
    @Binding var selectedRecord: RecordDataModel?
    @Binding var selectedData: [RecordDataModel]
    
    var body: some View {
        HStack{
            if isEditing{
                if selectedData.contains(record) {
                    Image(systemName: "checkmark")
                        .font(.headline)
                        .customBorderedAndCozyImageTextButtonModifier(fontSize: 16, onTap: {
                            selectedData.removeAll { $0.id == record.id }
                        }, color: ColorTheme.pink.color)
                } else {
                    Rectangle()
                        .frame(width: 18.7, height: 18.7)
                        .foregroundStyle(ColorTheme.white.color)
                        .customBorderedAndCozyImageTextButtonModifier(fontSize: 16, onTap: {
                            selectedData.append(record)
                        }, color: ColorTheme.pink.color)
                    
                }
            }
            
            VStack{
                HStack{
                    VStack(alignment: .leading){
                        Text(record.createdDate.getFormattedHourMinutesAMPM())
                            .customAndCozyTextModifier(fontSize: 20, color: record.emotion?.color.color ?? Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                        if let emotion = record.emotion {
                            Text(emotion.name)
                                .customAndCozyTextModifier(fontSize: 20, color: record.emotion?.color.color ?? Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                        }
                    }
                    
                    Spacer()
                    
                    VStack{
                        DurationTextView(record: record)
                    }
                }
                .padding(.horizontal)
                .padding(2)
                if selectedRecord == record {
                    VStack{
                        if let selectedRecord = settingsVM.selectedRecord  {
                            Image(systemName: selectedRecord.url == record.url ? "stop.fill" : "play.fill")
                        } else {
                            Image(systemName: "play.fill")
                        }
                    }
                    .customBorderedAndCozyImageTextButtonModifier(fontSize: 16, onTap: {
                        if let selectedRecord = settingsVM.selectedRecord {
                            if selectedRecord.url == record.url {
                                settingsVM.audioInputOutputService.stopPlayback()
                                settingsVM.selectedRecord = nil
                            } else {
                                settingsVM.changeAudioPlaying(chosenRecord: record)
                            }
                        }
                        else {
                            settingsVM.audioInputOutputService.playRecording(url: record.url) { success in
                                if success {
                                    settingsVM.selectedRecord = record
                                }
                            }
                        }
                    }, color: record.emotion?.color.color ?? ColorTheme.pink.color)
                    .padding()
                }
                
            }
            .background(ColorTheme.white.color)
            .padding(2)
            .background(record.emotion?.color.color ?? Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
            .onTapGesture {
                if selectedRecord == record  {
                   selectedRecord = nil
                } else {
                    selectedRecord = record
                }
            }
        }
        .padding()
    }
}
