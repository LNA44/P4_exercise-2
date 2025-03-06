//
//  UserListRawView.swift
//  UserList
//
//  Created by Ordinateur elena on 01/02/2025.
//
// un élément de la liste des utilisateurs
import SwiftUI

struct UserRawViewList: View {
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
			}
			.foregroundColor(.primary)
		}
		.frame(maxWidth:.infinity)
		.frame(height: 80)
		.background(Color("Beige"))
		.clipShape(RoundedRectangle(cornerRadius: 10))
		.shadow(radius: 5)
	}
}

#Preview {
	UserRawViewList(user: User(user: UserListResponse.User(
		name: UserListResponse.User.Name(title: "mr", first: "john", last: "doe"),
		dob: UserListResponse.User.Dob(date: "1990-02-12", age: 19),
		picture: UserListResponse.User.Picture(
			large: "https://randomuser.me/api/portraits/men/83.jpg",
			medium: "https://randomuser.me/api/portraits/med/men/85.jpg",
			thumbnail: "https://randomuser.me/api/portraits/thumb/men/86.jpg"
		))))
}
