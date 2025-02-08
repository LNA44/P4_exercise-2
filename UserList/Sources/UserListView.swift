import SwiftUI

struct UserListView: View {
	@ObservedObject var viewModel : UserListViewModel //ajout pour créer lien viewmodel
	
	var body: some View {
		NavigationView {
			VStack{
				if !viewModel.isGridView {
					List(viewModel.users) { user in
						GroupBox {
							NavigationLink(destination: UserDetailView(user: user)) {
									UserListRawView(user: user) // sous vue pour chaque ligne de la liste qui se répète
							}
							.onAppear {
								viewModel.loadMoreDataIfNeeded(currentItem: user)
							}
						}.padding(EdgeInsets(top: -10, leading: 0, bottom:-10, trailing: 0))
							.listRowBackground(Color.clear)
							.listRowSeparator(.hidden)
					}
				} else {
					ScrollView {
						LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing:50) {
							ForEach(viewModel.users) { user in
								NavigationLink(destination: UserDetailView(user: user)) {
									UserListSingleGridView( user : user ) //sous vue pour chaque élément de la grille
								}
								.onAppear {
									viewModel.loadMoreDataIfNeeded(currentItem: user)
								}
							}
						}
					}
				}
			}
			.navigationTitle("Users")
				.toolbar { //redondance pour chacun des cas du pickers donc descendu pour un effet global
				 ToolbarItem(placement: .navigationBarTrailing) {
					 Picker(selection: $viewModel.isGridView, label: Text("Display")) {
						 Image(systemName: "rectangle.grid.1x2.fill")
							 .tag(true)
							 .accessibilityLabel(Text("Grid view"))
						 Image(systemName: "list.bullet")
							 .tag(false)
							 .accessibilityLabel(Text("List view"))
					 }
					 .pickerStyle(SegmentedPickerStyle())
				 }
				 ToolbarItem(placement: .navigationBarTrailing) {
					 Button(action: {
						 viewModel.reloadUsers() 
					 }) {
						 Image(systemName: "arrow.clockwise")
							 .imageScale(.large)
					 }
				 }
			 }
			.onAppear {
				viewModel.fetchUsers()
			}
			
		}
	}
}

//struct UserListView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserListView()
//    }
//}
