//
//  TaxesViewController.swift
//  BillResto
//
//  Created by Harpreet on 02/05/21.
//

import UIKit


protocol TaxesViewControllerDelegate: class {
    func taxChannged(_ taxType: TaxType, _ controller: BaseViewController)
}

class TaxesViewController: BaseViewController {
    weak var delegate: TaxesViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

//MARK:- UITableViewDataSource
extension TaxesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BillingTableCell.cellID) as? BillingTableCell else { return UITableViewCell() }
        guard let taxType = TaxType(rawValue: indexPath.row) else { return UITableViewCell()}
        cell.billingTxtLbl?.text = taxType.name
        return cell
    }
}

//MARK:-
extension TaxesViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let taxType = TaxType(rawValue: indexPath.row) else { return }
        delegate?.taxChannged(taxType, self)
        self.navigationController?.popViewController(animated: true)
    }
}
