import SwiftUI

struct LaunchScreenView: View {
    @State private var selectedIndex: Int = 0
    @State private var countOfCycle: Int = 0
    @Binding var isLoggedIn: Bool
    
    let timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    let name = Array("Teddy’s Diary")
    
    var body: some View {
        ZStack {
            ColorTheme.white.color.ignoresSafeArea()
            VStack {
                Image("Teddy")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                
                HStack {
                    ForEach(name.indices, id: \.self) { index in
                        Text(String(name[index]))
                            .pinkAndCozyTextModifier(fontSize: 24)
                            .offset(y: selectedIndex == index ? -5 : 0)
                    }
                }
            }
        }
        .onReceive(timer) { _ in
            print("On loop")
            withAnimation(.spring(duration: 0.2)) {
                selectedIndex = (selectedIndex + 1) % name.count
            }
            withAnimation(.spring(duration: 0.7)) {
                if selectedIndex == 0 {
                    countOfCycle += 1
                    if countOfCycle == 2 {
                        isLoggedIn = true
                    }
                }
            }
        }
    }
}
