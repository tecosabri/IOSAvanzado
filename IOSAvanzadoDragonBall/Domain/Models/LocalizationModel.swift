//
//  LocalizationModel.swift
//  IOSAvanzadoDragonBall
//
//  Created by Ismael Sabri Pérez on 11/9/22.
//

import Foundation

struct Location: Decodable {
    let dateShow: String
    let id: String // Localization id, not hero id
    let hero: Id
    let longitud: String
    let latitud: String
}

struct Id: Decodable {
    let id: String
}
