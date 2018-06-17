//
//  Material.swift
//  RayTracingInOneWeekendWithSwift
//
//  Created by eanjee on 2018/6/17.
//  Copyright © 2018 eanjee. All rights reserved.
//

import Darwin

protocol Material {
    func scatter(r: Ray, rec: HitRecord, attenuation: inout Vec3,
                 scattered: inout Ray) -> Bool
}

struct Lambertian: Material {
    func scatter(r: Ray, rec: HitRecord, attenuation: inout Vec3,
                 scattered: inout Ray) -> Bool {
        let target = rec.p + rec.normal + Vec3.randomInUnitSphere()
        scattered = Ray(a: rec.p, b: target - rec.p)
        attenuation = albedo
        
        return true
    }
    
    var albedo: Vec3
}

struct Metal: Material {
    init(albedo: Vec3, fuzz: Double) {
        self.albedo = albedo
        self.fuzz = min(max(0.0, fuzz), 1.0)
    }
    func reflect(v: Vec3, n: Vec3) -> Vec3 {
        return v - 2 * Vec3.dot(v, n) * n
    }
    
    func scatter(r: Ray, rec: HitRecord, attenuation: inout Vec3,
                 scattered: inout Ray) -> Bool {
        let reflected = reflect(v: r.direction.normalized(), n: rec.normal)
        
        scattered = Ray(a: rec.p, b: reflected + fuzz * Vec3.randomInUnitSphere())
        attenuation = albedo
        
        return Vec3.dot(scattered.direction, rec.normal) > 0
    }
    
    var albedo: Vec3
    var fuzz: Double
}
