//
//  TransactionFormatters.swift
//  ScotiaAssignment
//
//  Created by Yogin Kumar Suttroogun on 2026-04-23.
//

import Foundation

enum TransactionFormatters {
    
    static let apiDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static func displayDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_CA")
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter.string(from: date)
    }
    
    static func amountWithCurrency(currencyCode: String, value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
    
    static func amountWithTransactionType(transaction: TransactionModel) -> String {
        let prefix = transaction.transactionType == .credit ? "+" : "-"
        return "\(prefix) \(amountWithCurrency(currencyCode: transaction.amount.currency.rawValue, value: transaction.amount.value))"
    }
    
    static func accountName(account: String, cardNumber: String) -> String {
        let suffix = String(cardNumber.suffix(4))
        guard
            suffix.isEmpty == false
        else { return account }
        return "\(account) \(suffix)"
    }

}
