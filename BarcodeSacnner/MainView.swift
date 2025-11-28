//
//  ContentView.swift
//  BarcodeSacnner
//
//  Created by 韩飞洋 on 2025/11/28.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 300)
                    .padding(.vertical)
                Spacer()
                    .frame(height: 30)
                Label("Scanned Barcode:", systemImage: "barcode.viewfinder")
                    .font(.title)
                Text("Not Yet Scanned")
                    .bold()
                    .font(.largeTitle)
                    .foregroundStyle(.tint)
                    .padding()
            }
            .navigationTitle("Barcode Scanner")
        }

    }
}

#Preview {
    MainView()
}
