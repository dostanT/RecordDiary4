//
//  SettingsRow.swift
//  RecordDiary
//
//  Created by Dostan Turlybek on 13.07.2025.
//
import SwiftUI

struct SettingsRow: View {
    var icon: String
    var iconColor: Color
    var title: String
    var subtitle: String
    var textUnderneath: String = ""

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack{
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(iconColor)
                    .frame(width: 32, height: 32)
                    .background(iconColor.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                
                Text(textUnderneath)
                    .font(.headline)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.vertical, 8)
    }
}
