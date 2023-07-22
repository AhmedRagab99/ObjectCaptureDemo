//
//  CaptureSession.swift
//  ObjectCaptureDemo
//
//  Created by Ahmed Ragab on 23/07/2023.
//

import SwiftUI
import Combine
import RealityKit


final class CaptureSession {
    var inputFolder:URL
    var outputFolder:URL
    var subscriber: AnyCancellable?

    
    
    // for session and congigurations
    var configuration =  PhotogrammetrySession.Configuration()
    var session:PhotogrammetrySession?
    
    
    init(inputFolder: URL = URL(filePath: "/Users/ahmedragab/Desktop/ObjectCaptureDemo/flower/",directoryHint: .isDirectory), outputFolder: URL = URL(filePath:"/Users/ahmedragab/Desktop/object.usdz")) {
        self.inputFolder = inputFolder
        self.outputFolder = outputFolder
        setupSession()
        setupConfiguration()
    }
    
    
    func setupSession() {
        do {
            session = try PhotogrammetrySession(
                input: inputFolder,
                configuration: configuration
            )
        } catch let error {
            print("setSessionError",error.localizedDescription)
        }
    }
    
    func setupConfiguration() {
        configuration.featureSensitivity = .high
        configuration.sampleOrdering = .unordered
    }
    func run() throws {
        let request = PhotogrammetrySession.Request.modelFile(
            url: self.outputFolder,
            detail: .preview
        )
        
        guard let session = session else {return}
        let semaphore = DispatchSemaphore(value: 0)

        
        do {
            let waiter = Task {
                for try await output in session.outputs {
                    switch output {
                    case .processingComplete:
                        print("Processing is complete.")
                        semaphore.signal()
                    case .requestComplete(let request, let result):
                        print("Request complete.")
                        print(request)
                        print(result)
                        semaphore.signal()
                    case .requestProgress(let request, let fractionComplete):
                        print("Request in progress: \(fractionComplete)")
                    default:
                        print(output)
                    }
                }
            }
        } catch let error{
            print("error from wait function",error.localizedDescription)
        }

        try session.process(requests: [request])

        semaphore.wait()
    }
}
