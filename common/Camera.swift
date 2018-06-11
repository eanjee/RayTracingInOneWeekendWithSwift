//
//  Camera.swift
//  RayTracingInOneWeekendWithSwift
//
//  Created by eanjee on 2018/6/11.
//  Copyright © 2018 eanjee. All rights reserved.
//

struct Camera {
    init() {
        origin = Vec3(0, 0, 0)
        lowerLeftCorner = Vec3(-2, -1, -1)
        horizontal = Vec3(4, 0, 0)
        vertical = Vec3(0, 2, 0)
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
