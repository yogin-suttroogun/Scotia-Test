//
//  TransactionDetailsViewModel.swift
//  ScotiaAssignment
//
//  Created by Yogin Kumar Suttroogun on 2026-04-23.
//

import Foundation
import Combine

@MainActor
final class TransactionDetailsViewModel {
    // MARK: - Variables
    internal let model: TransactionModel
    internal let tooltipContent: TooltipModel
    
    // MARK: - UI Element
    let navigationTitle: String = "Transaction Details"
    
    var statusTitle: String {
        model.transactionType.detailTitle
    }
    var fromTitle: String {
        "From"
    }
    
    var fromValue: String {
        TransactionFormatters.accountName(account: model.fromAccount.rawValue,
                                          cardNumber: model.fromCardNumber)
    }
    
    var amountTitle: String {
        "Amount"
    }
    
    var amountValue: String {
        TransactionFormatters.amountWithCurrency(currencyCode: model.amount.currency.rawValue,
                                                 value: model.amount.value)
    }
    
    var closeButtonTitle: String {
        "Close"
    }
    
    init(model: TransactionModel) {
        self.model = model
        self.tooltipContent = TooltipModel(collapsedMessage: "Transactions are processed Monday to Friday (excluding holidays).",
                                           expandedMessage: "Transactions made before 8:30 pm ET Monday to Friday (excluding holidays) will show up in your account the same day.")
    }
}
