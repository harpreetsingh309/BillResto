//
//  BillSplitVC.swift
//  BillResto
//
//  Created by Harpreet on 03/05/21.
//

import UIKit

class BillSplitVC: BaseViewController {

   weak var billDetailViewModel: BillDetailsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

//MARK:- UITableViewDataSource
extension BillSplitVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        billDetailViewModel?.numberOfPersons ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        billDetailViewModel?.itemsCountForPerson ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BillingTableCell.cellID) as? BillingTableCell else { return UITableViewCell() }
        billDetailViewModel?.configureSplitBillCell(cell, indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: BillHeaderView.headerID)
        header?.backgroundColor = .red
        header?.textLabel?.text = "Person \(section)"
        return header
    }
}

//MARK:- UITableViewDelegate
extension BillSplitVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        billDetailViewModel?.didSelect(indexPath, self)
    }
}

//MARK:-
extension BillSplitVC: TaxesViewControllerDelegate {
    func taxChannged(_ taxType: TaxType, _ controller: BaseViewController) {
        billDetailViewModel?.selectedTaxType = taxType
        billingTableView.reloadData()
    }
}
