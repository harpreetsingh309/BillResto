//
//  InvoiceModel.swift
//  BillResto
//
//  Created by Harpreet on 02/05/21.
//

import Foundation
struct BillingDetailModel : Codable {
    let message : String?
    let success : Int?
    let list : [List]?

    enum CodingKeys: String, CodingKey {
        case message = "message"
        case success = "success"
        case list = "list"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        success = try values.decodeIfPresent(Int.self, forKey: .success)
        list = try values.decodeIfPresent([List].self, forKey: .list)
    }
}
