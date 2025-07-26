//
//  DurationTextView.swift
//  RecordDiary4
//
//  Created by Dostan Turlybek on 26.07.2025.
//

import SwiftUI

struct DurationTextView: View {
    
    @EnvironmentObject private var settingsVM: SettingsViewModel
    let record: RecordDataModel
    @State private var durationText: String = ""
    
    var body: some View {
        if let emotion = record.emotion {
            VStack{
                Text(durationText)
                    .customAndCozyTextModifier(fontSize: 20, color: emotion.color.color)
            }
            .task{
                durationText = await settingsVM.getDurationString(record: record)
            }
        }
    }
}
