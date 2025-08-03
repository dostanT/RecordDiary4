//
//  SFSymbolView.swift
//  RecordDiary4
//
//  Created by Dostan Turlybek on 03.08.2025.
//

import SwiftUI

struct SFSymbolView: View {
    
    @State var names: [String]
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 12, alignment: .center),
        GridItem(.flexible(), spacing: 12, alignment: .center),
        GridItem(.flexible(), spacing: 12, alignment: .center),
    ]
    
    var body: some View{
        ScrollView{
            ForEach(names, id: \.self) { name in
                SFSymbolCardView(name: name)
            }
            HStack(alignment: .center){
                Spacer()
                Text("You can choose any icon from SF Symbols.")
                    .pinkAndCozyTextModifier(fontSize: 16)
            }
            .padding()
            .background(ColorTheme.white.color)
            .padding(3)
            .background(ColorTheme.pink.color)
        }
        .padding(.horizontal)
    }
}

struct SFSymbolCardView: View {
    
    let name: String
    
    var body: some View{
        HStack(spacing: 8){
            
            Image(systemName: name)
                .font(.title3)
                .foregroundStyle(ColorTheme.pink.color)
            Spacer()
            Text(name)
                .pinkAndCozyTextModifier(fontSize: 16)
                .copyableText(name)
        }
        .padding()
        .background(ColorTheme.white.color)
        .padding(3)
        .background(ColorTheme.pink.color)
    }
}
