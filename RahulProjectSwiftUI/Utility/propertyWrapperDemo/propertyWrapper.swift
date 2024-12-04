//
//  propertyWrapper.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 30/11/24.
//


struct SuitCase{
    
    let color :String
    @FiftyOrless var weight : Int
    
    init(color: String, weight: Int) {
        self.color = color
        self.weight = weight
    }
}


@propertyWrapper
struct FiftyOrless {
    
    
    private var weight : Int
    
    var wrappedValue: Int{
        
        get { return weight }
        set { weight = min(newValue, 50) }
    }
    
    init() {
        self.weight = 0
    }
    
}
