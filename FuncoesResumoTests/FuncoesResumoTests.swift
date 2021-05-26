//
//  FuncoesResumoTests.swift
//  FuncoesResumoTests
//
//  Created by Vitor Demenighi on 24/05/21.
//

import XCTest
@testable import FuncoesResumo

class FuncoesResumoTests: XCTestCase {
    
    let sut = Main()

    func testReadVideoFile() {
        let result = sut.readVideoFile(fileName: "sha1")
        
        XCTAssertNotNil(result)
    }
    
    func testGetDataBlocks() {
        let data = sut.readVideoFile(fileName: "sha1")
        let result = sut.getChunks(data: data)
        
        XCTAssertFalse(result.isEmpty)
    }
  
    func testCalculeHashValuesAndReturnH0() {
        let data = sut.readVideoFile(fileName: "sha1")
        let chunks = sut.getChunks(data: data)
        sut.chunks = chunks
        
        let result = sut.calculeHashValues()
        let h0 = result.last?.hex()
        let hN = result.first?.hex()
        
        XCTAssertEqual(h0, "302256b74111bcba1c04282a1e31da7e547d4a7098cdaec8330d48bd87569516")
        XCTAssertEqual(hN, "37d88ff100aaf4c63bb828ff1a89f99af2123e143bd758d0eb1573a044e74c84")
    }
}
