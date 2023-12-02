
import SwiftUI

struct XMarkButton: View {
    let onTap: () -> ()
    var body: some View {
        Button {
            onTap()
        } label: {
            Image.xmarkCircleIcon
                .resizable()
                .frame(width: 35, height: 35)
//                .foregroundStyle(Color.white,
//                                 Color.appTheme)
        }
    }
}

struct XMarkButton_Previews: PreviewProvider {
    static var previews: some View {
        XMarkButton(onTap: {})
    }
}
