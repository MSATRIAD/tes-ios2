import SwiftUI
import SwiftData

@main
struct tesApp: App { // Sesuaikan dengan nama struct App Anda
    
    // Siapkan wadah database-nya
    let container: ModelContainer
    
    init() {
        do {
            // Daftarkan semua tabel (Model) yang Anda gunakan
            container = try ModelContainer(for: ActivityItem.self, CompletedTask.self, DiaryEntry.self)
            
            // PANGGIL SEEDER DI SINI! (Sebelum layar manapun terbuka)
            // Ini akan mengisi data 3 kategori Anda secara otomatis
            DataSeeder.seed(context: container.mainContext)
            
        } catch {
            fatalError("Gagal menyiapkan SwiftData: \(error.localizedDescription)")
        }
    }

    var body: some Scene {
        WindowGroup {
            // Ini halaman pertama yang muncul saat aplikasi dibuka
            SplashView()
        }
        .modelContainer(container) // Berikan database ke seluruh aplikasi
    }
}
