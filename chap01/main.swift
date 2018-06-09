//
//  main.swift
//  chap01
//
//  Created by eanjee on 2018/6/9.
//  Copyright © 2018 eanjee. All rights reserved.
//

import Foundation

let buffer = makeBuffer(width: 200, height: 100)

for y in 0...buffer.height - 1 {
	for x in 0...buffer.width - 1 {
		let r = Double(x) / Double(buffer.width)
		let g = Double(y) / Double(buffer.height)
		let b = 0.2
		
		buffer.setColor(x: x, y: y, red: r, green: g, blue: b)
	}
}

savePNG(name: "chap01.png", buffer: buffer)

releaseBuffer(buffer: buffer)
