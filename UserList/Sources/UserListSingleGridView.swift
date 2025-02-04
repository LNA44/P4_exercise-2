//
//  UserListSingleGridView.swift
//  UserList
//
//  Created by Ordinateur elena on 01/02/2025.
//
//un élément de la grille des utilisateurs
import SwiftUI

struct UserListSingleGridView: View {
	
	var user : User  
	
    var body: some View {
		VStack (spacing : 20){
			AsyncImage(url: URL(string: user.picture.medium)) { image in
				image
					.resizable()
					.aspectRatio(contentMode: .fill)
					.frame(width: 150, height: 150)
					.clipShape(Circle())
					.shadow(radius:10)
					.overlay(Circle() .stroke(Color.gray, lineWidth: 1))
			} placeholder: {
				ProgressView()
					.frame(width: 150, height: 150)
					.clipShape(Circle())
			}
			
			Text("\(user.name.first) \(user.name.last)")
				.font(.headline)
				.foregroundStyle(Color(.black))
				.multilineTextAlignment(.center)
		}
    }
}

//#Preview {
//    UserListSingleGridView()
//}
