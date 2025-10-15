//
//  CarouselViewModel.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 03/10/25.
//

import Foundation

/* refer Swiftui Code: "Dictinary with group by in SwiftUI"
 
 Now, your computed property:
 
 let allProposals: [Proposal] = [
     Proposal(id: 1, Payment_Status: PaymentStatus(displayName: "Paid")),
     Proposal(id: 2, Payment_Status: PaymentStatus(displayName: "Pending")),
     Proposal(id: 3, Payment_Status: PaymentStatus(displayName: "Paid")),
     Proposal(id: 4, Payment_Status: PaymentStatus(displayName: "Failed")),
     Proposal(id: 5, Payment_Status: PaymentStatus(displayName: "Pending"))
 ]
 So we have 5 proposals:
 
 ID          Payment_Status
 
 1           Paid
 2           Pending
 3           Paid
 4           Failed
 5           Pending
 

var paymentStatusSummary: [String: Int] {
    Dictionary(
        grouping: allProposals,
        by: { $0.Payment_Status.displayName }
    )
    .mapValues { $0.count }
}
Let’s see how it works step-by-step 👇
Step 1 — Grouping
Dictionary(grouping: allProposals, by: { $0.Payment_Status.displayName })
This will group all proposals by their payment status name.
Result (intermediate dictionary):
[
    "Paid": [Proposal(id: 1), Proposal(id: 3)],
    "Pending": [Proposal(id: 2), Proposal(id: 5)],
    "Failed": [Proposal(id: 4)]
]



Step 2 — Counting each group
.mapValues { $0.count } replaces each array of proposals with its count.
So it becomes:
[
    "Paid": 2,
    "Pending": 2,
    "Failed": 1
]
✅ Final Result
paymentStatusSummary = ["Paid": 2, "Pending": 2, "Failed": 1]
Meaning:
2 proposals are Paid
2 proposals are Pending
1 proposal is Failed


 */
@MainActor
class CarViewModel : ObservableObject {
    
    
    // MARK: - Dependencies
    private let carRepository: CarRepositoryProtocol  //so it always expect homeRepository
    
    // MARK: - Published State
        // The view observes this single property to drive all UI changes.
        // private(set)` means only the ViewModel can modify the state,
        // which is a key principle of this pattern.
      @Published private(set) var bannerState: ViewState<[Banner]> = .idle
    
      @Published private(set) var carState: ViewState<[Proposal]> = .idle
    
       @Published private(set) var isLoading = false
       @Published private(set) var error: NetworkError?

       private var fetchTask: Task<Void, Never>? // 👈
    
    
      //For Filter Car Data :---
      
    @Published private(set) var allProposals: [Proposal] = []
    @Published var searchCriteria = ProposalSearchCriteria()
    
    
    // Removed default parameter to enforce proper DI
        init(carRepository: CarRepositoryProtocol) {
            self.carRepository = carRepository
        }
        deinit {
           fetchTask?.cancel() // ✅ Extra safety
       }

    
    // MARK: - Public API
        func fetchAllData() {
            guard !isLoading else { return } // ✅ Prevent duplicate calls
            
            fetchTask?.cancel()

            fetchTask = Task { [weak self] in
                await self?.fetchAllDataInternal()
            }
        }
        

      private func fetchAllDataInternal() async {
            isLoading = true
            bannerState = .loading
            carState = .loading

            defer {
                if !Task.isCancelled {
                    isLoading = false
                }
            }

            do {
                // Run both APIs concurrently
                async let bannersTask = carRepository.fetchBanners()
                async let proposalsTask = carRepository.fetchCarProposal()

                // Await both
                let (banners, proposals) = try await (bannersTask, proposalsTask)

                // Check cancellation before updating state
                try Task.checkCancellation()
                
                bannerState = .success(banners)
                carState = .success(proposals)
                
                // If proposals succeeded, populate the source-of-truth array:
                // ✅ Populate source-of-truth array in ViewModel
                allProposals = proposals
                    
                
            } catch is CancellationError {
                print("🟡 Fetch cancelled")
                // States remain in .loading, will be reset on next call
            } catch let networkError as NetworkError {
                bannerState = .error(networkError)
                carState = .error(networkError)
                self.allProposals = [] // Also clear data on error
            } catch {
                let unknownError = NetworkError.unknown(error.localizedDescription)
                bannerState = .error(unknownError)
                carState = .error(unknownError)
                self.allProposals = [] // Also clear data on error
            }
        }
    
    
      func cancelAll() {
            fetchTask?.cancel()
            isLoading = false
        }
    
    
    //*************** For Filter ***************
    
    // MARK: - Computed Properties for Search/Filter
    
