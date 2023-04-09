import SwiftUI
struct TypewriterText: View {
    @State private var text: String = ""
    let finalText: String
//    let onFinish: () -> Void
//    @Binding var hasFinished: Bool
    
    var body: some View {
        Text(text)
            .onAppear{
//                hasFinished = false
                typeWriter()
            }
    }
    
    func typeWriter(at position: Int = 0) {
        if position == 0 {
            text = ""
        }
        if position < finalText.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) {
                text.append(finalText[position])
                typeWriter(at: position + 1)
            }
        } else {
//            withAnimation{
//                onFinish()
//            }
        }
    }
}

//struct TypewriterText_Previews: PreviewProvider {
//    static var previews: some View {
//        TypewriterText(finalText: "Hello world", hasFinished: .constant(false))
//    }
//}

extension String {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
