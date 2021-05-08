//
//  Order.swift
//  BillResto
//
//  Created by Harpreet on 02/05/21.
//

import Foundation

struct Order : Codable {
    let name : String?
    let price : Int?
    let count : Int?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case price = "price"
        case count = "count"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        price = try values.decodeIfPresent(Int.self, forKey: .price)
        count = try values.decodeIfPresent(Int.self, forKey: .count)
    }
}
