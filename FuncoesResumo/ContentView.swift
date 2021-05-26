//
//  ContentView.swift
//  FuncoesResumo
//
//  Created by Vitor Demenighi on 24/05/21.
//

import SwiftUI

struct ContentView: View {
    
    var main = Main()
    var body: some View {
        Text("Hello, world!")
            .padding()
        Button(action: {main.run()}, label: {
            Text("Vai")
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
