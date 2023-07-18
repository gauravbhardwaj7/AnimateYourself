//
//  ImageSaver.swift
//  AnimateYourself
//
//  Created by Gaurav Bhardwaj on 18/07/23.
//

import SwiftUI

class ImageSaver {
    static func saveTransferImage(transferImage: UIImage?) {
        guard let transferImage = transferImage else {
            return
        }
        print(transferImage.size)
        UIImageWriteToSavedPhotosAlbum(transferImage, nil, #selector(saveCompleted(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save Finished!")
    }
}

