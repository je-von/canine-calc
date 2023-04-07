import SwiftUI
struct TypewriterText: View {
    @State private var text: String = ""
//    @Binding var hasFinished: Bool
    let finalText: String
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                text.append(finalText[position])
                typeWriter(at: position + 1)
            }
        } else {
//            withAnimation{
//                hasFinished = true
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
