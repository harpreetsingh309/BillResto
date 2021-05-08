//
//  GroupListVC.swift
//  BillResto
//
//  Created by Harpreet on 02/05/21.
//

import UIKit

class GroupListVC: BaseViewController {

    @IBOutlet weak var groupListTableView: UITableView!
    var listViewModel = BillDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? BillDetailsVC {
            destination.billingDetailsViewModel = listViewModel
        }
    }
}

//MARK:- UITableViewDataSource
extension GroupListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listViewModel.numberOFBills
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BillingTableCell.cellID) as? BillingTableCell else { return UITableViewCell() }
        cell.billingTxtLbl?.text = listViewModel.groupName(indexPath.row)
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        return cell
    }
}

//MARK:-
extension GroupListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        listViewModel.selectedTable = indexPath.row
        self.performSegue(withIdentifier: SegueName.billDetialSegueName, sender: self)
    }
}
