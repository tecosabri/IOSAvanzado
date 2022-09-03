//
//  TransformationModel.swift
//  DragonBall
//
//  Created by Ismael Sabri Pérez on 14/7/22.
//

import Foundation

struct Transformation: Decodable {
    let description: String
    let photo: URL
    let name: String
    let id: String
}
