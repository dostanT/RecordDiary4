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
    
    var body: some View {
        ZStack{
            ColorTheme.white.color.ignoresSafeArea()
            VStack{
                List {
                    Section {
                        Button{
                            router.showScreen { router in
                                Button {
                                    settingsVM.isPremium.toggle()
                                } label: {
                                    Text("SetPremium")
                                }
                            }
                        } label: {
                            SettingsRow(
                                icon: "star.fill",
                                iconColor: .yellow,
                                title: "Unlock All Features",
                                subtitle: "Get full access to custom emotions, themes, and unlimited control over your data."
                            )
                        }
                    }
                    
                    Section(header: Text("Appearance")) {
                        Button{
                            settingsVM.apearanceIsLight.toggle()
                        } label: {
                            SettingsRow(
                                icon: settingsVM.apearanceIsLight ? "sun.max.fill" : "moon.fill",
                                iconColor: settingsVM.apearanceIsLight ? ColorTheme.yellow.color : ColorTheme.blue.color,
                                title: "Choose Your Look",
                                subtitle: "Switch between light, dark, or auto theme based on the time of day."
                            )
                        }
                    }
                    
                    Section(header: Text("Customization")) {
                        Button{
                            router.showScreen { router in
                                Text("Customize")
                            }
                            
                        } label: {
                            SettingsRow(
                                icon: "face.smiling",
                                iconColor: .pink,
                                title: "Make It Personal",
                                subtitle: "Create your own emotions with custom names and colors to express yourself better."
                            )
                        }
                    }
                    
                    Section(header: Text("Calendar")) {
                        Button{
                            settingsVM.pointInCalendarVisable.toggle()
                        } label: {
                            SettingsRow(
                                icon: "calendar",
                                iconColor: .orange,
                                title: "Clean Up the Calendar",
                                subtitle: "Remove visual dots for entries to keep your calendar minimal and distraction-free.",
                                textUnderneath: settingsVM.pointInCalendarVisable ? "ON" : "OFF"
                            )
                        }
                    }
                    
                    Section(header: Text("Language")) {
                        Button{
                            router.showScreen { router in
                                Text("Language")
                            }
                        } label: {
                            SettingsRow(
                                icon: "globe",
                                iconColor: .green,
                                title: "Select App Language",
                                subtitle: "Change the app’s language independently from your system settings.",
                                textUnderneath: settingsVM.language
                            )
                        }
                    }
                    
                    Section(header: Text("Deleted Entries")) {
                        Button{
                            router.showScreen { router in
                                Text("Deleted Entries")
                            }
                        }label:{
                            SettingsRow(
                                icon: "trash",
                                iconColor: .red,
                                title: "Recover Deleted Entries",
                                subtitle: "Browse and restore entries you've deleted in the last 7 days."
                            )
                        }
                        Button{
                            
                        }label:{
                            SettingsRow(
                                icon: "nosign",
                                iconColor: .gray,
                                title: "Delete Instantly",
                                subtitle: "Bypass the Recently Deleted folder. Permanently erase entries right away."
                            )
                        }
                        Button{
                            
                        }label:{
                            SettingsRow(
                                icon: "clock.arrow.circlepath",
                                iconColor: .purple,
                                title: "Set Cleanup Rules",
                                subtitle: "Automatically delete old entries after 7, 30, or 60 days.",
                                textUnderneath: settingsVM.delete.rawValue
                            )
                        }
                    }
                    
                    Section {
                        Button{
                            settingsVM.deleteAll()
                        } label: {
                            SettingsRow(
                                icon: "exclamationmark.triangle.fill",
                                iconColor: .red,
                                title: "Erase Everything",
                                subtitle: "Permanently delete all recordings, emotions, and settings. This action cannot be undone."
                            )
                        }
                    }
                }
                .tint(Color.primary)
            }
        }
        .preferredColorScheme(settingsVM.apearanceIsLight ? .light : .dark)
    }
}



