import SwiftUI
import LiquidShape
import LottieUI
struct ContentView: View {
    var body: some View {
        ZStack{
            TimelineView(.animation) { ctx in
                Liquid.Shape(
                    time: 0.5 * ctx.date.timeIntervalSince1970,
                    amplitude: 20,
                    contentMode: .contain
                )
                .frame(height: 100)
                .foregroundColor(Color("PrimaryDark"))
            }
            .frame(minHeight: 0, maxHeight: .infinity, alignment: .bottom)
            VStack{
                Text("Hi, I'm Bailey!")
                    .frame(maxWidth: .infinity)
                    .font(Font.custom("Take Coffee", size: 48))
                    .foregroundColor(Color("SecondaryDark"))

                Spacer()
                VStack{
                    ZStack{
                        LottieView(state: LUStateData(type: .name("wave", .main), speed: 0.5, loopMode: .loop))
                        //                        .opacity(currentStep == .intro || currentStep == .win || currentStep == .lose ? 1 : 0)
                        
                        //                    LottieView(state: LUStateData(type: .name("think", .main), speed: 0.5, loopMode: .loop))
                        //                        .opacity(currentStep == .question || currentStep == .memorize ? 1 : 0)
                        
                    }
                    .scaledToFill()
                    .frame(width: 400, height: UIScreen.main.bounds.height * 0.65)
                    //                .frame(maxHeight: .infinity)
                    .padding(.top, -20)
                    .padding(.bottom, -40)
                    .border(.green, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .border(.red, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                
            }
            
            .padding()
        }
        
        .background(Color("PrimaryLight"))
        
    }
}
