import SwiftUI
import LiquidShape
import LottieUI
import SwiftUIVisualEffects
enum Step: CaseIterable, Equatable{
    case name, weight, reproductiveStatus, activityLevel, bodyConditionScore, foodKcalPerCup, eatingFrequency, result
    func next() -> Self {
        let all = Self.allCases
        let idx = all.firstIndex(of: self)!
        let next = all.index(after: idx)
        return all[next == all.endIndex ? all.startIndex : next]
    }
    func prev() -> Self {
        let all = Self.allCases
        let idx = all.firstIndex(of: self)!
        let previous = all.index(before: idx)
        return all[previous < all.startIndex ? all.index(before: all.endIndex) : previous]
    }
}
struct ContentView: View {
    @State var nameTxt: String = ""
    @State private var currentStep: Step = .name
    @State private var weightTxt = 1
    @State private var isSterilized = "No"
    
    @State private var isModalVisible = false
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color("SecondaryDark"))
        UISegmentedControl.appearance().backgroundColor = .gray
        //        
        //        UISegmentedControl.appearance().setTitleTextAttributes([.font : UIFont(name: "Take Coffee", size: 32)], for: .highlighted)
        UISegmentedControl.appearance().setTitleTextAttributes([.font : UIFont(name: "Take Coffee", size: 32) as Any], for: .normal)
        
        //        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor.cyan], for: .highlighted)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor.white], for: .selected)
        
        UISegmentedControl.appearance().setContentHuggingPriority(.defaultLow, for: .vertical)
        
    }
    
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
                Text("Welcome to CanineCalc !")
                    .padding(.top)
                    .frame(maxWidth: .infinity)
                    .font(Font.custom("Take Coffee", size: 48))
                    .foregroundColor(Color("SecondaryDark"))
                
                
                VStack(spacing: 30){
                    if currentStep == .name {
                        HStack{
                            Text("What's your dog's name?")
                                .font(Font.custom("Take Coffee", size: 32))
                                .foregroundColor(Color("SecondaryDark")) 
                            Button{
                                withAnimation{
                                    isModalVisible = true
                                }
                            }label: {
                                Image(systemName: "info.circle")
                                    .foregroundColor(Color("SecondaryDark"))
                            }
                        }
                        TextField("", text: $nameTxt)
                            .font(Font.custom("Take Coffee", size: 24))
                            .padding() 
                            .foregroundColor(.white)
                            .colorMultiply(Color("SecondaryDark"))
                            .border(Color("SecondaryDark"), width: 8)
                            .cornerRadius(12, antialiased: true)
                    } else if currentStep == .weight {
                        Text("Your Dog's Weight:")
                            .font(Font.custom("Take Coffee", size: 32))
                            .foregroundColor(Color("SecondaryDark"))  
                        Stepper("\(weightTxt) kg", value: $weightTxt, in: 1...80, step: 1)
                            .font(Font.custom("Take Coffee", size: 24))
                            .padding()
                            .border(Color("SecondaryDark"), width: 8)
                            .foregroundColor(Color("SecondaryDark"))
                            .cornerRadius(12, antialiased: true)
                    } else if currentStep == .reproductiveStatus {
                        Text("Is Your Dog Sterilized?")
                            .font(Font.custom("Take Coffee", size: 32))
                            .foregroundColor(Color("SecondaryDark"))  
                        Picker("", selection: $isSterilized) {
                            ForEach(["Yes", "No"], id: \.self){
                                Text($0)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(height: 60)
                        
                    }
                    HStack{
                        if currentStep != .name {
                            Button{
                                withAnimation{
                                    currentStep = currentStep.prev()
                                }
                            } label: {
                                Text("Back")
                                    .font(Font.custom("Take Coffee", size: 32))
                                    .bold()
                                    .padding(.vertical)
                                    .padding(.horizontal, 50)
                                    .background(.gray)
                                    .cornerRadius(12)
                                    .foregroundColor(Color("PrimaryLight"))
                            }
                            Spacer()
                        }
                        Button{
                            withAnimation{
                                currentStep = currentStep.next()
                            }
                        } label: {
                            Text(currentStep == .name ? "Start" : "Next")
                                .font(Font.custom("Take Coffee", size: 32))
                                .bold()
                                .padding(.vertical)
                                .padding(.horizontal, 50)
                                .background(Color("PrimaryDark"))
                                .cornerRadius(12)
                                .foregroundColor(Color("PrimaryLight"))
                        }
                    }
                }
                .frame(maxHeight: .infinity)
                .padding(.horizontal, 32)
                HStack{
                    
                    ZStack{
                        LottieView(state: LUStateData(type: .name("wave", .main), speed: 0.5, loopMode: .loop))
                            .zIndex(50)
                        
                        //                        .opacity(currentStep == .intro || currentStep == .win || currentStep == .lose ? 1 : 0)
                        
                        //                    LottieView(state: LUStateData(type: .name("think", .main), speed: 0.5, loopMode: .loop))
                        //                        .opacity(currentStep == .question || currentStep == .memorize ? 1 : 0)
                        
                    }
                    .scaledToFill()
                    .frame(width: 285, height: 600)
                    .padding(.vertical, -40)
                    .zIndex(50)
                    
                    
                    VStack(spacing: 0){
                        Text("Hi, I'm ")
                            .font(Font.custom("Take Coffee", size: 32))
                            .foregroundColor(Color("SecondaryDark"))
                        + 
                        Text("Bailey ")
                            .font(Font.custom("Take Coffee", size: 32))
                            .foregroundColor(Color("PrimaryDark"))
                        +
                        Text("!")
                            .font(Font.custom("Take Coffee", size: 32))
                            .foregroundColor(Color("SecondaryDark"))
                        TypewriterText(finalText: "I'm here to help you calculate your dog's daily calories for a wag-tastic, healthy doggo!!")
                            .font(Font.custom("Take Coffee", size: 32))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color("SecondaryDark"))
                            .padding(.vertical, 15)
                            .padding(.horizontal, 38)
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Image("bubble")
                        .resizable()
                        .scaledToFill()
                        .scaleEffect(CGSize(width: 1, height: -0.7))
                        .rotationEffect(.degrees(-10))
                    )
                    .padding(10)
                    
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                
            }
            .padding()
            .if(isModalVisible){ view in
                view.blurEffect()
                    .blurEffectStyle(.systemUltraThinMaterialDark)
                    .onTapGesture {
                        withAnimation{
                            isModalVisible = false
                        }
                    }
            }
            
            
            
            if isModalVisible {
                
                VStack{
                    Text("Info blablabla").foregroundColor(.black).border(.green)
                }.frame(width: 800, height:1000)
                    .background(BlurEffect()).blurEffectStyle(.systemMaterialLight)
                    .cornerRadius(20, antialiased: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            }
        }
        
        .background(Color("PrimaryLight"))
        
    }
}

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
