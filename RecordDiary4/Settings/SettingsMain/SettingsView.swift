//
//  SettingsView.swift
//  RecordDiary
//
//  Created by Dostan Turlybek on 11.07.2025.
//
import SwiftUI
import SwiftfulRouting

struct SettingsView: View {
    
    @Environment(\.router) var router
    @EnvironmentObject private var settingsVM: SettingsViewModel
    @EnvironmentObject var calendarVM: CalendarViewModel
    @State private var selectedSettingsForShowDescription: String? = nil
    @Binding var selectedDate: Date
    
    
    var body: some View {
        ZStack{
            ColorTheme.white.color.ignoresSafeArea()
            VStack{
                ScrollView {
                    SettingsRow(
                        icon: "star.fill",
                        title: "Unlock All Features",
                        subtitle: "Get full access to custom emotions, themes, and unlimited control over your data.",
                        content: {
                            Text("Plans")
                                .pinkBorderedAndCozyTextModifier(fontSize: 16) {
                                    router.showScreen { router in
                                        Button {
                                            settingsVM.isPremium.toggle()
                                        } label: {
                                            Text("SetPremium")
                                        }
                                    }
                                }
                        },
                        selectedSettingsForShowDescription: $selectedSettingsForShowDescription)
                    
                    SettingsRow(
                        icon: settingsVM.apearanceIsLight ? "sun.max.fill" : "moon.fill",
                        title: "Choose Your Look",
                        subtitle: "Switch between light, dark, or auto theme based on the time of day.",
                        content: {
                            Text(settingsVM.apearanceIsLight ? "Light" : "Dark")
                                .pinkBorderedAndCozyTextModifier(fontSize: 16) {
                                    settingsVM.apearanceIsLight.toggle()
                                }
                            
                        },
                        selectedSettingsForShowDescription: $selectedSettingsForShowDescription)

                    SettingsRow(
                        icon: "face.smiling",
                        title: "My Emotions",
                        subtitle: "Create your own emotions with custom names and colors to express yourself better.",
                        content: {
                            Text("Edit")
                                .pinkBorderedAndCozyTextModifier(fontSize: 16) {
                                    router.showScreen { router in
                                        Text("Customize")
                                    }
                                }
                            
                        },
                        selectedSettingsForShowDescription: $selectedSettingsForShowDescription)

                    SettingsRow(
                        icon: "calendar",
                        title: "Dots in Calendar",
                        subtitle: "Remove visual dots for entries to keep your calendar minimal and distraction-free.",
                        content: {
                            Text(settingsVM.pointInCalendarVisable ? "ON" : "OFF")
                                .pinkBorderedAndCozyTextModifier(fontSize: 16) {
                                    settingsVM.pointInCalendarVisable.toggle()
                                }
                            
                        },
                        selectedSettingsForShowDescription: $selectedSettingsForShowDescription)

                    SettingsRow(
                        icon: "globe",
                        title: "Select App Language",
                        subtitle: "Change the app’s language independently from your system settings.",
                        content: {
                            Text(settingsVM.language)
                                .pinkBorderedAndCozyTextModifier(fontSize: 16) {
                                    router.showScreen { router in
                                        Text("Language")
                                    }
                                }
                            
                        },
                        selectedSettingsForShowDescription: $selectedSettingsForShowDescription)

                    SettingsRow(
                        icon: "trash",
                        title: "Recover Deleted Entries",
                        subtitle: "Browse and restore entries you've deleted",
                        content: {
                            Text("Show")
                                .pinkBorderedAndCozyTextModifier(fontSize: 16) {
                                    router.showScreen { router in
                                        RecentDeletedView(selectedDate: $selectedDate)
                                    }
                                }
                            
                        },
                        selectedSettingsForShowDescription: $selectedSettingsForShowDescription)
                    SettingsRow(
                        icon: "clock.arrow.circlepath",
                        title: "Set Cleanup Rules",
                        subtitle: "Automatically delete old entries after 7, 30, or 60 days.",
                        content: {
                            Text(settingsVM.delete.rawValue)
                                .pinkBorderedAndCozyTextModifier(fontSize: 16) {
                                    settingsVM.changeDeletingType()
                                }
                            
                        },
                        selectedSettingsForShowDescription: $selectedSettingsForShowDescription)

                    SettingsRow(
                        icon: "exclamationmark.triangle.fill",
                        title: "Delete all",
                        subtitle: "Permanently delete all recordings, emotions, and settings. This action cannot be undone.",
                        content: {
                            HStack{
                                Spacer()
                                if settingsVM.showDeleteButton {
                                    Text("Yes")
                                        .pinkBorderedAndCozyTextModifier(fontSize: 16) {
                                            settingsVM.deleteAll()
                                            calendarVM.shownRecordsAfterFiltering = []
                                        }
                                }
                                Text("Delete")
                                    .pinkBorderedAndCozyTextModifier(fontSize: 16) {
                                        settingsVM.toggleDeleteButton()
                                    }
                                
                                
                            }
                            
                        },
                        selectedSettingsForShowDescription: $selectedSettingsForShowDescription)
                }
                .padding(.horizontal)
            }
        }
    }
    
    
}



