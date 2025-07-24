import SwiftUI

struct StickyPullDownBannerView: View {
    @State private var bannerOffset: CGFloat = -100  // Начальное положение (скрыт)
    @GestureState private var dragOffset: CGFloat = 0

    var body: some View {
        ZStack(alignment: .top) {
            Color.white.ignoresSafeArea()

            VStack {
                Spacer()
                Text("Основной контент")
                    .font(.title)
                    .padding()
                Spacer()
            }

            bannerView
                .offset(y: max(-100, bannerOffset + dragOffset))  // Ограничение вверх
                .gesture(
                    DragGesture()
                        .updating($dragOffset) { value, state, _ in
                            state = value.translation.height
                        }
                        .onEnded { value in
                            withAnimation(.spring()) {
                                if value.translation.height > 50 {
                                    // Свайп вниз: показать баннер
                                    bannerOffset = 0
                                } else if value.translation.height < -30 {
                                    // Свайп вверх: скрыть баннер
                                    bannerOffset = -100
                                } else {
                                    // Маленькое движение — вернуться к текущему состоянию
                                    bannerOffset = (bannerOffset > -50) ? 0 : -100
                                }
                            }
                        }
                )
        }
    }

    var bannerView: some View {
        VStack {
            Text("📢 Это баннер")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
        }
        .frame(height: 100)
        .background(Color.blue)
    }
}
