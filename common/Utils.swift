//
//  Utils.swift
//  RayTracingInOneWeekendWithSwift
//
//  Created by eanjee on 2018/6/9.
//  Copyright © 2018 eanjee. All rights reserved.
//

import Foundation

struct CanvasBuffer {
	var raw: UnsafeMutableRawPointer
	var data: UnsafeMutableRawBufferPointer
	var width: Int
	var height: Int
	var bytePerRow: Int
	var byteCount: Int
	
	init(width: Int, height: Int) {
		self.width = width
		self.height = height
		
		bytePerRow = width * 4
		byteCount = bytePerRow * height
		
		raw = UnsafeMutableRawPointer.allocate(byteCount: byteCount,
											   alignment: 1)
		data = UnsafeMutableRawBufferPointer(start: raw,
											 count: byteCount)
	}
	
	func setColor(x: Int, y: Int, red: Double, green: Double, blue: Double) {
		// origin at bottom left
		let index = ((height - 1 - y) * width + x) * 4
		
		data[index + 0] = UInt8(255.99 * red)
		data[index + 1] = UInt8(255.99 * green)
		data[index + 2] = UInt8(255.99 * blue)
	}
}

func makeBuffer(width: Int, height: Int) -> CanvasBuffer {
	return CanvasBuffer(width: width, height: height)
}

func releaseBuffer(buffer: CanvasBuffer) {
	buffer.raw.deallocate()
}

func savePNG(name: String, buffer: CanvasBuffer) {
	savePNG(name: name, width: buffer.width, height: buffer.height,
			data: buffer.raw)
}

func savePNG(name: String, width: Int, height: Int,
			 data: UnsafeMutableRawPointer) {
	guard let colorSpace = CGColorSpace(name: CGColorSpace.sRGB) else {
		print("CGColorSpace create failed")
		return
	}
	
	let dataByteCount = width * height * 4
	let typedData = CFDataCreate(nil, data.assumingMemoryBound(to: UInt8.self),
								 dataByteCount)
	guard let dataProvider = CGDataProvider(data: typedData!) else {
		print("CGDataProvider create failed")
		return
	}
	
	let img = CGImage(width: width, height: height, bitsPerComponent: 8,
					  bitsPerPixel: 32, bytesPerRow: width * 4,
					  space: colorSpace,
					  bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipLast.rawValue),
					  provider: dataProvider, decode: nil,
					  shouldInterpolate: false,
					  intent: CGColorRenderingIntent.defaultIntent)
	guard let imgWrapped = img else {
		print("CGImage create failed")
		return
	}
	
	let url = URL(fileURLWithPath: name)
	let imgDest = CGImageDestinationCreateWithURL(url as CFURL,
												  "public.png" as CFString,
												  1, nil)
	guard let imgDestWrapped = imgDest else {
		print("CGImageDestination create failed")
		return
	}
	
	CGImageDestinationAddImage(imgDestWrapped, imgWrapped, nil)
	CGImageDestinationFinalize(imgDestWrapped)
}
