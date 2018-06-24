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
    
    func scatter(r: Ray, rec: HitRecord, attenuation: inout Vec3,
                 scattered: inout Ray) -> Bool {
        let reflected = Vec3.reflect(v: r.direction.normalized(), n: rec.normal)
        scattered = Ray(a: rec.p, b: reflected + fuzz * Vec3.randomInUnitSphere())
        attenuation = albedo
        
        return Vec3.dot(scattered.direction, rec.normal) > 0
    }
    
    var albedo: Vec3
    var fuzz: Double
}

struct Dielectric: Material {
    func refract(v: Vec3, n: Vec3, niOverNt: Double, refracted: inout Vec3) -> Bool {
        let uv = v.normalized()
        let dt = Vec3.dot(uv, n)
        let discriminant = 1.0 - niOverNt * niOverNt * (1.0 - dt * dt)
        if discriminant > 0 {
            refracted = niOverNt * (uv - n * dt) - n * sqrt(discriminant)
            return true
        } else {
            // no real solution to Snell’s law and thus there is no refraction possible
            return false
        }
    }
    
    func schlick(cosine: Double, refractionIndex: Double) -> Double {
        var r0 = (1.0 - refractionIndex) / (1.0 + refractionIndex)
        r0 = r0 * r0
        return r0 + (1.0 - r0) * pow((1.0 - cosine), 5.0)
    }
    
    func scatter(r: Ray, rec: HitRecord, attenuation: inout Vec3,
                 scattered: inout Ray) -> Bool {
        var outwardNormal: Vec3
        let reflected = Vec3.reflect(v: r.direction, n: rec.normal)
        var niOverNt: Double
        
        attenuation = Vec3(1.0, 1.0, 0.0)
        var refracted = Vec3(0.0, 0.0, 0.0)
        var reflectProb: Double
        var cosine: Double
        
        if Vec3.dot(r.direction, rec.normal) > 0 {
            outwardNormal = -rec.normal
            niOverNt = refractionIndex
            cosine = refractionIndex * Vec3.dot(r.direction, rec.normal) /
                r.direction.length()
        } else {
            outwardNormal = rec.normal
            niOverNt = 1.0 / refractionIndex
            cosine = -Vec3.dot(r.direction, rec.normal) / r.direction.length()
        }
        
        if refract(v: r.direction, n: outwardNormal, niOverNt: niOverNt,
                   refracted: &refracted) {
            reflectProb = schlick(cosine: cosine, refractionIndex: refractionIndex)
        } else {
            // total interal reflection
            reflectProb = 1.0
        }
        
        if drand48() < reflectProb {
            scattered = Ray(a: rec.p, b: reflected)
        } else {
            scattered = Ray(a: rec.p, b: refracted)
        }
        
        return true
    }
    
    var refractionIndex: Double
}
