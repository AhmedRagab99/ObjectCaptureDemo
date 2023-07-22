//
//  ContentView.swift
//  ObjectCaptureDemo
//
//  Created by Ahmed Ragab on 22/07/2023.
//

import SwiftUI
import Combine
import RealityKit
struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            
            Button {
                runSession()
            } label: {
                Text("start capture now")
            }

        }
        .padding()
    }
    
    
    func runSession()  {
        let capture =  CaptureSession()
        try! capture.run()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
