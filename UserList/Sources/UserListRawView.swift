//
//  UserListRawView.swift
//  UserList
//
//  Created by Ordinateur elena on 01/02/2025.
//
// un élément de la liste des utilisateurs
import SwiftUI

struct UserListRawView: View {
	var user : User //un utilisateur particulier
	
	var body: some View {
		HStack (spacing: 20){
			AsyncImage(url: URL(string: user.picture.thumbnail)) { image in
				image
					.resizable()
					.aspectRatio(contentMode: .fill)
					.frame(width: 50, height: 50)
					.clipShape(Circle())
					.shadow(radius:10)
					.overlay(Circle().stroke(Color.gray, lineWidth: 1))
			} placeholder: {
				ProgressView()
					.frame(width: 50, height: 50)
					.clipShape(Circle())
			}
			
			VStack(alignment: .leading, spacing:10) {
				Text("\(user.name.first) \(user.name.last)")
					.font(.headline)
				Text("\(user.dob.date)")
					.font(.subheadline)
			}.foregroundColor(.primary)
		}
		.frame(width:330, height: 80)
		.background(Color("Beige"))
		.clipShape(RoundedRectangle(cornerRadius: 10))
		.padding(EdgeInsets(top: -10, leading: 0, bottom:-10, trailing: 0))
		.shadow(radius: 5)
	}
}

//#Preview {
//    UserListRawView()
//}
