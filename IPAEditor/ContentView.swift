import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var isImporterPresented = false
    @State private var selectedFileName: String = "No File Selected"
    
    var body: some View {
        ZStack {
            // AMOLED Black Background
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 30) {
                Image(systemName: "doc.zipper")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.white)
                
                Text("IPA Editor")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(selectedFileName)
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Button(action: {
                    isImporterPresented = true
                }) {
                    Text("Import .ipa File")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.horizontal, 40)
                }
            }
        }
        .fileImporter(
            isPresented: $isImporterPresented,
            allowedContentTypes: [UTType.archive, UTType.item],
            allowsMultipleSelection: false
        ) { result in
            do {
                guard let selectedFile: URL = try result.get().first else { return }
                
                // Security check to access the file
                if selectedFile.startAccessingSecurityScopedResource() {
                    selectedFileName = "Selected: \(selectedFile.lastPathComponent)"
                    // Here you will add the logic to unzip the IPA and read Info.plist
                    selectedFile.stopAccessingSecurityScopedResource()
                } else {
                    selectedFileName = "Failed to access file"
                }
            } catch {
                selectedFileName = "Error reading file: \(error.localizedDescription)"
            }
        }
    }
}
