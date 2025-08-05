//
//  TutorialView.swift
//  RecordDiary4
//
//  Created by Dostan Turlybek on 05.08.2025.
//
import SwiftUI

struct HorizontalScrollViewWithPages: View {
    @EnvironmentObject private var settingsVM: SettingsViewModel
    @State private var selectedIndex = 0
    let imagesDark: [String] = [
        "Home_Dark_Initial",
        "Home_Dark_Microphone_Request",
        "Home_Stop_Button_Dark",
        "Calendar_Short_View_Dark",
        "Calendar_Long_View_Dark",
        "Calendar_Filter_View_Dark",
    ]
    
    let imagesWhite: [String] = [
        "Home_White_Initial",
        "Home_White_Microphone_Request",
        "Home_Stop_Button_White",
        "Calendar_Short_View_White",
        "Calendar_Long_View_White",
        "Calendar_Filter_View_White",
    ]

    var body: some View {
        VStack {
            TabView(selection: $selectedIndex) {
                ForEach(settingsVM.apearanceIsLight ? imagesWhite : imagesDark, id: \.self) { imageName in
                    VStack{
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                        ZStack{
                            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
                                .pinkAndCozyTextModifier(fontSize: 20)
                        }
                        .background(ColorTheme.white.color)
                        .padding(2)
                        .background(ColorTheme.pink.color)
                        .padding()
                    }   
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            
            
            
        }
    }
}
