//
//  barcodeViewModel.swift
//  barcode-scanner-ios
//
//  Created by Aryan Kaushik on 15/11/23.
//

import SwiftUI

final class BarcodeViewModel : ObservableObject {
    @Published var barcodeValue : String = "Not yet scanned"
    @Published var color : Color = .red
    
    
}
