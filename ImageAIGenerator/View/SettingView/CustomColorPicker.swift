

import SwiftUI
struct CustomColorPicker: View {
    
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @State var colors: [UIColor]
    
    var completion: (Color) -> ()
    var showWarning: () -> ()
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack(alignment: .center, spacing: 20){
                ForEach(0..<colors.count) { index in
                    ZStack {
                        Button(action: {
//                            if !settingsViewModel.isPremium && index > 0 {
//                                showWarning()
//                            }else{
                                completion(Color(colors[index]))
//                            }
                        }, label: {
                            ZStack {
                                Circle()
                                    .fill(Color(self.colors[index]))
                                    .frame(width: 30, height: 30, alignment: .center)
                                
//                                if !settingsViewModel.isPremium && index > 0 {
//                                    Image(systemName: "lock.fill")
//                                        .foregroundColor(.white)
//                                }
                                
                            }
                        })
                    }.frame(width: 36, height: 36, alignment: .center)
                }
                
            }.padding(8)
        }
    }
}

struct CustomColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomColorPicker(colors: [.systemBlue, .systemRed], completion: { color in
            
        }, showWarning: {})
        .previewLayout(.sizeThatFits)
    }
}

