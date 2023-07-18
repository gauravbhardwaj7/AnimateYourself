//
//  ImagePicker.swift
//  AnimateYourself
//
//  Created by Gaurav Bhardwaj on 18/07/23.
//

import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {

    @Binding var images: [UIImage]
    @State var selectionLimit = 0

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> some UIViewController {
        var config = PHPickerConfiguration()
        config.preferredAssetRepresentationMode = .compatible
        config.filter = .images
        config.selection = .ordered
        config.selectionLimit = selectionLimit

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator

        return picker
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            self.parent.images.removeAll()
            self.parent.images = Array(repeating: UIImage(), count: results.count)

            for i in 0..<results.count {
                addPhoto(result: results[i], index: i)
            }
            picker.dismiss(animated: true)
        }

        func addPhoto (result: PHPickerResult, index: Int) {
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) {object, _ in
                    if let image = object as? UIImage {
                        DispatchQueue.main.async {
                            guard let cgimage = image.cgImage else {
                                return
                            }
                            let imageLength = min(cgimage.width, cgimage.height)
                            let xOffset = (cgimage.width - imageLength) / 2
                            let yOffset = (cgimage.height - imageLength) / 2

                            self.parent.images[index] = UIImage(cgImage: (cgimage.cropping(to: CGRect(x: xOffset, y: yOffset, width: imageLength, height: imageLength)))!, scale: image.scale, orientation: image.imageOrientation)
                        }
                    }
                }
            }
        }
    }
}

