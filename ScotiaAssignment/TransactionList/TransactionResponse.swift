//
//  TransactionResponse.swift
//  ScotiaAssignment
//
//  Created by Yogin Kumar Suttroogun on 2026-04-22.
//

import Foundation

struct TransactionResponse: Codable {
    let transactions: [TransactionModel]
}

struct TransactionModel: Codable {
    let key: String
    let transactionType: TransactionType
    let merchantName: String
    let description: String?
    let amount: TransactionAmount
    let postedDate: Date
    let fromAccount: FromAccount
    let fromCardNumber: String
}

struct TransactionAmount: Codable {
    let value: Double
    let currency: Currency
}

enum Currency: String, Codable {
    case cad = "CAD"
}

enum FromAccount: String, Codable {
    case momentumRegularVisa = "Momentum Regular Visa"
    case passportVisaInfinite = "Passport Visa Infinite"
}

enum TransactionType: String, Codable {
    case credit = "CREDIT"
    case debit = "DEBIT"
    
    var detailTitle: String {
        switch self {
        case .credit:
            return "Credit transaction"
        case .debit:
            return "Debit transaction"
        }
    }
}
