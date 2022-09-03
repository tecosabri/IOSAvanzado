//
//  HeroModel.swift
//  DragonBall
//
//  Created by Ismael Sabri Pérez on 10/7/22.
//

import Foundation


struct Hero: Decodable {
    let id: String
    let name: String
    let description: String
    let photo: URL
    let favorite: Bool
}


