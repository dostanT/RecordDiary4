//
//  RecentDeletedView.swift
//  RecordDiary4
//
//  Created by Dostan Turlybek on 28.07.2025.
//

import SwiftUI

struct RecentDeletedView: View {
    
    @EnvironmentObject private var settingsVM: SettingsViewModel
    @EnvironmentObject var calendarVM: CalendarViewModel
    
    
    
    var body: some View {
        ScrollView{
            ForEach(settingsVM.recentDeleted) { record in
                ZStack{
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
                        if calendarVM.selectedRecord == record {
                            VStack{
                                
                                //Slider
                                
                                Button {
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
                                } label: {
                                    if let selectedRecord = settingsVM.selectedRecord  {
                                        Image(systemName: selectedRecord.url == record.url ? "stop.fill" : "play.fill")
                                    } else {
                                        Image(systemName: "play.fill")
                                    }
                                    
                                }
                                .font(.title2)
                                .foregroundStyle(record.emotion?.color.color ?? Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                                .padding(2)
                            }
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
                .padding(.horizontal)
            }
        }
        .listStyle(PlainListStyle())
        
    }
}
