import Foundation

// File ini bertugas mengambil API_KEY dari file GenerativeAI-Info.plist
enum APIKey {
    static var `default`: String {
        guard let filePath = Bundle.main.path(forResource: "GenerativeAI-info", ofType: "plist") else {
            fatalError("Tidak menemukan file plist.")
        }
        
        let plist = NSDictionary(contentsOfFile: filePath)
        
        // Mengambil value dari key "API_KEY"
        guard let rawValue = plist?.object(forKey: "API_KEY") as? String else {
            fatalError("Tidak menemukan 'API_KEY' di dalam plist.")
        }
        
        let value = rawValue
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "\"", with: "")
        
        // TAMBAHAN: Mem-print API Key ke terminal.
        // Tanda kutip tunggal ('') membantu melihat apakah ada spasi kosong di awal/akhir string.
        print("API Key yang terdeteksi: '\(value)'")
        
        if value.starts(with: "_") || value.isEmpty {
            fatalError("Tolong masukkan API Key yang valid di file plist.")
        }
        
        return value
    }
}
