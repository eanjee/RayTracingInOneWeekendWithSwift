//
//  Ray.swift
//  RayTracingInOneWeekendWithSwift
//
//  Created by eanjee on 2018/6/11.
//  Copyright © 2018 eanjee. All rights reserved.
//

struct Ray {
    init(a: Vec3, b: Vec3) {
        A = a
        B = b
    }
    
    var origin: Vec3 {
        return A
    }
    
    var direction: Vec3 {
        return B
    }
    
    func pointAt(t: Double) -> Vec3 {
        return A + t * B
    }
    
    var A, B: Vec3
}
