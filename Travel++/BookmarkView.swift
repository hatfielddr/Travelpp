//
//  BookmarkView.swift
//  Travel++
//
//  Created by Tori Duguid on 2/18/22.
//

import SwiftUI

struct BookmarkView: View {
    var body: some View {
        
        VStack {
            Image("Logo")
                .resizable()
                .frame(width:267, height:200)
                .padding(.top, -200)
                .padding(.bottom, 100)
            
            Text("Login")
        }
        
        
    }
}

struct BookmarkView_Previews: PreviewProvider {
    static var previews: some View {
        BookmarkView()
    }
}
