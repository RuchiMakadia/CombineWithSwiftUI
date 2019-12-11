//
//  ContentView.swift
//  combineSwifUIDemo
//
//  Created by eHeuristic on 10/12/19.
//  Copyright © 2019 eHeuristic. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var viewmodel = Model()
    var body: some View {
        NavigationView {
            VStack {
                List(viewmodel.post_data) { user in
                    NavigationLink(
                    destination: DetailsView(textstr: "\(user.body)")) {
                        Text("\(user.title)")
                    }
                }
            }.onAppear(perform: {
                self.viewmodel.get_post_data(url: appUrl.post_url)
            })
            .navigationBarTitle(Text("Users"))
        }
    }
}

struct DetailsView: View {
    var textstr: String
    var body: some View {
        VStack {
            Text(textstr)
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



