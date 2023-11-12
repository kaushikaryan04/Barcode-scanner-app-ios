//
//  ScannerView.swift
//  barcode-scanner-ios
//
//  Created by Aryan Kaushik on 14/11/23.
//

import SwiftUI

struct ScannerView: UIViewControllerRepresentable {

    @Binding var barcodeValue: String ;
    @Binding var color : Color ;
    func makeCoordinator() -> Coordinator {
        Coordinator(barcodeValueBinding: $barcodeValue, textColor: $color)
    }
    
    func makeUIViewController(context: Context) -> ScannerVC {
        ScannerVC(scannerDelegate: context.coordinator)
    }
    
    func updateUIViewController(_ uiViewController: ScannerVC, context: Context) {}
    
    final class Coordinator : NSObject , ScannerVCDelegate {
        @Binding var barcodeValueBinding : String;
        @Binding var textColor : Color ;
        init(barcodeValueBinding: Binding<String>, textColor: Binding<Color>) {
            _barcodeValueBinding = barcodeValueBinding
            _textColor = textColor
            super.init()

        }
        
        func didFindBarCode(barcode: String) {

            barcodeValueBinding = barcode 
            textColor = .green
        }
        
        func didSurface(error: CameraError) {
            barcodeValueBinding = error.rawValue
            textColor = .red
        }
        
        
    }
    
    
    
    
}

#Preview {
    ScannerView(barcodeValue: .constant("Not yet scanned") , color : .constant(.red))
}
