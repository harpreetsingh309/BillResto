//
//  GroupListViewModel.swift
//  BillResto
//
//  Created by Harpreet on 02/05/21.
//

import UIKit

enum BillDetailSectionType : Int{
    case client = 0 // = "Client"
    case dated
    case orderItems
    case expences
    case taxes
    case grandTotal
    case paymentType
    case splitBill
    static let count = 8
    
    var name: String {
        switch self {
        case .client: return "Client"
        case .dated: return "Dated"
        case .orderItems: return "Items"
        case .expences: return "Expenses"
        case .taxes: return "Taxes"
        case .paymentType: return "Payment Type"
        case .grandTotal: return "Total"
        case .splitBill: return "Split"
        }
    }
}

enum TaxType : Int {
    case vat = 0
    case sales
    case subSale
    case none
    
    var taxValue: Int {
        switch self {
        case .vat:
            return 14
        case .sales:
            return 10
        case .subSale:
            return 5
        case .none:
            return 0
        }
    }
    
    var name: String {
        switch self {
        case .vat:
            return "VAT @ 14%"
        case .sales:
            return "Sales 10%"
        case .subSale:
            return "Sub Sales 5%"
        case .none:
            return ""
        }
    }
}

enum BillSplitType : Int {
    case amountToPaid = 0
    case paidByPerson
    case remainingAmount
    static let count = 3
    
    var value: String {
        switch self {
        case .amountToPaid:
            return "Amount to pay"
        case .paidByPerson:
            return "Paid by person"
        case .remainingAmount:
            return "Remaining amount"
        }
    }
}


typealias SelectedTable = Int

class BillDetailsViewModel: NSObject {
    
    /// all billing detials holding model
    /// having `grouplist` in it
    /// this will help to get all the information about groups and billing
    private(set) var billingDetails: BillingDetailModel?
    
    /// count of `bills` we have
    var numberOFBills: Int {
        billingDetails?.list?.count ?? 0
    }
    
    /// number of section for details table
    var numberOFSectionsForDetails: Int {
        BillDetailSectionType.count
    }
    
    /// selected table type
    var selectedTable: SelectedTable = -1
    
    /// group list here
    /// this will be retrieve from `billing` details data
    private var invoices: [List]? {
        billingDetails?.list
    }
    
    /// here we have `resource` path for `resto` json file
    private var jsonPath: String? {
        Bundle.main.path(forResource: Constant.groupListJsonName, ofType: "json")
    }
    
    /// retrieve all the `orders` for perticular group
    private func orders(_ index: Int) -> [Order]? {
        billingDetails?.list?[index].order
    }
    
    var selectedTaxType = TaxType.vat
        
    override init() {
        super.init()
        fetchGroupDetails() // fetch all billing details 
    }
    
    /// billing `name` from bill
    func groupName(_ index: Int) -> String? {
        billingDetails?.list?[index].groupName
    }
    
    /// billing `name` from bill
    func members(_ index: Int) -> String? {
        billingDetails?.list?[index].noOfPerson
    }
    
    /// get `client` name
    func getClientName(_ index: Int) -> String? {
        billingDetails?.list?[index].clientName
    }
    
    func headerTitle(_ section: Int) -> String {
        guard let sectionType = BillDetailSectionType(rawValue: section) else {
            return ""
        }
        return sectionType.name
    }
    
    func numberOFItem(_ section: Int) -> Int {
        guard let sectionType = BillDetailSectionType(rawValue: section) else {
            return 0
        }
        guard  let billing = billingDetails else {
            print("No bills found")
            return 0
        }
        guard let list = billing.list else {
            return 0
        }
        
        switch sectionType {
        case .client,.taxes,.grandTotal,.expences,.dated:
            return 1
        case .orderItems:
            return list[selectedTable].order?.count ?? 0
        case .splitBill:
            return 1
        case .paymentType:
            return 1
        }
    }
    
    func willSplitTheBill() -> Bool {
        // find out billing details available or not
        guard let bill = billingDetails?.list?[selectedTable] else {
            return false
        }
        return bill.split == "true"
    }
    
    func discount(_ index:Int) -> String {
        billingDetails?.list?[index].discount ?? "0"
    }
    
    private func getGrandTotalForBill() -> CGFloat {
        // find out billing details available or not
        guard let bill = billingDetails?.list?[selectedTable] else {
            return 0
        }
        
        // get all the ordered items
        guard let items = bill.order else {
            return 0
        }
        
        // get total amount of all items
        var itemAmount = CGFloat(items.map({$0.price ?? 0}).reduce(0, +))
        print(itemAmount)
        
        // remove discount value from total amount first
        itemAmount = addDiscount(bill.discount ?? "0", itemAmount)
        return addTaxIfAvailable(itemAmount)
    }
    
