//
//  Vec3.swift
//  RayTracingInOneWeekendWithSwift
//
//  Created by eanjee on 2018/6/10.
//  Copyright © 2018 eanjee. All rights reserved.
//

import Darwin

struct Vec3 {
    init(_ x: Double, _ y: Double, _ z: Double) {
        self.e0 = x
        self.e1 = y
        self.e2 = z
    }
    
    var x: Double {
        return e0
    }
    
    var y: Double {
        return e1
    }
    
    var z: Double {
        return e2
    }
    
    var r: Double {
        return e0
    }
    
    var g: Double {
        return e1
    }
    
    var b: Double {
        return e2
    }
    
    // unary
    static prefix func - (vec: Vec3) -> Vec3 {
        return Vec3(-vec.x, -vec.y, -vec.z)
    }
    
    // vector arithmetic
    static func + (left: Vec3, right: Vec3) -> Vec3 {
        return Vec3(left.x + right.x, left.y + right.y, left.z + right.z)
    }
    
    static func - (left: Vec3, right: Vec3) -> Vec3 {
        return Vec3(left.x - right.x, left.y - right.y, left.z - right.z)
    }
    
    static func * (left: Vec3, right: Vec3) -> Vec3 {
        return Vec3(left.x * right.x, left.y * right.y, left.z * right.z)
    }
    
    static func / (left: Vec3, right: Vec3) -> Vec3 {
        return Vec3(left.x / right.x, left.y / right.y, left.z / right.z)
    }
    
    // scalar arithmetic
    static func + (left: Vec3, right: Double) -> Vec3 {
        return Vec3(left.x + right, left.y + right, left.z + right)
    }
    
    static func + (left: Double, right: Vec3) -> Vec3 {
        return Vec3(left + right.x, left + right.y, left + right.z)
    }
    
    static func - (left: Vec3, right: Double) -> Vec3 {
        return Vec3(left.x - right, left.y - right, left.z - right)
    }
    
    static func - (left: Double, right: Vec3) -> Vec3 {
        return Vec3(left - right.x, left - right.y, left - right.z)
    }
    
    static func * (left: Vec3, right: Double) -> Vec3 {
        return Vec3(left.x * right, left.y * right, left.z * right)
    }
    
    static func * (left: Double, right: Vec3) -> Vec3 {
        return Vec3(left * right.x, left * right.y, left * right.z)
    }
    
    static func / (left: Vec3, right: Double) -> Vec3 {
        return Vec3(left.x / right, left.y / right, left.z / right)
    }
    
    // compound
    static func += (left: inout Vec3, right: Vec3) {
        left = left + right
    }
    
    static func -= (left: inout Vec3, right: Vec3) {
        left = left - right
    }
    
    static func *= (left: inout Vec3, right: Vec3) {
        left = left * right
    }
    
    static func /= (left: inout Vec3, right: Vec3) {
        left = left / right
    }
    
    static func *= (left: inout Vec3, right: Double) {
        left = left * right
    }
    
    static func /= (left: inout Vec3, right: Double) {
        left = left / right
    }
    
    // geometry
    static func dot(_ left: Vec3, _ right: Vec3) -> Double {
        return  left.x * right.x + left.y * right.y + left.z * right.z
    }
    
    static func cross(_ left: Vec3, _ right: Vec3) -> Vec3 {
        return Vec3(left.y * right.z - left.z * right.y,
                    left.z * right.x - left.x * right.z,
                    left.x * right.y - left.y * right.x)
    }
    
    func lengthSquared() -> Double {
        return x * x + y * y + z * z
    }
    
    func length() -> Double {
        return sqrt(lengthSquared())
    }
    
    mutating func normalize() {
        let k = 1.0 / length()
        e0 *= k
        e1 *= k
        e2 *= k
    }
    
    func normalized() -> Vec3 {
        return self / length()
    }
    
    var e0, e1, e2: Double
}
