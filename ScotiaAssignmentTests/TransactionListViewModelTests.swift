//
//  TransactionListViewModelTests.swift
//  ScotiaAssignment
//
//  Created by Yogin Kumar Suttroogun on 2026-04-25.
//

import XCTest
import Combine
@testable import ScotiaAssignment

// MARK: - Helpers

private func makeTransaction(
    key: String = "tx-1",
    type: TransactionType = .debit,
    merchantName: String = "Tim Hortons",
    description: String? = nil,
    amount: Double = 5.00,
    postedDate: Date = Date(),
    fromAccount: FromAccount = .momentumRegularVisa,
    fromCardNumber: String = "4512"
) -> TransactionModel {
    TransactionModel(
        key: key,
        transactionType: type,
        merchantName: merchantName,
        description: description,
        amount: TransactionAmount(value: amount, currency: .cad),
        postedDate: postedDate,
        fromAccount: fromAccount,
        fromCardNumber: fromCardNumber
    )
}

// MARK: - Tests
@MainActor
final class TransactionListViewModelTests: XCTestCase {

    private var sut: TransactionListViewModel!
    private var mockService: MockTransactionListService!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockService = MockTransactionListService()
        sut = TransactionListViewModel(transactionListService: mockService)
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        sut = nil
        mockService = nil
        super.tearDown()
    }

    // MARK: Initial State

    func test_initialState_responseIsEmpty() {
        XCTAssertTrue(sut.response.transactions.isEmpty)
    }

    func test_initialState_isLoadingIsFalse() {
        XCTAssertFalse(sut.isLoading)
    }

    func test_navigationTitle_isTransactions() {
        XCTAssertEqual(sut.navigationTitle, "Transactions")
    }

    // MARK: fetchTransactions — Success

    func test_fetchTransactions_success_populatesResponse() {
        let transactions = [
            makeTransaction(key: "tx-1"),
            makeTransaction(key: "tx-2")
        ]
        mockService.result = 
            .success(TransactionResponse(transactions: transactions))

        let expectation = expectation(description: "response updated")
        sut.$response
            .dropFirst()
            .sink { response in
                XCTAssertEqual(response.transactions.count, 2)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.fetchTransactions()
        waitForExpectations(timeout: 1)
    }

    func test_fetchTransactions_success_clearsErrorMessage() {
        mockService.result = 
            .failure(NetworkError.fileNotFound(name: "transaction-list"))
        sut.fetchTransactions()

        mockService.result = 
            .success(TransactionResponse(transactions: [makeTransaction()]))

        let expectation = expectation(description: "error cleared")
        sut.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                XCTAssertNil(errorMessage)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.fetchTransactions()
        waitForExpectations(timeout: 1)
    }

    func test_fetchTransactions_callsServiceOnce() {
        sut.fetchTransactions()
        XCTAssertEqual(mockService.fetchCallCount, 1)
    }

    func test_fetchTransactions_calledMultipleTimes_callsServiceEachTime() {
        sut.fetchTransactions()
        sut.fetchTransactions()
        XCTAssertEqual(mockService.fetchCallCount, 2)
    }

    // MARK: fetchTransactions — Failure

    func test_fetchTransactions_fileNotFoundError_errorMessageContainsFileName() {
        mockService.result = 
            .failure(NetworkError.fileNotFound(name: "transaction-list"))

        let expectation = expectation(
            description: "error message contains file name"
        )
        sut.$errorMessage
            .compactMap { $0 }
            .sink { message in
                XCTAssertTrue(message.contains("transaction-list"))
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.fetchTransactions()
        waitForExpectations(timeout: 1)
    }

    func test_fetchTransactions_failure_isLoadingReturnsFalse() {
        mockService.result = 
            .failure(NetworkError.fileNotFound(name: "transaction-list"))

        let expectation = expectation(
            description: "isLoading false after failure"
        )
        sut.$isLoading
            .dropFirst(2) // skip initial false + true during loading
            .sink { isLoading in
                XCTAssertFalse(isLoading)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.fetchTransactions()
        waitForExpectations(timeout: 1)
    }

    func test_fetchTransactions_failure_doesNotPopulateResponse() {
        mockService.result = 
            .failure(NetworkError.fileNotFound(name: "transaction-list"))

        sut.fetchTransactions()

        XCTAssertTrue(sut.response.transactions.isEmpty)
    }

    func test_fetchTransactions_decodingError_setsErrorMessage() {
        struct FakeError: Error {}
        mockService.result = 
            .failure(NetworkError.decodingFailed(error: FakeError()))

        let expectation = expectation(description: "decoding error message set")
        sut.$errorMessage
            .compactMap { $0 }
            .sink { message in
                XCTAssertTrue(message.contains("decode"))
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.fetchTransactions()
        waitForExpectations(timeout: 1)
    }
}
