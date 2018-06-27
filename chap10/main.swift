//
//  main.swift
//  chap10
//
//  Created by eanjee on 2018/6/27.
//  Copyright © 2018 eanjee. All rights reserved.
//

import Foundation

func color(r: Ray, hitable: Hitable, depth: Double) -> Vec3 {
    var hitRecord = HitRecord()
    
    if hitable.hit(r: r, tMin: 0.001, tMax: Double.greatestFiniteMagnitude,
                   rec: &hitRecord) {
        if let mat = hitRecord.material {
            var scattered = Ray(a: Vec3(0, 0, 0), b: Vec3(0, 0, 0))
            var attenuation = Vec3(0, 0, 0)
            if depth < 50 &&
                mat.scatter(r: r, rec: hitRecord, attenuation: &attenuation,
                            scattered: &scattered) {
                return attenuation * color(r: scattered, hitable: hitable,
                                           depth: depth + 1)
            } else {
                return Vec3(0, 0, 0)
            }
        } else {
            // invalid material
            return Vec3(0.99, 0.16, 0.99)
        }
        
    } else {
        let unitDirection = r.direction.normalized()
        // scale Y to [0.0, 1.0]
        let t = 0.5 * (unitDirection.y + 1.0)
        // lerp white and blue on the up/downess of Y
        return (1.0 - t) * Vec3(1.0, 1.0, 1.0) + t * Vec3(0.5, 0.7, 1.0)
    }
}

let canvas = Canvas(width: 200, height: 100)
let world = HitableList(list: [Sphere(center: Vec3(0, 0, -1), radius: 0.5,
                                      material: Lambertian(albedo: Vec3(0.1, 0.2, 0.5))),
                               Sphere(center: Vec3(0, -100.5, -1), radius: 100,
                                      material: Lambertian(albedo: Vec3(0.8, 0.8, 0.0))),
                               Sphere(center: Vec3(1, 0, -1), radius: 0.5,
                                      material: Metal(albedo: Vec3(0.8, 0.6, 0.2), fuzz: 1.0)),
                               Sphere(center: Vec3(-1, 0, -1), radius: 0.5,
                                      material: Dielectric(refractionIndex: 1.5))])
let camera = Camera(lookFrom: Vec3(-2, 2, 1), lookAt: Vec3(0, 0, -1),
                    up: Vec3(0, 1, 0), fov: 20, aspect: 200.0 / 100.0)
let ns = 100

for y in 0...canvas.height - 1 {
    for x in 0...canvas.width - 1 {
        var col = Vec3(0, 0, 0)
        for _ in 0...ns - 1 {
            let u = (Double(x) + drand48()) / Double(canvas.width)
            let v = (Double(y) + drand48()) / Double(canvas.height)
            let ray = camera.getRay(u: u, v: v)
            
            col += color(r: ray, hitable: world, depth: 0)
        }
        col /= Double(ns)
        col = Vec3(sqrt(col.r), sqrt(col.g), sqrt(col.b))
        
        canvas.setColor(x: x, y: y, color: col)
    }
}

canvas.savePNG(name: "chap10.png")

