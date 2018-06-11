//
//  main.swift
//  chap06
//
//  Created by eanjee on 2018/6/11.
//  Copyright © 2018 eanjee. All rights reserved.
//

import Foundation

func color(r: Ray, hitable: Hitable) -> Vec3 {
    var hitRecord = HitRecord()
    
    if hitable.hit(r: r, tMin: 0.0, tMax: Double.greatestFiniteMagnitude,
                   rec: &hitRecord) {
        // HitRecord.normal is normalized
        // scale [-1, 1] to [0, 1] for each component
        return 0.5 * (hitRecord.normal + 1.0)
    } else {
        let unitDirection = r.direction.normalized()
        // scale Y to [0.0, 1.0]
        let t = 0.5 * (unitDirection.y + 1.0)
        // lerp white and blue on the up/downess of Y
        return (1.0 - t) * Vec3(1.0, 1.0, 1.0) + t * Vec3(0.5, 0.7, 1.0)
    }
}

let canvas = Canvas(width: 200, height: 100)
let world = HitableList(list: [Sphere(center: Vec3(0, 0, -1), radius: 0.5),
                               Sphere(center: Vec3(0, -100.5, -1), radius: 100)])
let camera = Camera()
let ns = 100

for y in 0...canvas.height - 1 {
    for x in 0...canvas.width - 1 {
        var col = Vec3(0, 0, 0)
        for _ in 0...ns - 1 {
            let u = (Double(x) + drand48()) / Double(canvas.width)
            let v = (Double(y) + drand48()) / Double(canvas.height)
            let ray = camera.getRay(u: u, v: v)
            
            col += color(r: ray, hitable: world)
        }
        col /= Double(ns)
        
        canvas.setColor(x: x, y: y, color: col)
    }
}

canvas.savePNG(name: "chap06.png")

