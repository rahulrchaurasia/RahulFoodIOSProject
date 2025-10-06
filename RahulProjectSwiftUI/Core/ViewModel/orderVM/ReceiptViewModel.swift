//
//  ReceiptViewModel.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 01/10/25.
//

import Foundation
import CoreGraphics
import SwiftUICore

/*
   Concept                                Why
renderPDF synchronous               It does not use async APIs.
 
await not on renderPDF              You only await async functions, renderPDF is sync.
 
Task(priority:) { ... }.value       Runs synchronous, blocking work off the main thread and                                     lets you await the result in an async function safely.
 
.userInitiated                        Indicates high priority, because the user is actively                                     waiting for the result.
 */

@MainActor
class ReceiptViewModel : ObservableObject {
    
    // The URL of the generated PDF
        @Published var pdfURL: URL?
    
    // Controls the presentation of the share sheet
        @Published var showShareSheet = false
    
    // 1. Add a new state to track the progress
    @Published var isGeneratingPDF = false
    
    
    /**********************************************************************************
     Why we wrap it in Task(priority:)

     Even though renderPDF is synchronous, PDF rendering can take noticeable time. If you call it directly on the main thread, the UI could freeze.

     Wrapping it in Task(priority:) { ... } allows you to:

     Run the heavy synchronous work off the main thread (background thread).

     Use .value with await to wait for the result without blocking the main actor.

     So essentially, this:

     let url = try await Task(priority: .userInitiated) {
         try renderPDF(for: orderDetails)
     }.value


     Creates a background task with .userInitiated priority (meaning the user is actively waiting for it).

     Runs renderPDF off the main thread to avoid UI freeze.

     .value suspends the async function until the background task finishes and returns the URL.
     ***********************************************************************************/
        
    func generateAndSharePDF(for orderDetails: OrderDetails) async {
        
        // 2. Set to true when the task starts
        isGeneratingPDF = true
        
        // Use a 'defer' block to guarantee this is set to false
        // when the function exits, even if an error occurs.
        defer { isGeneratingPDF = false }
        
        // Use a task to perform the asynchronous rendering
        do {
            let url = try await Task(priority: .userInitiated) {
                try renderPDF(for: orderDetails)
            }.value
            
            self.pdfURL = url
            self.showShareSheet = true
            
        } catch {
            print("❌ Failed to generate PDF: \(error)")
        }
    }
    
    /**********************************************************************************
    //Mark :
     Notice: it’s synchronous. It does not return async or await anything.

     await is only needed for asynchronous functions. Since renderPDF is fully synchronous (even though rendering a PDF might take a bit of time), you cannot use await directly on it. That’s why you just call it normally:
     ************************************************************************ */
    // Renders the ReceiptPDFView and returns the URL of the saved file.
    private func renderPDF(for orderDetails: OrderDetails) throws -> URL {
            let pdfView = ReceiptPDFView(orderDetails: orderDetails)
            let renderer = ImageRenderer(content: pdfView)
            
            let url = URL.documentsDirectory.appending(path: "receipt-\(orderDetails.orderId).pdf")
            
            renderer.render { size, context in
                var box = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else {
                    return
                }
                pdf.beginPDFPage(nil)
                context(pdf)
                pdf.endPDFPage()
                pdf.closePDF()
            }
            
            guard FileManager.default.fileExists(atPath: url.path) else {
                throw NSError(domain: "PDFGenerationError", code: 1, userInfo: [NSLocalizedDescriptionKey: "PDF file was not created."])
            }
            
            return url
        }
}
