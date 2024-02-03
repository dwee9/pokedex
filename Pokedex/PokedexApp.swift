//
//  PokedexApp.swift
//  Pokedex
//
//  Created by David Wee on 1/31/24.
//

import SwiftUI

@main
struct PokedexApp: App {

    var body: some Scene {
        WindowGroup {
           PokemonListView()
        }
    }
}


struct ContentView: View {
    @State var details = false
    @Namespace var namespace
    private let id: String = "myID"
    var body: some View {

        if (details) {
            TestView1(details: $details, id: id, namespace: namespace)
        }
        else {
            TestView2(details: $details, id: id, namespace: namespace)
        }

    }
}


struct TestView1: View {
    @Binding var details: Bool
    let id: String
    var namespace: Namespace.ID
    var body: some View {

        ZStack {

            Color.gray.ignoresSafeArea()

            RoundedRectangle(cornerRadius: 8.0)
                .matchedGeometryEffect(id: id, in: namespace)
                .transition(.scale(scale: 1.0))
                .frame(width: 300, height: 700)
                .onTapGesture {
                    withAnimation {
                        details = false
                    }
                }

        }

    }
}

struct TestView2: View {
    @Binding var details: Bool
    let id: String
    var namespace: Namespace.ID
    var body: some View {
        ZStack {
            Color.green.ignoresSafeArea()

            VStack {
                Spacer()

                HStack {
                    Spacer()

                    RoundedRectangle(cornerRadius: 8.0)
                .matchedGeometryEffect(id: id, in: namespace)
                .transition(.scale(scale: 1.0))
                .frame(width: 200, height: 200)
                .onTapGesture {
                    withAnimation {
                        details = true
                    }
                }
                }
            }
        }

    }
}
