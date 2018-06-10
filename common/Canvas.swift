//
//  Canvas.swift
//  RayTracingInOneWeekendWithSwift
//
//  Created by eanjee on 2018/6/10.
//  Copyright © 2018 eanjee. All rights reserved.
//

import Foundation

class Canvas {
    var raw: UnsafeMutableRawPointer
    var data: UnsafeMutableRawBufferPointer
    var width: Int
    var height: Int
    var bytesPerRow: Int
    var byteCount: Int
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        
        bytesPerRow = width * 4
        byteCount = bytesPerRow * height
        
        raw = UnsafeMutableRawPointer.allocate(byteCount: byteCount,
                                               alignment: 1)
        data = UnsafeMutableRawBufferPointer(start: raw,
                                             count: byteCount)
    }
    
    deinit {
        raw.deallocate()
        print("deinit")
    }
    
    func setColor(x: Int, y: Int, red: Double, green: Double, blue: Double) {
        // origin at bottom left
        let index = ((height - 1 - y) * width + x) * 4
        
        data[index + 0] = UInt8(255.99 * red)
        data[index + 1] = UInt8(255.99 * green)
        data[index + 2] = UInt8(255.99 * blue)
    }
    
    func savePNG(name: String) {
        guard let colorSpace = CGColorSpace(name: CGColorSpace.sRGB) else {
            print("CGColorSpace create failed")
            return
        }
        
        let typedData = CFDataCreate(nil, raw.assumingMemoryBound(to: UInt8.self),
                                     byteCount)
        guard let dataProvider = CGDataProvider(data: typedData!) else {
            print("CGDataProvider create failed")
            return
        }
        
        let img = CGImage(width: width, height: height, bitsPerComponent: 8,
                          bitsPerPixel: 32, bytesPerRow: bytesPerRow,
                          space: colorSpace,
                          bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipLast.rawValue),
                          provider: dataProvider, decode: nil,
                          shouldInterpolate: false,
                          intent: CGColorRenderingIntent.defaultIntent)
        guard let imgUnwrapped = img else {
            print("CGImage create failed")
            return
        }
        
        let url = URL(fileURLWithPath: name)
        let imgDest = CGImageDestinationCreateWithURL(url as CFURL,
                                                      "public.png" as CFString,
                                                      1, nil)
        guard let imgDestUnwrapped = imgDest else {
            print("CGImageDestination create failed")
            return
        }
        
        CGImageDestinationAddImage(imgDestUnwrapped, imgUnwrapped, nil)
        CGImageDestinationFinalize(imgDestUnwrapped)
    }
}
