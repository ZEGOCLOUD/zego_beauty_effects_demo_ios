//
//  ZegoImageHelper.swift
//  ZegoBeautyEffectsDemo
//
//  Created by zego on 2023/9/12.
//

import Foundation
import UIKit
import CoreVideo
import CoreGraphics

class ImageHelper {
    
    static func CVPixelBufferRefFromUiImage(_ img: UIImage) -> CVPixelBuffer? {
        let newImage: UIImage? = scaleAndRotateImage(image: img) ?? nil
        return pixelBuffer(from: newImage?.cgImage)
    }
    
    static func bitmapInfoWithPixelFormatType(inputPixelFormat: OSType, hasAlpha: Bool) -> UInt32 {
        return CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
//        if inputPixelFormat == kCVPixelFormatType_32BGRA {
//            var bitmapInfo: UInt32 = CGBitmapInfo.pre.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
//            if !hasAlpha {
//                bitmapInfo = CGImageAlphaInfo.noneSkipFirst.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
//            }
//            return bitmapInfo
//        } else if inputPixelFormat == kCVPixelFormatType_32ARGB {
//            let bitmapInfo: UInt32 = CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
//            return bitmapInfo
//        } else {
//            print("This format is not supported")
//            return 0
//        }
    }

    static func inputPixelFormat() -> OSType {
        return kCVPixelFormatType_32BGRA
    }

    static func pixelBuffer(from image: CGImage?) -> CVPixelBuffer? {
        guard let image = image else {
            return nil
        }
        
        let hasAlpha = cgImageContainsAlpha(image)
        
        let options: [String: Any] = [
            kCVPixelBufferCGImageCompatibilityKey as String: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey as String: true,
            kCVPixelBufferIOSurfacePropertiesKey as String: [:]
        ]
        
        var pxbuffer: CVPixelBuffer?
        
        let frameWidth = CGFloat(image.width)
        let frameHeight = CGFloat(image.height)
        
        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         Int(frameWidth),
                                         Int(frameHeight),
                                         inputPixelFormat(),
                                         options as CFDictionary,
                                         &pxbuffer)
        
        assert(status == kCVReturnSuccess && pxbuffer != nil, "Failed to create pixel buffer")
        
        CVPixelBufferLockBaseAddress(pxbuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pxdata = CVPixelBufferGetBaseAddress(pxbuffer!)
        assert(pxdata != nil, "Failed to get base address of pixel buffer")
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        
        let bitmapInfo = bitmapInfoWithPixelFormatType(inputPixelFormat: inputPixelFormat(), hasAlpha: hasAlpha)
        
        let context = CGContext(data: pxdata,
                                width: Int(frameWidth),
                                height: Int(frameHeight),
                                bitsPerComponent: 8,
                                bytesPerRow: CVPixelBufferGetBytesPerRow(pxbuffer!),
                                space: rgbColorSpace,
                                bitmapInfo: bitmapInfo)
        
        assert(context != nil, "Failed to create bitmap context")
        
        context!.concatenate(CGAffineTransform.identity)
        context!.draw(image, in: CGRect(x: 0, y: 0, width: frameWidth, height: frameHeight))
        
        CVPixelBufferUnlockBaseAddress(pxbuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pxbuffer
    }

    static func cgImageContainsAlpha(_ imageRef: CGImage?) -> Bool {
        guard let imageRef = imageRef else {
            return false
        }
        
        let alphaInfo = imageRef.alphaInfo
        let hasAlpha = !(alphaInfo == .none ||
                         alphaInfo == .noneSkipFirst ||
                         alphaInfo == .noneSkipLast)
        
        return hasAlpha
    }

    static func scaleAndRotateImage(image: UIImage) -> UIImage? {
        var kMaxResolution: CGFloat = 320
        var scale: CGFloat = 1.0
        if UIScreen.main.responds(to: #selector(getter: UIScreen.scale)) {
        scale = UIScreen.main.scale
        kMaxResolution *= scale
        }
        
        guard let imgRef = image.cgImage else {
            return nil
        }

        let width = CGFloat(imgRef.width)
        let height = CGFloat(imgRef.height)

        var transform = CGAffineTransform.identity
        var bounds = CGRect(x: 0, y: 0, width: width, height: height)
        if width > kMaxResolution || height > kMaxResolution {
            let ratio = width / height
            if ratio > 1 {
                bounds.size.width = kMaxResolution
                bounds.size.height = round(bounds.size.width / ratio)
            } else {
                bounds.size.height = kMaxResolution
                bounds.size.width = round(bounds.size.height * ratio)
            }
        }

        let scaleRatio = bounds.size.width / width
        let imageSize = CGSize(width: CGFloat(imgRef.width), height: CGFloat(imgRef.height))
        var boundHeight: CGFloat

        let orient = image.imageOrientation
        switch orient {
        case .up:
            transform = CGAffineTransform.identity
        case .upMirrored:
            transform = CGAffineTransform(translationX: imageSize.width, y: 0.0)
            transform = transform.scaledBy(x: -1.0, y: 1.0)
        case .down:
            transform = CGAffineTransform(translationX: imageSize.width, y: imageSize.height)
            transform = transform.rotated(by: CGFloat.pi)
        case .downMirrored:
            transform = CGAffineTransform(translationX: 0.0, y: imageSize.height)
            transform = transform.scaledBy(x: 1.0, y: -1.0)
        case .leftMirrored:
            boundHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundHeight
            transform = CGAffineTransform(translationX: imageSize.height, y: imageSize.width)
            transform = transform.scaledBy(x: -1.0, y: 1.0)
            transform = transform.rotated(by: 3.0 * CGFloat.pi / 2.0)
        case .left:
            boundHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundHeight
            transform = CGAffineTransform(translationX: 0.0, y: imageSize.width)
            transform = transform.rotated(by: 3.0 * CGFloat.pi / 2.0)
        case .rightMirrored:
            boundHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundHeight
            transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
        case .right:
            boundHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundHeight
            transform = CGAffineTransform(translationX: imageSize.height, y: 0.0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
        default:
            fatalError("Invalid image orientation")
        }

        UIGraphicsBeginImageContext(bounds.size)

        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }

        if orient == .right || orient == .left {
            context.scaleBy(x: -scaleRatio, y: scaleRatio)
            context.translateBy(x: -height, y: 0)
        } else {
            context.scaleBy(x: scaleRatio, y: -scaleRatio)
            context.translateBy(x: 0, y: -height)
        }

        context.concatenate(transform)

        context.draw(imgRef, in: CGRect(x: 0, y: 0, width: width, height: height))
        let imageCopy = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageCopy
        
    }
    
}

