//
//  UserListSingleGridView.swift
//  UserList
//
//  Created by Ordinateur elena on 01/02/2025.
//
//un élément de la grille des utilisateurs
import SwiftUI

struct UserSingleGridViewList: View {
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

#Preview {
	UserSingleGridViewList(user: User(user: UserListResponse.User(
		name: UserListResponse.User.Name(title: "mr", first: "john", last: "doe"),
		dob: UserListResponse.User.Dob(date: "1990-02-12", age: 19),
		picture: UserListResponse.User.Picture(
			large: "https://randomuser.me/api/portraits/men/83.jpg",
			medium: "https://randomuser.me/api/portraits/med/men/85.jpg",
			thumbnail: "https://randomuser.me/api/portraits/thumb/men/86.jpg"
		))))
}
