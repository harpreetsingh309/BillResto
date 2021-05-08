//
//  BaseViewController.swift
//  BillResto
//
//  Created by Harpreet on 02/05/21.
//

import UIKit

class BaseViewController: UIViewController {

    @IBOutlet weak var billingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerRenderCells()
    }

    private func registerRenderCells() {
        let nib = UINib(nibName: "BillingTableCell", bundle: Bundle.main)
        billingTableView.register(nib, forCellReuseIdentifier: BillingTableCell.cellID)
    }
    
}
