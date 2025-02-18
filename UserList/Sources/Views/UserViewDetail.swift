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
		}.frame(width: 400, height: 400)
			.background(Color("Beige") )
			.cornerRadius(20)
			.padding(20)
			.navigationTitle("\(user.name.first) \(user.name.last)")
			.offset(y:-130)
			.shadow(radius:5)
	}
}
