//
//  Camera.swift
//  RayTracingInOneWeekendWithSwift
//
//  Created by eanjee on 2018/6/11.
//  Copyright © 2018 eanjee. All rights reserved.
//

import Darwin

struct Camera {
    init() {
        origin = Vec3(0, 0, 0)
        lowerLeftCorner = Vec3(-2, -1, -1)
        horizontal = Vec3(4, 0, 0)
        vertical = Vec3(0, 2, 0)
    }
    
    init(lookFrom: Vec3, lookAt: Vec3, up: Vec3, fov: Double, aspect: Double) {
        let theta = fov * Double.pi / 180.0
        let halfHeight = tan(theta * 0.5)
        let halfWidth = aspect * halfHeight
        
        origin = lookFrom
        let w = (lookFrom - lookAt).normalized()
        let u = Vec3.cross(up, w).normalized()
        let v = Vec3.cross(w, u)
        
        lowerLeftCorner = origin - halfWidth * u - halfHeight * v - w
        horizontal = 2.0 * halfWidth * u
        vertical = 2.0 * halfHeight * v
    }
    
    func getRay(u: Double, v: Double) -> Ray {
        return Ray(a: origin,
                   b: lowerLeftCorner + u * horizontal + v * vertical - origin)
    }
    
    var origin: Vec3
    var lowerLeftCorner: Vec3
    var horizontal: Vec3
    var vertical: Vec3
}
