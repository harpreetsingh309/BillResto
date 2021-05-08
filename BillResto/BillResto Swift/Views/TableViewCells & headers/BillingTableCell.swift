//
//  BillingTableCell.swift
//  BillResto
//
//  Created by Harpreet on 02/05/21.
//

import UIKit

class BillingTableCell: UITableViewCell {

    static let cellID = "LIST_CELL"
    @IBOutlet weak var billingTxtLbl: UILabel!
    @IBOutlet weak var bilingDetailLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
