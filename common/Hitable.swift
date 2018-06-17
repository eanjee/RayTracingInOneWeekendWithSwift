//
//  Hitable.swift
//  RayTracingInOneWeekendWithSwift
//
//  Created by eanjee on 2018/6/11.
//  Copyright © 2018 eanjee. All rights reserved.
//

import Darwin

struct HitRecord {
    init() {
        t = 0
        p = Vec3(0, 0, 0)
        normal = Vec3(0, 0, 0)
    }
    var t: Double
    var p: Vec3
    var normal: Vec3
    var material: Material?
}

protocol Hitable {
    func hit(r: Ray, tMin: Double, tMax: Double, rec: inout HitRecord) -> Bool
}

struct Sphere: Hitable {
    init(center: Vec3, radius: Double) {
        self.center = center
        self.radius = radius
    }
    
    init(center: Vec3, radius: Double, material: Material) {
        self.center = center
        self.radius = radius
        self.material = material
    }
    
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
    func hit(r: Ray, tMin: Double, tMax: Double, rec: inout HitRecord) -> Bool {
        // A - C
        let oc = r.origin - center;
        // dot(B, B)
        let a = Vec3.dot(r.direction, r.direction)
        // 2 * dot(B, A - C)
        let b = 2.0 * Vec3.dot(r.direction, oc)
        // dot(A - C, A - C) - R * R
        let c = Vec3.dot(oc, oc) - radius * radius
        
        let discriminant = b * b - 4 * a * c
        if discriminant > 0 {
            var temp = (-b - sqrt(discriminant)) / (2 * a)
            if temp < tMax && temp > tMin {
                rec.t = temp
                rec.p = r.pointAt(t: temp)
                rec.normal = (rec.p - center) / radius
                rec.material = material
                
                return true
            }
            
            temp = (-b + sqrt(discriminant)) / (2 * a)
            if temp < tMax && temp > tMin {
                rec.t = temp
                rec.p = r.pointAt(t: temp)
                rec.normal = (rec.p - center) / radius
                rec.material = material
                
                return true
            }
        }
        
        return false
    }
    
    var center: Vec3
    var radius: Double
    var material: Material?
}

struct HitableList: Hitable {
    func hit(r: Ray, tMin: Double, tMax: Double, rec: inout HitRecord) -> Bool {
        var tempRec = HitRecord()
        var hitAnything = false
        var closestSoFar = tMax
        
        for hitable in list {
            if hitable.hit(r: r, tMin: tMin, tMax: closestSoFar, rec: &tempRec) {
                hitAnything = true
                closestSoFar = tempRec.t
                rec = tempRec
            }
        }
        return hitAnything
    }
    
    var list: [Hitable] = []
}
