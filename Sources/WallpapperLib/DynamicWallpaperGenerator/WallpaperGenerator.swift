//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//  Modified by © 2024 Richard Jorne.
//  https://
//

import Foundation
import AppKit
import AVFoundation

public class WallpaperGenerator {
    
    public init() {
    }
    
    public func generate(pictureInfos: [PictureInfo], pictures: [NSImage], outputFileDir: String) throws -> URL? {
        let consoleIO = ConsoleIO()
        let options = [kCGImageDestinationLossyCompressionQuality: 1.0]
                    
            let imageMetadataGenerator = ImageMetadataGenerator(pictureInfos: pictureInfos)
            let imageMetadata = try imageMetadataGenerator.getImageMetadata()
            let images = imageMetadataGenerator.imageDirs()
            
            let destinationData = NSMutableData()
        if let destination = CGImageDestinationCreateWithData(destinationData, AVFileType.heic as CFString, images.count, nil) {
            for (index, _) in images.enumerated() {
//                let fileURL = URL(fileURLWithPath: fileName)
//                guard let fileURL = URL(string: fileName) else {
//                    consoleIO.writeMessage("Image URL Invalid: '\(fileName)'.\n", to: .debug)
//                    throw DalpperErrors.imageURLInvalid(urlString: fileName)
//                }
//                    consoleIO.writeMessage("Reading image file: '\(fileURL.absoluteString)'...", to: .debug)
//                    guard let orginalImage = NSImage(contentsOf: fileURL) else {
//                        consoleIO.writeMessage("ERROR.\n", to: .debug)
//                        throw DalpperErrors.imageLoadFailed(urlString: fileName)
//                    }
                let originalImage = pictures[index]

                    consoleIO.writeMessage("OK.\n", to: .debug)

                    if let cgImage = originalImage.CGImage {
                        if index == 0 {
                            consoleIO.writeMessage("Adding image and metadata...", to: .debug)
                            CGImageDestinationAddImageAndMetadata(destination, cgImage, imageMetadata, options as CFDictionary)
                            consoleIO.writeMessage("OK.\n", to: .debug)
                        } else {
                            consoleIO.writeMessage("Adding image...", to: .debug)
                            CGImageDestinationAddImage(destination, cgImage, options as CFDictionary)
                            consoleIO.writeMessage("OK.\n", to: .debug)
                        }
                    }
                }

                consoleIO.writeMessage("Finalizing image container...", to: .debug)
                guard CGImageDestinationFinalize(destination) else {
                    throw ImageMetadataGeneratorError.imageNotFinalized
                }
                consoleIO.writeMessage("OK.\n", to: .debug)

                let outputURL = URL(fileURLWithPath: outputFileDir)
                consoleIO.writeMessage("Saving data to file '\(outputURL.absoluteString)'...", to: .debug)
                let imageData = destinationData as Data
                try imageData.write(to: outputURL)
                consoleIO.writeMessage("OK.\n", to: .debug)
            return outputURL
            }
        return nil
    }
}
