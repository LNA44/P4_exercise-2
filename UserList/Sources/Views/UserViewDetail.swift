import SwiftUI

struct UserViewDetail: View {
	let user: User
	var body: some View {
		VStack{
			VStack (spacing: 40){
				AsyncImage(url: URL(string: user.picture.large)) { image in
					image
						.resizable()
						.aspectRatio(contentMode: .fill)
						.frame(width: 150, height: 150)
						.clipShape(Circle())
						.overlay(Circle().stroke(Color.brown, lineWidth: 3))
						.shadow(radius: 5)
				} placeholder: {
					ProgressView()
						.frame(width: 200, height: 200)
						.clipShape(Circle())
				}
				VStack(alignment: .center, spacing : 30) {
					Text("\(user.name.first) \(user.name.last)")
						.font(.largeTitle)
						.fontWeight(.bold)
						.foregroundColor(.primary)
					HStack {
						Image(systemName:"birthday.cake.fill")
						Text("\(user.dob.date)")
							.font(.subheadline)
							.foregroundColor(.secondary)
					}
				}
			}
		}.frame(width: 350, height: 400)
			.background(Color("Beige") )
			.cornerRadius(20)
			.padding(20)
			.navigationTitle("\(user.name.first) \(user.name.last)")
			.offset(y:-130)
			.shadow(radius:5)
	}
}
#Preview {
	UserViewDetail(user: User(user: UserListResponse.User(
		name: UserListResponse.User.Name(title: "mr", first: "john", last: "doe"),
		dob: UserListResponse.User.Dob(date: "1990-02-12", age: 19),
		picture: UserListResponse.User.Picture(
			large: "https://randomuser.me/api/portraits/men/83.jpg",
			medium: "https://randomuser.me/api/portraits/med/men/85.jpg",
			thumbnail: "https://randomuser.me/api/portraits/thumb/men/86.jpg"
		))))
}
