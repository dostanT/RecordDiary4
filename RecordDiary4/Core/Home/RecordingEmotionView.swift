//
//  RecordingView.swift
//  RecordDiary
//
//  Created by Dostan Turlybek on 14.07.2025.
//
import SwiftUI

struct RecordingEmotionView: View {
    
    let emotionModel: EmotionModel
    let isPremium: Bool
    
    var body: some View {        
        ZStack{
//            Rectangle()
//                .foregroundStyle(emotionModel.color)
//                .frame(width: 120, height: 120)
//                .overlay{
//                    HStack{
//                        HStack(alignment: .top){
//                            VStack(alignment: .leading){
//                                if let imageName = emotionModel.iconName {
//                                    Image(systemName: imageName)
//                                        .font(.system(size: 25))
//                                }
//                                Text(emotionModel.name)
//                                    .font(.system(size: 25))
//                                    .bold()
//                                Spacer()
//                            }
//                        }
//                        Spacer()
//                        HStack(alignment: .bottom){
//                            VStack{
//                                Spacer()
//                                Image(systemName: "microphone.fill")
//                                    .font(.system(size: 25))
//                            }
//                        }
//                    }
//                }
//                .frame(width: 150, height: 150)
//                .background(emotionModel.color)
//                .clipShape(RoundedRectangle(cornerRadius: 30))
            
            HStack{
                HStack(alignment: .top){
                    VStack(alignment: .leading){
                        if let imageName = emotionModel.iconName {
                            Image(systemName: imageName)
                                .font(.title3)
                        }
                        Text(emotionModel.name)
                            .font(.title3)
                            .bold()
                        Spacer()
                    }
                }
                .padding()
                Spacer()
                HStack(alignment: .bottom){
                    VStack{
                        Spacer()
                        Image(systemName: "microphone.fill")
                            .font(.title3)
                    }
                }
                .padding()
            }
            .frame(width: 150, height: 150)
            .background(emotionModel.color.color)
            .clipShape(RoundedRectangle(cornerRadius: 30))
        }
    }
}
//
//struct RouterLink_Previews: PreviewProvider {
//    static var previews: some View {
//        RecordingVi
//    }
//}
