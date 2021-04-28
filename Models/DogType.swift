//
//  DogType.swift
//  CatchDogGame
//
//  Created by 粘辰晧 on 2021/4/17.
//

import Foundation

struct DogType: Equatable{
    let name: String
    let score: Int
    let appearTime: Double
}

struct Dog: Equatable{
    static let shibainu = DogType(name: "shibainu", score: 1, appearTime: Double.random(in: 2...4))
    static let chihuahua = DogType(name: "chihuahua", score: 3, appearTime: Double.random(in: 1.5...2.5))
    
}
