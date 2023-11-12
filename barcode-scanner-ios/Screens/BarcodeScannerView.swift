//
//  ContentView.swift
//  barcode-scanner-ios
//
//  Created by Aryan Kaushik on 12/11/23.
//

import SwiftUI

struct BarcodeScannerView: View {
        
    @StateObject var viewModel = BarcodeViewModel()
    var body: some View {
        NavigationView{
            VStack{
                ScannerView(barcodeValue:$viewModel.barcodeValue , color : $viewModel.color)
                    .frame(maxWidth: .infinity , maxHeight:300)
                Spacer().frame(height:60)
                Label("Scanned Barcode :" , systemImage: "barcode.viewfinder")
                    .font(.title)
                    
                
                Text(viewModel.barcodeValue)
                    .bold()
                    .font(.largeTitle)
                    .foregroundStyle(viewModel.color)
                    .padding()
            }.navigationTitle("Barcode Scanner")
        }
    }
}

#Preview {
    BarcodeScannerView()
}
