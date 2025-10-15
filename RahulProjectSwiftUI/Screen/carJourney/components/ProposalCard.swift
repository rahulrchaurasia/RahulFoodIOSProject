//
//  ProposalCard.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 10/10/25.
//

import SwiftUI

struct ProposalCard: View {
    
    let proposal : Proposal
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            //Header
            
            HStack {
                
                VStack(alignment: .leading, spacing: 2) {
                    
                    Text(proposal.passengerName)
                        .font(.headline)
                        .fontWeight(.bold)
                        .lineLimit(1)
                    
                    Text("Passport: \(proposal.passportNo)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                StatusBadge(status: proposal.Payment_Status.displayName)
            }
          
        }
            
            
    }
}

#Preview {
    
     var sampleProposal: Proposal {
            Proposal(
                proposal_id: 1,
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
            )
        }
    
    ScrollView {
        VStack(spacing: 12) {
            ProposalCard(proposal: sampleProposal)
            ProposalCard(proposal: sampleProposal) // multiple cards preview
        }
        .padding()
    }
    
    .background(Color(.systemGroupedBackground))
}
