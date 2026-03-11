import SwiftUI

struct SplashView: View {

    @State private var isActive = false
    @State private var scale: CGFloat = 0.8
    @State private var opacity = 0.5

    var body: some View {

        if isActive {
            CategorySelectionView()
        } else {

            VStack(spacing: 24) {

                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)

                Text("Ascend")
                    .font(.system(size: 34, weight: .semibold))
                    .foregroundColor(Color.black)

            }
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {

                withAnimation(.easeIn(duration: 1.2)) {
                    scale = 1.0
                    opacity = 1.0
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {

                    withAnimation {
                        isActive = true
                    }

                }
            }

        }
    }
}

#Preview {
    SplashView()
}
