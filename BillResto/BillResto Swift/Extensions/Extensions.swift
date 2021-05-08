//
//  Extensions.swift
//  BillResto
//
//  Created by Harpreet on 02/05/21.
//

import UIKit

//MARK:-  Date
extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        return dateFormatter.string(from: self)
    }
}

//MARK:- STRING
extension String {

  func cgfloat() -> CGFloat? {
    guard let doubleValue = Double(self) else {
      return nil
    }
    return CGFloat(doubleValue)
  }
}
