//
//  FoundationTest.swift
//  TransactionsTestTaskTests
//
//  Created by Pavlo Bahan on 19.02.2025.
//

import XCTest

final class FoundationTest: XCTestCase {

    // MARK: - Double+Extensions
    
    func testToBalance() {
        let valueWithTwoDigitsAfterDot: Double = 100.58
        let valueWithTrhreeDigitsAfterDot: Double = 100.583
        let valueWithNoDigitsAfterDot: Double = 100
        
        XCTAssertEqual(valueWithTwoDigitsAfterDot.toBalance(), "100,58")
        XCTAssertEqual(valueWithTrhreeDigitsAfterDot.toBalance(), "100,58")
        XCTAssertNotEqual(valueWithNoDigitsAfterDot.toBalance(), "100,01")
    }
    
    // MARK: - Number+Extensions
    
    func testFormattedWithSeparator() {
        let valueWithTrhreeDigitsAfterDot: Double = 100.583
        
        XCTAssertEqual(valueWithTrhreeDigitsAfterDot.formattedWithSeparator, "100.58")
    }
    
    // MARK: - String+Extensions
    
    func testToRoundedDouble() {
        let valueWithTrhreeDigitsAfterDot: Double = 100.583
        
        XCTAssertEqual(valueWithTrhreeDigitsAfterDot.formattedWithSeparator, "100.58")
    }
    
    // MARK: - Date+Extensions
    
    func testHeaderTitle() {
        let stringDate = "2025-02-19T10:54:54+0000"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let date = dateFormatter.date(from: stringDate)
        
        XCTAssertEqual(date?.headerTitle(), "19 February 2025", "The format should be as: 'd MMMM yyyy'")
        XCTAssertNotEqual(date?.headerTitle(), "18 February 2025", "Equal 19 February, not 18 February")
    }
    
    func testTransctionTime() {
        let calendar = Calendar.current
        
        let testCases: [(date: Date, expected: String)] = [
            (calendar.date(from: DateComponents(year: 2025, month: 2, day: 19, hour: 14, minute: 30))!, "14:30"),
            (calendar.date(from: DateComponents(year: 2025, month: 2, day: 19, hour: 0, minute: 0))!, "00:00"),
            (calendar.date(from: DateComponents(year: 2025, month: 2, day: 19, hour: 23, minute: 59))!, "23:59"),
            (calendar.date(from: DateComponents(year: 2025, month: 2, day: 19, hour: 9, minute: 5))!, "09:05"),
            (calendar.date(from: DateComponents(year: 2025, month: 2, day: 19, hour: 12, minute: 0))!, "12:00")
        ]
        
        for (date, expected) in testCases {
            XCTAssertEqual(date.transactionTime(), expected, "Incorrect for \(date)")
        }
    }
    
    func testDayMonthYear() {
        let stringDate = "2025-02-19T10:54:54+0000"
        let expectedStringDate = "19 February 2025"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: stringDate)
        
        dateFormatter.dateFormat = "d MMMM yyyy"
        let expectedDate = dateFormatter.date(from: expectedStringDate)
        
        XCTAssertEqual(date?.dayMonthYear(), expectedDate)
    }
}
