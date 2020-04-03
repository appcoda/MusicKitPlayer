//
//  SearchView.swift
//  MusicPlayer
//
//  Created by Sai Kambampati on 3/18/20.
//  Copyright © 2020 Sai Kambmapati. All rights reserved.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    let songs = ["Blinding Lights", "That Way", "This Is Me"]
    
    var body: some View {
        VStack {
            TextField("Search Songs", text: $searchText, onCommit: {
                print(self.searchText)
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal, 16)
            .accentColor(.pink)
            
            List {
                ForEach(songs, id:\.self) { songTitle in
                    HStack {
                        Image(systemName: "rectangle.stack.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .cornerRadius(5)
                            .shadow(radius: 2)

                        VStack(alignment: .leading) {
                            Text(songTitle)
                                .font(.headline)
                            Text("Artist Title")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Button(action: {
                            print("Playing \(songTitle)")
                        }) {
                            Image(systemName: "play.fill")
                                .foregroundColor(.pink)
                        }
                    }
                }
            }
            .accentColor(.pink)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
