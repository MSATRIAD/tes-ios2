import SwiftUI

struct UserInfoView: View {

    // MARK: - App Storage
    // Kita simpan nama ke AppStorage agar bisa diakses secara global oleh Profile dan Home
    @AppStorage("userName") var storedUserName: String = ""
    
    // MARK: - State
    @State private var name: String = ""
    @State private var goToCategories = false
    
    @FocusState private var nameFocused: Bool
    
    @State private var headerOffset: CGFloat = 30
    @State private var headerOpacity: Double = 0

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()

                VStack(alignment: .leading, spacing: 28) {
                    header
                    nameInput
                }
                .padding(.horizontal, 32)

                Spacer()

                continueButton
            }
            .background(Color.backgroundApp)
            .navigationBarBackButtonHidden(true)
            // Mengirimkan nama yang baru diketik ke halaman pilihan kategori
            .navigationDestination(isPresented: $goToCategories) {
                CategorySelectionView(userName: name)
            }
        }
        .onAppear {
            // Jika sebelumnya sudah ada nama tersimpan, kita tampilkan di field
            if !storedUserName.isEmpty {
                name = storedUserName
            }

            withAnimation(.easeOut(duration: 0.6)) {
                headerOffset = 0
                headerOpacity = 1
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                nameFocused = true
            }
        }
    }
}

extension UserInfoView {

    // MARK: - Header
    var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Halo,")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(Color.textPrimary)

            Text("Siapa nama kamu?")
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(Color.textSecondary)
        }
        .offset(y: headerOffset)
        .opacity(headerOpacity)
    }

    // MARK: - Name Input
    var nameInput: some View {
        TextField("Ketik nama kamu...", text: $name)
            .font(.system(size: 20, weight: .medium))
            .padding()
            .background(Color.cardBackground)
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(
                        nameFocused ? Color.primaryBrand : Color.borderLight,
                        lineWidth: 1.5
                    )
            )
            .focused($nameFocused)
            .submitLabel(.done)
    }

    // MARK: - Continue Button
    var continueButton: some View {
        Button {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()


            storedUserName = name
            
            nameFocused = false
            goToCategories = true

        } label: {
            Text("Lanjut")
                .font(.system(size: 18, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    name.isEmpty ? Color.gray.opacity(0.25) : Color.primaryBrand
                )
                .foregroundColor(.white)
                .cornerRadius(16)
        }
        .disabled(name.isEmpty)
        .padding(.horizontal, 32)
        .padding(.bottom, 40)
        .animation(.easeInOut(duration: 0.2), value: name.isEmpty)
    }
}

#Preview {
    UserInfoView()
}
