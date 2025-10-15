//
//  Proposal.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 08/10/25.
//

import Foundation


struct Proposal: Codable, Identifiable {
    var id: Int { proposal_id }
    
    let proposal_id: Int
    let AssitanceNo: String?
    let invoiceno: String?
    let Certificate_no: String
    let Planname: String
    let Nameofthepassenger: String
    let PassportNo: String
    let Policy_Generation_Date: String
    let PolicyStartDate: String
    let PolicyEndDate: String
    let Assiatance_charges_PreTaxAmount: String
    let Assiatance_charges_PostTaxAmount: Double
    let AgentId: Int
    let UserID_Mobileno: String
    let AgentName: String
    let Selected_Payment_Mode: String
    let PaymentType: String
    let Discount: String
    let Fullpay_Discount_amount_to_be_paid: String
    let Paymentreceived: String
    let UId: String
    let Payment_Status: PaymentStatus
    
    
    // Computed property for SwiftUI-friendly display
        var passengerName: String { Nameofthepassenger }
        var passportNo: String { PassportNo }
        var certificateNo: String { Certificate_no }
        var planName: String { Planname }
        var agentName: String { AgentName }
        var assistanceNo: String { AssitanceNo ?? "N/A" }
     
        var assistanceChargesPostTaxAmountString: String {
            String(format: "₹%.2f", Assiatance_charges_PostTaxAmount)
        }
    
    
}
enum PaymentStatus: String, Codable {
    case approved = "Approved"
    case inProcess = "InProcess"
    case pending = "Pending"
    case done = "Done"
    case unknown

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try? container.decode(String.self)
        self = PaymentStatus(rawValue: rawValue ?? "") ?? .unknown
    }
}

extension PaymentStatus {
    var displayName: String {
        switch self {
        case .approved: return "Approved"
        case .inProcess: return "In Process"
        case .pending: return "Pending"
        case .done: return "Done"
        case .unknown: return "N/A"
        }
    }
}

enum PaymentType: String, Codable {
    case wallet = "Wallet"
}

enum Paymentreceived: String, Codable {
    case paymentNotReceived = "Payment not received"
    case paymentReceived = "Payment received"
}

enum Planname: String, Codable {
    case atlysInclUsaCanadaElitePlan = "ATLYS INCL USA & CANADA ELITE PLAN"
    case travelExcl3LacsPlan3 = "TRAVEL EXCL 3LACS PLAN 3."
    case travelInclUsaCanada120KPlan = "TRAVEL INCL USA & CANADA 120K PLAN"
}

enum SelectedPaymentMode: String, Codable {
    case discount = "Discount"
    case fullPay = "Full Pay"
    case upfront = "Upfront"
}


//Mark : You have multiple filters and/or a search bar, but you only care if any filter is applied.
/*
 Here, isActive lets you condense the UI logic — you don’t have to check every single filter individually.

 You want to conditionally show active filter chips or “Clear All” buttons.

 You want to drive UI state (e.g., showing emptySearchView only if the user actively filtered) rather than checking each filter manually.
 */
struct ProposalSearchCriteria {
    var query: String = ""
    var paymentStatus: String? = nil
    var dateRange: ClosedRange<Date>? = nil // not using
    
    var isActive: Bool {
        !query.isEmpty || (paymentStatus?.isEmpty == false) || dateRange != nil
    }
}
