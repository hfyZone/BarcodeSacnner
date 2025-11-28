//
//  ContentView.swift
//  BarcodeSacnner
//
//  Created by 韩飞洋 on 2025/11/28.
//

import SwiftUI

struct MainView: View {
    @State private var scannedCode = ""
    var body: some View {
        NavigationStack {
            VStack {
                ScannerView(scannedCode: $scannedCode)
                    .frame(maxWidth: .infinity, maxHeight: 300)
                    .padding(.vertical)
                Spacer()
                    .frame(height: 30)
                Label("Scanned Barcode:", systemImage: "barcode.viewfinder")
                    .font(.title)
                Text(scannedCode.isEmpty ? "Not Yet Scanned" : scannedCode)
                    .bold()
                    .font(.largeTitle)
                    .foregroundStyle(scannedCode.isEmpty ? .blue : .green)
                    .padding()
            }
            .navigationTitle("Barcode Scanner")
        }

    }
}

#Preview {
    MainView()
}
