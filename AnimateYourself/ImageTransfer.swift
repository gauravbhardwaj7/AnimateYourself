//
//  ImageTransfer.swift
//  AnimateYourself
//
//  Created by Gaurav Bhardwaj on 18/07/23.
//

import SwiftUI
import CoreML
import VideoToolbox


enum StyleModel: String, CaseIterable {
    case Filter
  case FacePaint
    case Hayao
    case Paprika
    case Cartoon
  case WhiteBox
//  case Anime

}

func transferImageStyle(selectedImage: UIImage?, transferImage: inout UIImage?, selectedModel: StyleModel) {
    do {
        var cgImage: CGImage?

        guard let selectedImage = selectedImage else {
            return
        }

        guard let inputImage = selectedImage.cgImage else {
            return
        }

        try imageToAnime(inputImage: inputImage, cgImage: &cgImage, selectedModel: selectedModel)

        guard let cgImage = cgImage else {
            return
        }

        let imageLength = min(cgImage.width, cgImage.height)
        let xOffset = (cgImage.width - imageLength) / 2
        let yOffset = (cgImage.height - imageLength) / 2

        transferImage = UIImage(cgImage: (cgImage.cropping(to: CGRect(x: xOffset, y: yOffset, width: imageLength, height: imageLength)))!, scale: selectedImage.scale, orientation: selectedImage.imageOrientation)
    } catch (let error) {
        print(error)
    }
}

func imageToAnime(inputImage: CGImage, cgImage: inout CGImage?, selectedModel: StyleModel) throws {
  let config = MLModelConfiguration()
  config.computeUnits = .all

  switch selectedModel {
  case .Filter:
    break

  case .WhiteBox:
    let sketchModel = try whiteboxcartoonization(configuration: config)
    let sketchPrediction = try sketchModel.prediction(input: .init(PlaceholderWith: inputImage))
    VTCreateCGImageFromCVPixelBuffer(sketchPrediction.activation_out, options: nil, imageOut: &cgImage)


  case .Hayao:
    let hayaoModel = try animeganHayao(configuration: config)
    let hayaoPrediction = try hayaoModel.prediction(input: .init(test__0With: inputImage))
    VTCreateCGImageFromCVPixelBuffer(hayaoPrediction.image, options: nil, imageOut: &cgImage)

  case .Paprika:
    let paprikaModel = try animeganPaprika(configuration: config)
    let paprikaPrediction = try paprikaModel.prediction(input: .init(test__0With: inputImage))
    VTCreateCGImageFromCVPixelBuffer(paprikaPrediction.image, options: nil, imageOut: &cgImage)

  case .Cartoon:
    let cartoonModel = try photo2cartoon(configuration: config)
    let cartoonPrediction = try cartoonModel.prediction(input: .init(inputWith: inputImage))
    VTCreateCGImageFromCVPixelBuffer(cartoonPrediction.activation_out, options: nil, imageOut: &cgImage)

  case .FacePaint:
    let facePaintModel = try animegan2face_paint_512_v2(configuration: config)
    let facePaintPrediction = try facePaintModel.prediction(input: .init(inputWith: inputImage))
    VTCreateCGImageFromCVPixelBuffer(facePaintPrediction.activation_out, options: nil, imageOut: &cgImage)
    //    case .Anime:
    //        let facePaintModel = try anime2sketch(configuration: config)
    //      let facePaintPrediction = try facePaintModel.prediction(input: .init(input_1With: inputImage))
    //        VTCreateCGImageFromCVPixelBuffer(facePaintPrediction.activation_out, options: nil, imageOut: &cgImage)
    //    }
  }

}

