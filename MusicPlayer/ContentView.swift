//
//  ContentView.swift
//  MusicPlayer
//
//  Created by Sai Kambampati on 3/18/20.
//  Copyright © 2020 Sai Kambmapati. All rights reserved.
//

import SwiftUI
import StoreKit
import MediaPlayer

struct ContentView: View {
    @State private var selection = 0
    @State private var musicPlayer = MPMusicPlayerController.applicationMusicPlayer
    @State private var currentSong = Song(id: "", name: "", artistName: "", artworkURL: "")
    
    var body: some View {
        TabView(selection: $selection) {
            PlayerView(musicPlayer: self.$musicPlayer, currentSong: self.$currentSong)
            .tag(0)
                .tabItem {
                    VStack {
                        Image(systemName: "music.note")
                        Text("Player")
                    }
                }
            SearchView(musicPlayer: self.$musicPlayer, currentSong: self.$currentSong)
            .tag(1)
                .tabItem {
                    VStack {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                }
            }
        }
        .accentColor(.pink)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .colorScheme(.dark)
            .previewDevice(.init(rawValue: "iPhone 11"))
    }
}
