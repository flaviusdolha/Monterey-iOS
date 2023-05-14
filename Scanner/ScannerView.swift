import Core
import Design
import SwiftUI

// MARK: - ScannerView

public struct ScannerView: View {
    
    // MARK: - Properties

    var interactor: ScannerInteractor?
    @ObservedObject var state: ScannerState
    @ObservedObject var router: ScannerRouter
    @State var isShowingImagePickerGallery = false
    @State var isShowingImagePickerCamera = false
    
    // MARK: - Body

    public var body: some View {
        NavigationStack(path: router.binding) {
            List {
                VStack {
                    Text("Add transactions\nby scanning receipts photos.".localized)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .padding()
                    HStack(spacing: 24) {
                        Spacer()
                        VStack {
                            Button {
                                isShowingImagePickerGallery = true
                            } label: {
                                ZStack {
                                    Circle()
                                        .foregroundColor(.mint)
                                        .frame(width: 72, height: 72)
                                    Image(systemName: "photo.on.rectangle.angled")
                                        .font(.system(size: 32))
                                        .foregroundColor(.white)
                                }
                            }
                            .buttonStyle(.plain)
                            Text("Import from gallery".localized)
                                .font(.caption)
                        }
                        VStack {
                            Button {
                                isShowingImagePickerCamera = true
                            } label: {
                                ZStack {
                                    Circle()
                                        .foregroundColor(.mint)
                                        .frame(width: 72, height: 72)
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 32))
                                        .foregroundColor(.white)
                                }
                            }
                            .buttonStyle(.plain)
                            Text("Take a photo".localized)
                                .font(.caption)
                        }
                        Spacer()
                    }
                    .padding()
                }
            }
            .montereyNavBar()
            .montereyTabBar()
            .navigationTitle("Scan Receipt".localized)
            .navigationDestination(for: ScannerRoute.self) { route in
                router.view(for: route)
            }
            .sheet(isPresented: $isShowingImagePickerGallery) {
                ImagePicker(sourceType: .photoLibrary) { photo in
                    interactor?.didSelectPicture(photo)
                }
            }
            .sheet(isPresented: $isShowingImagePickerCamera) {
                ImagePicker(sourceType: .camera) { photo in
                    interactor?.didSelectPicture(photo)
                }
            }
        }
        .overlay {
            if state.isLoading {
                ZStack {
                    Color.gray.opacity(0.3)
                        .ignoresSafeArea()
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(.white)
                        .frame(width: 72, height: 72)
                    ProgressView()
                        .scaleEffect(1.5)
                }
            } else {
                EmptyView()
            }
        }
    }
}
