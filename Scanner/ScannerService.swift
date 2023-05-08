//
//  ScannerService.swift
//  ReceiptScanner
//
//  Created by Flavius Dolha on 03.05.2023.
//

import Foundation
import SwiftUI
import Vision

// MARK: - ScannerServiceError

enum ScannerServiceError: Error {
    case processing
    case didNotFound
}

// MARK: - ScannerService

protocol ScannerService {
    func scanReceipt(_ image: UIImage, completion: @escaping (Result<String, ScannerServiceError>) -> Void)
}

// MARK: - ScannerServiceLive

class ScannerServiceLive: ScannerService {
    
    // MARK: - Instance Methods
    
    func scanReceipt(_ image: UIImage, completion: @escaping (Result<String, ScannerServiceError>) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(.failure(.processing))
            return
        }
        let recognizeTextRequest = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  !observations.isEmpty else {
                completion(.failure(.didNotFound))
                return
            }
            let words = ["total", "amount", "summe", "suma"]
            var didFindTotal = false
            for currentObservation in observations {
                let topCandidate = currentObservation.topCandidates(1)
                if let recognizedText = topCandidate.first {
                    if didFindTotal {
                        let text = recognizedText.string.filter("0123456789.".contains)
                        if !text.isEmpty {
                            completion(.success(text))
                            break
                        }
                    } else {
                        let text = String(recognizedText.string.unicodeScalars.filter { CharacterSet.letters.contains($0) })
                        if words.contains(where: text.lowercased().contains) {
                            didFindTotal = true
                        }
                    }
                }
            }
            completion(.failure(.didNotFound))
        }
        recognizeTextRequest.recognitionLevel = .accurate
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([recognizeTextRequest])
            }
            catch {
                completion(.failure(.processing))
            }
        }
    }
}
