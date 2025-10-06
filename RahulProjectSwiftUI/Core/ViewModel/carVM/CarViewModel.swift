//
//  CarouselViewModel.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 03/10/25.
//

import Foundation


@MainActor
class CarViewModel : ObservableObject {
    
    
    // MARK: - Dependencies
    private let carRepository: CarRepositoryProtocol  //so it always expect homeRepository
    
    
    
    // Removed default parameter to enforce proper DI
        init(carRepository: CarRepositoryProtocol) {
            self.carRepository = carRepository
        }
    
    @Published var banners: [Banner] = []
    @Published var isLoading = true
        
    
    // Simulates a network request to fetch carousel data
    
  
    func fetchBanners() async {
        
        isLoading = true
        defer { isLoading = false } // ✅ always runs (success or error)

        do{
            
            // ✅ Call the repository to fetch data
          self.banners = try await carRepository.fetchBanners()
            
           
            isLoading = false

               
        }
        catch{
            
            print("❌ Failed to fetch banners:", error)
             // You can add error handling here, like showing an alert
        }
       
    }
    
    
}
