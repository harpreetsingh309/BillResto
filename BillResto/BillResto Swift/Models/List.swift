//
//  List.swift
//  BillResto
//
//  Created by Harpreet on 02/05/21.
//

import Foundation
struct List : Codable {
    let groupName : String?
    let noOfPerson : String?
    let clientName: String?
    let order : [Order]?
    let initialPay : Int?
    let discount : String?
    let paymentType : String?
    let split : String?

    enum CodingKeys: String, CodingKey {
        case groupName = "groupName"
        case noOfPerson = "noOfPerson"
        case order = "order"
        case initialPay = "initialPay"
        case discount = "discount"
        case paymentType = "paymentType"
        case split = "split"
        case clientName = "clientName"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        groupName = try values.decodeIfPresent(String.self, forKey: .groupName)
        noOfPerson = try values.decodeIfPresent(String.self, forKey: .noOfPerson)
        clientName = try values.decodeIfPresent(String.self, forKey: .clientName)
        order = try values.decodeIfPresent([Order].self, forKey: .order)
        initialPay = try values.decodeIfPresent(Int.self, forKey: .initialPay)
        discount = try values.decodeIfPresent(String.self, forKey: .discount)
        paymentType = try values.decodeIfPresent(String.self, forKey: .paymentType)
        split = try values.decodeIfPresent(String.self, forKey: .split)
    }
}
