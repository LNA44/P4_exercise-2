import SwiftUI

struct UserDetailView: View {
	let user: User
	
	var body: some View {
		
		ZStack{
			Rectangle()
				.foregroundColor(.gray .opacity(0.1))
				.cornerRadius(10)
				.frame(width:350, height:400)
				.offset(y:-90)
				.overlay(
					VStack (spacing: 40){
						AsyncImage(url: URL(string: user.picture.large)) { image in
							image
								.resizable()
								.aspectRatio(contentMode: .fill)
								.frame(width: 150, height: 150)
								.clipShape(Circle())
								.overlay(Circle().stroke(Color.gray, lineWidth: 3))
								.shadow(radius: 10)
								.padding(.top, 50)
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
								.shadow(radius:3)
							Text("\(user.dob.date)")
								.font(.subheadline)
								.foregroundColor(.secondary)
							
						}
					}.offset(y:-130)
				)
		}
		.navigationTitle("\(user.name.first) \(user.name.last)")
	}
		
}
