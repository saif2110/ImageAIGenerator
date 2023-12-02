import SwiftUI

struct TabBarView: View {
    var tabbarItems: [String]
 
    @State var selectedIndex = 0
 
    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(tabbarItems.indices, id: \.self) { index in
 
                        Text(tabbarItems[index])
                            .font(.subheadline)
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                            .foregroundColor(selectedIndex == index ? .white : .black)
                            .background(Capsule().foregroundColor(selectedIndex == index ? .purple : .clear))
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    selectedIndex = index
                                }
                            }
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(25)
 
        }
 
    }
}
