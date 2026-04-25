//
//  TransactionDetailsViewModelTests.swift
//  ScotiaAssignmentTests
//
//  Created by Yogin Kumar Suttroogun on 2026-04-24.
//

import XCTest
@testable import ScotiaAssignment

@MainActor
final class TransactionDetailsViewModelTests: XCTestCase {
    
    private var sut: TransactionDetailsViewModel!

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    private func makeSUT(
        key: String = "",
        transactionType: TransactionType = .credit,
        merchantName: String? = "Test Store",
        description: String? = "Weekly groceries",
        fromAccount: FromAccount = .momentumRegularVisa,
        fromCardNumber: String? = "1234",
        amount: TransactionAmount = TransactionAmount(value: 100.0, currency: .cad)
    ) -> TransactionDetailsViewModel {
        
        let model = TransactionModel(key: key,
                                     transactionType: transactionType,
                                     merchantName: merchantName ?? "",
                                     description: description,
                                     amount: amount,
                                     postedDate: .now,
                                     fromAccount: fromAccount,
                                     fromCardNumber: fromCardNumber ?? "")
        
        return TransactionDetailsViewModel(model: model)
    }
    
    // MARK: - Navigation
    
    func test_navigationTitle_isTransactionDetails() {
        sut = makeSUT()
        XCTAssertEqual(sut.navigationTitle, "Transaction Details")
    }
    
    // MARK: - Status
    
    func test_statusTitle_forCreditTransaction() {
        sut = makeSUT()
        XCTAssertEqual(sut.statusTitle, TransactionType.credit.detailTitle)
    }
    
    func test_statusTitle_forDebitTransaction() {
        sut = makeSUT(transactionType: .debit)
        XCTAssertEqual(sut.statusTitle, TransactionType.debit.detailTitle)
    }
    
    // MARK: - Amount
    
    func test_amountValue_formatsCorrectly() {
        sut = makeSUT(amount: TransactionAmount(value: 200.20, currency: .cad))
        let expected = TransactionFormatters.amountWithCurrency(
            currencyCode: Currency.cad.rawValue,
            value: 200.20
        )
        XCTAssertEqual(sut.amountValue, expected)
    }
    
    func test_amountValue_withZeroAmount() {
        sut = makeSUT(amount: TransactionAmount(value: 0, currency: .cad))
        let expected = TransactionFormatters.amountWithCurrency(
            currencyCode: Currency.cad.rawValue,
            value: 0
        )
        XCTAssertEqual(sut.amountValue, expected)
    }
}
