//
//  RecordCardView.swift
//  RecordDiary4
//
//  Created by Dostan Turlybek on 28.07.2025.
//

import SwiftUI

struct RecordCardView: View {
    
    @EnvironmentObject private var settingsVM: SettingsViewModel
    @EnvironmentObject private var calendarVM: CalendarViewModel
    let record: RecordDataModel
    
    @Binding var isEditing: Bool
    @Binding var selectedData: [RecordDataModel]
    
    var body: some View {
        ZStack{
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
                            Button("CHeck"){
                                settingsVM.data[0].deletedDay =  Calendar.current.date(byAdding: .day, value: -40, to: Date())!
                                settingsVM.data[0].itemIsDeleted = true
                            }
                            DurationTextView(record: record)
                        }
                    }
                    .padding(.horizontal)
                    .padding(2)
                    
                    if calendarVM.selectedRecord == record {
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
                    if calendarVM.selectedRecord == record  {
                        calendarVM.selectedRecord = nil
                    } else {
                        calendarVM.selectedRecord = record
                    }
                }
            }
            
        }
        .padding(.horizontal)
    }
}
