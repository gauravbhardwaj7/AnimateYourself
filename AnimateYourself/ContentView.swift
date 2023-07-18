//
//  ContentView.swift
//  AnimateYourself
//
//  Created by Gaurav Bhardwaj on 18/07/23.
//

import SwiftUI

struct ContentView: View {
    @State var isCameraPickerShow = false
    @State var isImagePickerShow = false
    @State private var isFilterSelected = false
    @State private var showsAlert = false

    @State var images: [UIImage] = []

    @State private var selectedModel: StyleModel = .Filter
    @State private var transferImage: UIImage?

    @State private var previousModel: StyleModel?
    @State private var convertedImages: [StyleModel: UIImage] = [:]

    var body: some View {
        VStack {
            Spacer()

            if let selectedImage = images.first {
                if let cachedImage = convertedImages[selectedModel] {
                    Image(uiImage: cachedImage)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding()
                } else if let transferImage = transferImage {
                    Image(uiImage: transferImage)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding()
                } else {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding()
                }
            }

            Spacer()

            Picker("Select Filter", selection: $selectedModel) {
                ForEach(StyleModel.allCases, id: \.self) { model in
                    Text(model.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            .onChange(of: selectedModel, perform: { tag in
                if let cachedImage = convertedImages[tag] {
                    // Use the cached converted image
                    transferImage = cachedImage
                } else if !images.isEmpty {
                  self.isFilterSelected = true
                    previousModel = tag

                    DispatchQueue.global(qos: .userInteractive).async {
                        transferImageStyle(selectedImage: images[0], transferImage: &transferImage, selectedModel: tag)

                        // Cache the converted image
                        convertedImages[tag] = transferImage

                      self.isFilterSelected = false
                    }
                }
            })

            Button(action: {
                isImagePickerShow.toggle()
            }) {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
            }
        }
        .padding()
        .sheet(isPresented: $isImagePickerShow) {
            ImagePicker(images: $images, selectionLimit: 1)
                .onDisappear() {
                    withAnimation {
                        transferImage = nil
                        selectedModel = .Filter
                    }
                }
        }
    }
}

