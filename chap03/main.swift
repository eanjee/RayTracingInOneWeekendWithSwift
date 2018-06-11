//
//  main.swift
//  chap03
//
//  Created by eanjee on 2018/6/11.
//  Copyright © 2018 eanjee. All rights reserved.
//

import Foundation

func color(r: Ray) -> Vec3 {
    let unitDirection = r.direction.normalized()
    // scale Y to [0.0, 1.0]
    let t = 0.5 * (unitDirection.y + 1.0)
    // lerp white and blue on the up/downess of Y
    return (1.0 - t) * Vec3(1.0, 1.0, 1.0) + t * Vec3(0.5, 0.7, 1.0)
}

let canvas = Canvas(width: 200, height: 100)

let lowerLeftCorner = Vec3(-2.0, -1.0, -1.0)
let horizontal = Vec3(4.0, 0.0, 0.0)
let vertical = Vec3(0.0, 2.0, 0.0)
let origin = Vec3(0.0, 0.0, 0.0)

for y in 0...canvas.height - 1 {
    for x in 0...canvas.width - 1 {
        let u = Double(x) / Double(canvas.width)
        let v = Double(y) / Double(canvas.height)
        let ray = Ray(a: origin, b: lowerLeftCorner + u * horizontal + v * vertical)
        
        canvas.setColor(x: x, y: y, color: color(r: ray))
    }
}

canvas.savePNG(name: "chap03.png")

