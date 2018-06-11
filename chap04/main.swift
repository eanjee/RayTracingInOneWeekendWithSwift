//
//  main.swift
//  chap04
//
//  Created by eanjee on 2018/6/11.
//  Copyright © 2018 eanjee. All rights reserved.
//

import Foundation

// sphere equation, center at C: (cx, cy, cz), radius: R
// (x - cx) * (x - cx) + (y - cy) * (y - cy) + (z - cz) * (z - cz) = R * R
// that is, for point P
// dot((P - C), (P - C)) = R * R
//
// if ray p(t) = A + t*B ever hits the sphere, then
// there is some t for which p(t) satisfies the sphere equation
//
// dot((A + t*B - C), (A + t*B - C)) = R * R
// t * t * dot(B, B) + 2 * t * dot(B, A - C) + dot(A - C, A - C) - R * R = 0
func hitSphere(center: Vec3, radius: Double, ray: Ray) -> Bool {
    // A - C
    let oc = ray.origin - center;
    // dot(B, B)
    let a = Vec3.dot(ray.direction, ray.direction)
    // 2 * dot(B, A - C)
    let b = 2.0 * Vec3.dot(ray.direction, oc)
    // dot(A - C, A - C) - R * R
    let c = Vec3.dot(oc, oc) - radius * radius
    
    let discriminant = b * b - 4 * a * c
    
    return discriminant > 0
}

func color(ray: Ray) -> Vec3 {
    if hitSphere(center: Vec3(0, 0, -1), radius: 0.5, ray: ray) {
        return Vec3(1, 0, 0)
    }
    
    let unitDirection = ray.direction.normalized()
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
        
        canvas.setColor(x: x, y: y, color: color(ray: ray))
    }
}

canvas.savePNG(name: "chap04.png")
