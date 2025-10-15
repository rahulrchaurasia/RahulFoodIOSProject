//
//  MockCarRepository.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 10/10/25.
//

import Foundation

struct MockCarRepository : CarRepositoryProtocol {
    
    func fetchBanners() async throws -> [Banner] {
        try await Task.sleep(nanoseconds: 300_000_000) // 0.3 sec delay
            return [
                Banner(id: "1", title: "Car Insurance", imageUrl: "https://example.com/banner1.jpg"),
                Banner(id: "2", title: "Roadside Assistance", imageUrl: "https://example.com/banner2.jpg")
            ]
        }
    
    
    func fetchCarProposal() async throws -> [Proposal] {
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 sec delay
            return [
                Proposal(
                    proposal_id: 59,
                    AssitanceNo: "AS00000046",
                    invoiceno: "41436/INV/2025-26",
                    Certificate_no: "110392528221003309",
                    Planname: "TRAVEL INCL USA & CANADA 120K PLAN",
                    Nameofthepassenger: "Gunja Umesh Chaurasia",
                    PassportNo: "A3091467",
                    Policy_Generation_Date: "2025-07-04T17:00:00.000Z",
                    PolicyStartDate: "2025-07-05T00:00:00.000Z",
                    PolicyEndDate: "2025-07-20T00:00:00.000Z",
                    Assiatance_charges_PreTaxAmount: "1657",
                    Assiatance_charges_PostTaxAmount: 1404.24,
                    AgentId: 63,
                    UserID_Mobileno: "9233451234",
                    AgentName: "TestCHAURASIA",
                    Selected_Payment_Mode: "Upfront",
                    PaymentType: "Wallet",
                    Discount: "50",
                    Fullpay_Discount_amount_to_be_paid: "955",
                    Paymentreceived: "Payment not received",
                    UId: "119590",
                    Payment_Status: .pending
                ),
                Proposal(
                    proposal_id: 58,
                    AssitanceNo: "AS00000045",
                    invoiceno: "61366/INV/2025-26",
                    Certificate_no: "140492528221000031",
                    Planname: "TRAVEL EXCL 3LACS PLAN 3.",
                    Nameofthepassenger: "Test Umesh Singh",
                    PassportNo: "A2096448",
                    Policy_Generation_Date: "2025-05-31T06:57:04.000Z",
                    PolicyStartDate: "2025-06-03T00:00:00.000Z",
                    PolicyEndDate: "2025-06-15T00:00:00.000Z",
                    Assiatance_charges_PreTaxAmount: "1175",
                    Assiatance_charges_PostTaxAmount: 995.76,
                    AgentId: 30,
                    UserID_Mobileno: "9224624888",
                    AgentName: "RudraAgent Chaurasia",
                    Selected_Payment_Mode: "Full Pay",
                    PaymentType: "Wallet",
                    Discount: "50",
                    Fullpay_Discount_amount_to_be_paid: "1175",
                    Paymentreceived: "Payment not received",
                    UId: "119590",
                    Payment_Status: .unknown
                )
            ]
        }
    
}