    var filteredProposals: [Proposal] {
            guard !allProposals.isEmpty else { return [] }
            
            var filtered = allProposals
            
            // Apply search query
            if !searchCriteria.query.isEmpty {
                filtered = filtered.filter { proposal in
                    proposal.passengerName.localizedCaseInsensitiveContains(searchCriteria.query) ||
                    (proposal.assistanceNo).localizedCaseInsensitiveContains(searchCriteria.query) ||
                    proposal.certificateNo.localizedCaseInsensitiveContains(searchCriteria.query) ||
                    proposal.passportNo.localizedCaseInsensitiveContains(searchCriteria.query) ||
                    proposal.planName.localizedCaseInsensitiveContains(searchCriteria.query) ||
                    proposal.agentName.localizedCaseInsensitiveContains(searchCriteria.query) ||
                    (proposal.invoiceno ?? "").localizedCaseInsensitiveContains(searchCriteria.query)
                }
            }
            
            // Apply payment status filter
            if let status = searchCriteria.paymentStatus, !status.isEmpty {
                filtered = filtered.filter { proposal in
                    (proposal.Payment_Status.displayName).localizedCaseInsensitiveContains(status)
                }
            }
            
            return filtered
        }
     
    var searchResultCount: Int {
           if searchCriteria.isActive {
               return filteredProposals.count
           }
           return allProposals.count
       }
    
    //paymentStatusSummary is a computed property.
    //It automatically uses the ViewModel’s allProposals array as the source of truth.
    //Note refer above comment at top of screen
    var paymentStatusSummary: [String: Int] {
        Dictionary(grouping: allProposals, by: { $0.Payment_Status.displayName  })
                .mapValues { $0.count }
        }
    
    /*
    //paymentStatusSummary.keys
    //Returns a collection of all keys from your dictionary.
     
     ["Paid", "Pending", "Failed"]
     
    2. Array(paymentStatusSummary.keys)

     Converts that key collection into a real array of Strings:
     Type: [String]
     
     3. .sorted()

     Sorts the array alphabetically (A → Z).
     Example:
    
    */
    var availablePaymentStatuses: [String] {
       // Array(paymentStatusSummary.keys).sorted()
        
        let statuses = Array(paymentStatusSummary.keys).sorted()
           
           statuses.forEach { status in
               print("💡 Payment status: \(status)")
           }
           
           return statuses
    }
    
    // MARK: - Search & Filter Methods
        func clearSearch() {
            searchCriteria = ProposalSearchCriteria()
        }
        
        func search(with query: String) {
            searchCriteria.query = query
        }
        
        func filterByPaymentStatus(_ status: String?) {
            searchCriteria.paymentStatus = status
        }
        
    //*************** End ***************
    //*****No used  Decleration ***************
    private var fetchBannerTask: Task<Void, Never>?

    private var fetchCarTask: Task<Void, Never>?
   //**********************************************//
    
    
    /********************Not in User  ***************/
    
       //Not in User
      func fetchBanners() async {
        // ✅ This is the protective gate. If `isLoading` is true,
        // the function exits immediately, preventing duplicate requests.
        guard !bannerState.isLoading else { return }
        
        bannerState = .loading
        
        do {
            let fetchedBanners = try await carRepository.fetchBanners()
            
            // Here, you could also add a case for empty banners if needed
            bannerState = .success(fetchedBanners)
            
        } catch let error as NetworkError {
            bannerState = .error(error)
            print("❌ Failed to fetch banners: \(error.localizedDescription)")
        } catch {
            // Handle unexpected error types
            bannerState = .error(.noData)
            print("❌ Failed to fetch banners: \(error.localizedDescription)")
        }
    }
    
    
     //Not in User
      func fetchBanners1(forceRefresh: Bool = false) {
            // ✅ This is the protective gate. If `isLoading` is true,
            // the function exits immediately, preventing duplicate requests.
            guard forceRefresh || !bannerState.isLoading else { return }
            
          // Cancel any ongoing task before starting a new one
              fetchBannerTask?.cancel()
          
          
          fetchBannerTask = Task { [weak self] in
              
              
              guard let self = self else { return }
              self.bannerState = .loading
              
              do {
                  let banners = try await self.carRepository.fetchBanners()
                  self.bannerState = .success(banners)
              } catch let error as NetworkError {
                  self.bannerState = .error(error)
                  print("❌ Failed to fetch banners: \(error.localizedDescription)")
              } catch {
                  
                  self.bannerState = .error(.unknown(error.localizedDescription))
                  print("❌ Failed to fetch banners: \(error.localizedDescription)")
              }
          }
            
           
        }
    
    
    //Not in User
     func fetchCarProposal() {
        
        
        guard  !carState.isLoading else { return }
        
        self.carState = .loading
        
        // Cancel any ongoing task before starting a new one
          fetchCarTask?.cancel()
        fetchCarTask = Task{ [weak self] in
            
            guard let self = self else { return }
            self.carState = .loading
            
            do {
                
                let Proposals = try await carRepository.fetchCarProposal()
                
                self.carState = .success(Proposals)
                
            }catch let error as NetworkError {
                self.bannerState = .error(error)
                print("❌ Failed to fetch banners: \(error.localizedDescription)")
            } catch {
                
                self.bannerState = .error(.unknown(error.localizedDescription))
                print("❌ Failed to fetch banners: \(error.localizedDescription)")
            }
        }
       
        
        
    }
  
    
    
}
