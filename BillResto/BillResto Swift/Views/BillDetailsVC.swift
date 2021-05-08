//
//  BillDetailsVC.swift
//  BillResto
//
//  Created by Harpreet on 02/05/21.
//

import UIKit

class BillDetailsVC: BaseViewController {
    
    // outlets
    weak var billingDetailsViewModel: BillDetailsViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        billingTableView.register(BillHeaderView.self, forHeaderFooterViewReuseIdentifier: BillHeaderView.headerID)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? TaxesViewController {
            destination.delegate = self
        } else if let destination = segue.destination as? BillSplitVC {
            destination.billDetailViewModel = billingDetailsViewModel
        }
    }
}

//MARK:- UITableViewDataSource
extension BillDetailsVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        billingDetailsViewModel?.numberOFSectionsForDetails ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        billingDetailsViewModel?.numberOFItem(section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BillingTableCell.cellID) as? BillingTableCell else { return UITableViewCell() }
        billingDetailsViewModel?.configureCell(cell, indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: BillHeaderView.headerID)
        header?.textLabel?.text = billingDetailsViewModel?.headerTitle(section)
        return header
    }
}

//MARK:- UITableViewDelegate
extension BillDetailsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        billingDetailsViewModel?.didSelect(indexPath, self)
    }
}

//MARK:-
extension BillDetailsVC: TaxesViewControllerDelegate {
    func taxChannged(_ taxType: TaxType, _ controller: BaseViewController) {
        billingDetailsViewModel?.selectedTaxType = taxType
        billingTableView.reloadData()
    }
}
