import SwiftUI
struct TypewriterText: View {
    @State private var text: String = ""
    let finalText: String
    var showModal: (() -> Void)?
    @State private var hasFinished: Bool = false
    var body: some View {
        VStack(spacing: 0){
            ZStack (alignment: .top){
                Text(finalText).opacity(0) // to reserve height
                Text(text).onAppear{
                    typeWriter()
                }
            }
            if showModal != nil {
                Button{
                    showModal!()
                }label: {
                    Image(systemName: "pawprint.circle").font(.system(size: 40)).foregroundColor(Color("PrimaryDark"))
                }
                .padding(.top, 5)
            }
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
            withAnimation {
                hasFinished = true    
            }
            
        }
    }
}
extension String {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
