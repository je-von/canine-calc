import SwiftUI
import LiquidShape
import LottieUI
import SwiftUIVisualEffects
enum Step: CaseIterable, Equatable{
    case name, age, weight, reproductiveStatus, activityLevel, bodyConditionScore, foodKcalPerCup, eatingFrequency, result
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
    // TODO: validate input
    @State private var nameTxt: String = ""
    @State private var currentStep: Step = .name
    @State private var weightTxt = 5.0
    @State private var ageInMonths = 24
    @State private var isSterilized = "No"
    @State private var activityLevel = "Inactive"
    @State private var bodyConditionScore = "Ideal"
    @State private var isModalVisible = false
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color("SecondaryDark"))
        UISegmentedControl.appearance().backgroundColor = .gray
        UISegmentedControl.appearance().setTitleTextAttributes([.font : UIFont(name: "Take Coffee", size: 32) as Any], for: .normal)
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
                        FormView(text: "What's your dog's name ?", isModalVisible: $isModalVisible, field: AnyView(
                            TextField("", text: $nameTxt)
                                .font(Font.custom("Take Coffee", size: 24))
                                .padding() 
                                .foregroundColor(.white)
                                .colorMultiply(Color("SecondaryDark"))
                                .border(Color("SecondaryDark"), width: 8)
                                .cornerRadius(12, antialiased: true)
                        ))
                    } else if currentStep == .age {
                        FormView(text: "How old is your dog ?", isModalVisible: $isModalVisible, field: AnyView(
                            Stepper(
                                onIncrement: {
                                    if ageInMonths <= 11 {
                                        ageInMonths += 1
                                    } else {
                                        ageInMonths += 12
                                    }
                                },
                                onDecrement: {
                                    // puppies stop breastfeed at 10 weeks
                                    guard ageInMonths > 3 else { return }
                                    
                                    if ageInMonths <= 12 {
                                        ageInMonths -= 1
                                    } else {
                                        ageInMonths -= 12
                                    }
                                },
                                label: {
                                    if ageInMonths < 12 {
                                        Text("\(ageInMonths) months old")
                                    } else {
                                        Text("\(ageInMonths / 12) year\(ageInMonths > 12 ? "s" : "") old")
                                    }
                                })
                            .font(Font.custom("Take Coffee", size: 24))
                            .padding()
                            .foregroundColor(.white)
                            .colorMultiply(Color("SecondaryDark"))
                            .border(Color("SecondaryDark"), width: 8)
                            
                            .cornerRadius(12, antialiased: true)
                        )) 
                        
                    } else if currentStep == .weight {
                        FormView(text: "What's your dog's weight ?", isModalVisible: $isModalVisible, field: AnyView(
                            Stepper(String(format: "%.1f kg", weightTxt), value: $weightTxt, in: 1...80, step: 0.1)
                                .font(Font.custom("Take Coffee", size: 24))
                                .padding()
                                .foregroundColor(.white)
                                .colorMultiply(Color("SecondaryDark"))
                                .border(Color("SecondaryDark"), width: 8)
                            
                                .cornerRadius(12, antialiased: true)
                        )) 
                        
                    } else if currentStep == .reproductiveStatus {
                        FormView(text: "Is your dog sterilized ?", isModalVisible: $isModalVisible, field: AnyView(
                            Picker("", selection: $isSterilized) {
                                ForEach(["Yes", "No"], id: \.self){
                                    Text($0)
                                }
                            }
                                .pickerStyle(SegmentedPickerStyle())
                                .frame(height: 60)
                        ))
                        
                        
                    } else if currentStep == .activityLevel {
                        FormView(text: "How active is your dog ?", isModalVisible: $isModalVisible, field: AnyView(
                            Picker("", selection: $activityLevel) {
                                ForEach(["Inactive", "Moderate", "Active", "Energetic"], id: \.self){
                                    Text($0)
                                }
                            }
                                .pickerStyle(SegmentedPickerStyle())
                                .frame(height: 60)
                        ))
                        
                        
                    } else if currentStep == .bodyConditionScore {
                        FormView(text: "What is your dog Body Condition Score ?", isModalVisible: $isModalVisible, field: AnyView(
                            Picker("", selection: $bodyConditionScore) {
                                ForEach(["Underweight", "Ideal", "Overweight"], id: \.self){
                                    Text($0)
                                }
                            }
                                .pickerStyle(SegmentedPickerStyle())
                                .frame(height: 60)
                        ))
                    }
                    HStack{
                        if currentStep != .name {
                            Button{
                                if currentStep == .bodyConditionScore {
                                    var rer = 70.0 * pow(weightTxt, 0.75)
                                    
                                    var signalmentFactor = isSterilized == "Yes" ? 1.6 : 1.8
                                    
                                    
                                }
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
                            .opacity(currentStep == .name || currentStep == .result ? 1 : 0)
                        LottieView(state: LUStateData(type: .name("think", .main), speed: 0.5, loopMode: .loop))
                            .opacity(currentStep != .name && currentStep != .result ? 1 : 0)
                            .scaleEffect(1.05)
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
