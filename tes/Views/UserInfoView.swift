import SwiftUI

struct UserInfoView: View {

    // MARK: State
    
    @State private var name: String = ""
    @State private var birthDate = Date()
    @State private var goToCategories = false
    
    @FocusState private var nameFocused: Bool
    
    // Animation states
    
    @State private var headerOffset: CGFloat = 40
    @State private var headerOpacity: Double = 0

    var body: some View {

        NavigationStack {

            VStack(spacing: 0) {

                ScrollView {

                    VStack(alignment: .leading, spacing: 32) {

                        header
                            .offset(y: headerOffset)
                            .opacity(headerOpacity)

                        nameInput

                        birthDateInput

                    }
                    .padding(24)

                }

                continueButton

            }
            .background(Color.backgroundApp)
            .navigationBarBackButtonHidden(true)

            .navigationDestination(isPresented: $goToCategories) {

                CategorySelectionView()

            }
        }
        .onAppear {

            // Header entrance animation
            
            withAnimation(.easeOut(duration: 0.6)) {
                headerOffset = 0
                headerOpacity = 1
            }

            nameFocused = true
        }
    }
}

extension UserInfoView {

    // MARK: Header

    var header: some View {

        VStack(alignment: .leading, spacing: 8) {

            Text("Mari mulai perjalananmu")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Color.textPrimary)

            Text("Masukkan nama dan tanggal lahirmu untuk personalisasi pengalaman.")
                .font(.subheadline)
                .foregroundColor(Color.textSecondary)
        }
    }

    // MARK: Name Input

    var nameInput: some View {

        VStack(alignment: .leading, spacing: 8) {

            Text("Nama")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color.textPrimary)

            TextField("Masukkan nama kamu", text: $name)
                .padding()
                .background(Color.cardBackground)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            nameFocused ?
                            Color.primaryBrand :
                            Color.borderLight,
                            lineWidth: 1.5
                        )
                        .animation(.easeInOut(duration: 0.2), value: nameFocused)
                )
                .focused($nameFocused)
        }
    }

    // MARK: Birth Date

    var birthDateInput: some View {

        VStack(alignment: .leading, spacing: 8) {

            Text("Tanggal Lahir")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color.textPrimary)

            DatePicker(
                "",
                selection: $birthDate,
                displayedComponents: .date
            )
            .datePickerStyle(.compact)
            .padding()
            .background(Color.cardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.borderLight)
            )
        }
    }

    // MARK: Continue Button

    var continueButton: some View {

        Button {

            UIImpactFeedbackGenerator(style: .medium).impactOccurred()

            nameFocused = false

            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                goToCategories = true
            }

        } label: {

            Text("Lanjut")
                .font(.system(size: 17, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    name.isEmpty ?
                    Color.gray.opacity(0.2) :
                    Color.primaryBrand
                )
                .foregroundColor(.white)
                .cornerRadius(14)
                .scaleEffect(name.isEmpty ? 1 : 1.02)
                .animation(.easeInOut(duration: 0.2), value: name.isEmpty)
        }
        .disabled(name.isEmpty)
        .padding(24)
    }
}

#Preview {
    UserInfoView()
}
