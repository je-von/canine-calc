import SwiftUI
import LiquidShape
import LottieUI
struct ContentView: View {
    @State var nameTxt: String = ""
    var body: some View {
        ZStack{
            TimelineView(.animation) { ctx in
                Liquid.Shape(
                    time: 0.5 * ctx.date.timeIntervalSince1970,
                    amplitude: 24,
                    contentMode: .contain
                )
                .frame(height: 100)
                .foregroundColor(Color("PrimaryDark"))
            }
            .frame(minHeight: 0, maxHeight: .infinity, alignment: .bottom)
            VStack{
                Text("Welcome to CanineCalc!")
                    .padding(.top)
                    .frame(maxWidth: .infinity)
                    .font(Font.custom("Take Coffee", size: 48))
                    .foregroundColor(Color("SecondaryDark"))
                
                
                VStack{
                    Text("Your Dog's Name:")
                        .font(Font.custom("Take Coffee", size: 32))
                        .foregroundColor(Color("SecondaryDark"))  
                    TextField("Input name", text: $nameTxt)
                        .foregroundColor(Color("SecondaryDark"))
                        .font(Font.custom("Take Coffee", size: 24))
                        .padding()
                        .border(Color("SecondaryDark"), width: 8)
                        .cornerRadius(10, antialiased: true)
                        .padding(.horizontal, 30)
                    
                }
                .frame(maxHeight: .infinity)
                .padding(.vertical, 50)
                HStack(alignment: .bottom){
                    
                    ZStack{
                        LottieView(state: LUStateData(type: .name("wave", .main), speed: 0.5, loopMode: .loop))
                            .zIndex(50)
                        
                        //                        .opacity(currentStep == .intro || currentStep == .win || currentStep == .lose ? 1 : 0)
                        
                        //                    LottieView(state: LUStateData(type: .name("think", .main), speed: 0.5, loopMode: .loop))
                        //                        .opacity(currentStep == .question || currentStep == .memorize ? 1 : 0)
                        
                    }
                    .scaledToFill()
                    .frame(width: 300, height: 600)
                    .padding(.vertical, -40)
                    .zIndex(50)
                    .border(.green, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                    ZStack{
                        Image("bubble")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .scaleEffect(CGSize(width: 1, height: -1))
                            .rotationEffect(.degrees(-10))
                            .border(.red, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                        Text("Hi, I'm Bailey!")
                            .font(Font.custom("Take Coffee", size: 32))
                            .foregroundColor(Color("SecondaryDark"))  
                    }
                    
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                
            }
            .padding()
        }
        
        .background(Color("PrimaryLight"))
        
    }
}
