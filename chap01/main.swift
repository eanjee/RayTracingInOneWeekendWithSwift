//
//  main.swift
//  chap01
//
//  Created by eanjee on 2018/6/9.
//  Copyright © 2018 eanjee. All rights reserved.
//

import Foundation

let canvas = Canvas(width: 200, height: 100)

for y in 0...canvas.height - 1 {
    for x in 0...canvas.width - 1 {
        let r = Double(x) / Double(canvas.width)
        let g = Double(y) / Double(canvas.height)
        let b = 0.2
        
        canvas.setColor(x: x, y: y, red: r, green: g, blue: b)
    }
}

canvas.savePNG(name: "chap01.png")
