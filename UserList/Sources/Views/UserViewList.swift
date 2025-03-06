import SwiftUI

struct UserViewList: View {
	@ObservedObject var viewModel : UserListViewModel
	var body: some View {
		NavigationView {
			VStack{
				if !viewModel.isGridView {
					List(viewModel.users) { user in
						ZStack {
							UserRawViewList(user: user)
							NavigationLink(destination: UserViewDetail(user: user)) {
							}
							.opacity(0)
							.listRowSpacing(15)
							.task {
								await viewModel.loadMoreDataIfNeeded(currentItem: user)
							}
						}.listRowBackground(Color.clear)
							.listRowSeparator(.hidden)
					}
				} else {
					ScrollView {
						LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing:50) {
							ForEach(viewModel.users) { user in
								NavigationLink(destination: UserViewDetail(user: user)) {
									UserSingleGridViewList( user : user ) //sous vue pour chaque élément de la grille
								}
								.task {
									await viewModel.loadMoreDataIfNeeded(currentItem: user)
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
						Task{
							await viewModel.reloadUsers()
						}
					}) {
						Image(systemName: "arrow.clockwise")
							.imageScale(.large)
					}
				}
			}
			.task {
				await viewModel.fetchUsers()
			}
			
		}
	}
}

struct UserViewList_Previews: PreviewProvider {
    static var previews: some View {
		UserViewList(viewModel: UserListViewModel(repository: UserListRepository()))
    }
}
