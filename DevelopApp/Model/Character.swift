//
//  File.swift
//  DevelopApp
//
//  Created by Oleksiy Chebotarov on 16/03/2021.
//

import Foundation

struct Character: Decodable {
    let charId: Int
    let name: String
    let birthday: String
    let occupation: [String]
    let img: String
    let status: Status
    let nickname: String
    let appearance: [Int]
    let portrayed: String
    let category: Category
    let betterCallSaulAppearance: [Int]
}

enum Category: String, Decodable {
    case betterCallSaul = "Better Call Saul"
    case breakingBad = "Breaking Bad"
    case breakingBadBetterCallSaul = "Breaking Bad, Better Call Saul"
}

enum Status: String, Decodable {
    case alive = "Alive"
    case deceased = "Deceased"
    case presumedDead = "Presumed dead"
    case unknown = "Unknown"
}