    private func addTaxIfAvailable(_ amount: CGFloat) -> CGFloat {
        if selectedTaxType != .none {
            return amount + ((CGFloat(selectedTaxType.taxValue)*amount)/100)
        }
        return amount
    }
    
    private func addDiscount(_ discount: String, _ amount: CGFloat) -> CGFloat {
        guard let discountedValue = discount.cgfloat() else { return amount }
        if discountedValue != 0 {
         return amount - ((CGFloat(discountedValue)*amount)/100)
        }
        return amount
    }
    
    private func getPaymentType() -> String? {
        // find out billing details available or not
        guard let bill = billingDetails?.list?[selectedTable] else {
            return "Not paid yet"
        }
        return bill.paymentType?.uppercased()
    }
}

//MARK:- BILL SPLIT helpers
extension BillDetailsViewModel {
    var numberOfPersons: Int {
        return Int(billingDetails?.list?[selectedTable].noOfPerson ?? "") ?? 0
    }
    
    var itemsCountForPerson: Int {
        BillSplitType.count
    }
    
    func configureSplitBillCell(_ cell: BillingTableCell, _ indexPath: IndexPath) {
        guard let sectionType = BillSplitType(rawValue: indexPath.row) else { return }
        cell.billingTxtLbl.text = sectionType.value
        let totalAmount = getGrandTotalForBill()
        let splitAmount = totalAmount/CGFloat(numberOfPersons)
        switch sectionType {
        case .amountToPaid:
            cell.bilingDetailLbl.text = "\(splitAmount)"
        case .paidByPerson:
            cell.bilingDetailLbl.text = willSplitTheBill() ? "\(splitAmount.rounded(.up))" : "N/A"
        case .remainingAmount:
            let remainingAmount = willSplitTheBill() ? "$\(splitAmount.rounded(.up)-splitAmount)" : "N/A"
            cell.bilingDetailLbl.text = remainingAmount
        }
    }
}

//MARK:- CONFIGURE CELL
extension BillDetailsViewModel {
    func configureCell(_ cell: BillingTableCell,_ indexPath: IndexPath) {
        guard let sectionType = BillDetailSectionType(rawValue: indexPath.section) else { return }
        cell.accessoryType = UITableViewCell.AccessoryType.none
        switch sectionType {
        case .client:
            cell.billingTxtLbl?.text = "Name:- \(self.getClientName(selectedTable) ?? "")"
        case .dated:
            cell.billingTxtLbl?.text = "Dated:- \(Date().toString())"
        case .orderItems:
            cell.billingTxtLbl?.text = "Item name:- \(orders(selectedTable)?[indexPath.row].name ?? "")"
            cell.bilingDetailLbl?.text = "$\(orders(selectedTable)?[indexPath.row].price ?? 0)"
        case .expences:
            let discount = self.discount(selectedTable)
            cell.billingTxtLbl?.text = "Discount"
            cell.bilingDetailLbl?.text = discount == "0" ? "No expenses" : "\(discount)%"
        case .taxes:
            cell.billingTxtLbl?.text = selectedTaxType.name
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        case .grandTotal:
            cell.billingTxtLbl?.text = "Total"
            cell.bilingDetailLbl?.text = "$\(getGrandTotalForBill())"
        case .splitBill:
            cell.billingTxtLbl.text = "Split bill here"
        case .paymentType:
            cell.billingTxtLbl.text = getPaymentType()
        }
    }
    
    func didSelect(_ indexPath: IndexPath, _ from: BaseViewController) {
        guard let sectionType = BillDetailSectionType(rawValue: indexPath.section) else {
            return
        }
        switch sectionType {
        case .client:
            break
        case .dated:
            break
        case .orderItems:
            break
        case .expences:
            break
        case .taxes:
            from.performSegue(withIdentifier: SegueName.changeTaxes, sender: nil)
        case .grandTotal:
            break
        case .splitBill:
            from.performSegue(withIdentifier: SegueName.splitBill, sender: nil)
        case .paymentType:
            return
        }
    }
}

//MARK:- FETCH BILLING DETAILS
extension BillDetailsViewModel {
    private func fetchGroupDetails() {
        if let path = self.jsonPath {
            guard let data = jsonData(path) else {
                assertionFailure("Data should not be nil")
                return
            }
            do {
                billingDetails = try JSONDecoder().decode(BillingDetailModel.self, from: data)
            } catch {
                print("Unable to load data")
            }
        }
    }
    
    private func jsonData(_ path: String) -> Data? {
        do {
             return try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        } catch {
            assertionFailure("Json not found at this path of resourece")
        }
        return nil
    }
}
