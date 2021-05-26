//
//  Main.swift
//  FuncoesResumo
//
//  Created by Vitor Demenighi on 24/05/21.
//

import Foundation
import CommonCrypto

class Main {
    var chunks: [Data] = []
    
    func run(){
        /// Read video file
        let videoData = readVideoFile(fileName: "sha1")
        
        /// Split video data in block of 1024 bytes
        chunks = getChunks(data: videoData)
        
        /// Calculate chunk hash values
        let resultChunkHashValues = calculeHashValues()
        
        /// print h0 hex hashValue
        if let h0 = resultChunkHashValues.last {
            print("Result: " + h0.hex())
        }
    }
    
    
    func calculeHashValues() -> [Data] {
        var result: [Data] = []
        
        var previousHashableData: Data?
        for index in stride(from: chunks.count-1, to: -1, by: -1) {
            if index == chunks.count - 1 {
                previousHashableData = sha256(chunks[index])
            } else if let data = previousHashableData {
                chunks[index].append(data)
                previousHashableData = sha256(chunks[index])
            }
            
            if let data = previousHashableData {
                result.append(data)
            }
        }
        
        return result
    }
    
    func sha256(_ data: Data) -> Data? {
        guard let res = NSMutableData(length: Int(CC_SHA256_DIGEST_LENGTH)) else { return nil }
        CC_SHA256((data as NSData).bytes, CC_LONG(data.count), res.mutableBytes.assumingMemoryBound(to: UInt8.self))
        return res as Data
    }
    
    func getChunks(data: Data?) -> [Data] {
        guard let data = data else {
            return []
        }
        
        var result: [Data] = []
        let chunkSize = 1024
        let lastChunkSize = data.count % chunkSize
        let totalSize = data.count
        var offset = 0
        
        data.withUnsafeBytes { (unsafePointer: UnsafePointer<UInt8>) -> Void in
            let mutRawPointer = UnsafeMutableRawPointer(mutating: unsafePointer)
            while offset < totalSize {
                var chunk: Data
                if lastChunkSize != 0, offset + chunkSize >= totalSize {
                    chunk = Data(bytesNoCopy: mutRawPointer+offset, count: lastChunkSize, deallocator: Data.Deallocator.none)
                } else {
                    chunk = Data(bytesNoCopy: mutRawPointer+offset, count: chunkSize, deallocator: Data.Deallocator.none)
                }
                result.append(chunk)
                offset += chunkSize
            }
        }
        
        return result
    }
    
    func readVideoFile(fileName: String) -> Data? {
        do {
            let fileURL = Bundle.main.url(forResource: fileName, withExtension: "mp4")!
            let videoData = try Data(contentsOf: fileURL)
            return videoData
        } catch {
            print("Error ao ler o arquivo...\n" + error.localizedDescription)
            return nil
        }
    }
}


extension Data {
    func hex() -> String {
        var result: String = ""
        for byte in self {
            result += String(format:"%02x", byte)
        }
        return result
    }
}
