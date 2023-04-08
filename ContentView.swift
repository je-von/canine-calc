import SwiftUI
import LiquidShape
import LottieUI
import SwiftUIVisualEffects
enum Step: CaseIterable, Equatable{
    case name, age, weight, reproductiveStatus, activityLevel, bodyConditionScore, result, food, resultWithFood
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
    // TODO: validate input, replace "your dog" with dog's name
    @State private var nameTxt: String = ""
    @State private var currentStep: Step = .name
    @State private var weightTxt = 5.0
    @State private var ageInMonths = 24
    @State private var isSterilized = "No"
    @State private var activityLevel = "Inactive"
    @State private var bodyCondition = 5.0
    @State private var MER = 0.0
    @State private var idealWeight = 0.0
    @State private var foodKcal = 4.5
    @State private var foodFrequency = 2.0
    @State private var idealFoodGram = 0.0
    @State private var isModalVisible = false
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color("SecondaryDark"))
        UISegmentedControl.appearance().backgroundColor = .gray
        UISegmentedControl.appearance().setTitleTextAttributes([.font : UIFont(name: "Take Coffee", size: 32) as Any], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor.white], for: .selected)
        
        UISegmentedControl.appearance().setContentHuggingPriority(.defaultLow, for: .vertical)
        
        UISlider.appearance().setThumbImage(UIImage(systemName: "pawprint.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .regular, scale: .default )), for: .normal)
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
                        FormView(text: "What is your dog's Body Condition Score ?", isModalVisible: $isModalVisible, field: AnyView(
                            VStack{
                                Slider(value: $bodyCondition, in: 1...9, step: 1)
                                    .accentColor(Color("SecondaryDark"))
                                
                                HStack {
                                    ForEach(1...9, id: \.self) { number in
                                        Text("\(number)")
                                            .font(Font.custom("Take Coffee", size: 24))
                                            .foregroundColor(Color("SecondaryDark"))
                                        if number != 9 {
                                            Spacer()
                                        }
                                    }
                                }
                                
                                HStack {
                                    Text("Underweight")
                                    Spacer()
                                    Text("Ideal")
                                    Spacer()
                                    Text("Overweight")
                                }
                                .font(Font.custom("Take Coffee", size: 24))
                                .foregroundColor(Color("SecondaryDark"))
                                .padding(.top, 5)
                            }
                        ))
                    } else if currentStep == .result {
                        HStack{
                            FormView(text: "\(nameTxt.capitalized)'s daily calorie needs", isModalVisible: $isModalVisible, field: AnyView(
                                Text("\(Int(MER)) kcal/day")
                                    .font(Font.custom("Take Coffee", size: 48))
                                    .foregroundColor(Color("PrimaryDark"))
                                    .padding(.top, 3)
                            ))
                            Spacer()
                            FormView(text: "\(nameTxt.capitalized)'s ideal weight", isModalVisible: $isModalVisible, field: AnyView(
                                Text("\(Int(idealWeight)) kg")
                                    .font(Font.custom("Take Coffee", size: 48))
                                    .foregroundColor(Color("PrimaryDark"))
                                    .padding(.top, 3)
                            ))
                        }
                    } else if currentStep == .food {
                        HStack{
                            FormView(text: "What's your dog's food kcal/gram ?", isModalVisible: $isModalVisible, field: AnyView(
                                Stepper(String(format: "%.2f kcal/gram", foodKcal), value: $foodKcal, in: 0.1...100, step: 0.05)
                                    .font(Font.custom("Take Coffee", size: 24))
                                    .padding()
                                    .foregroundColor(.white)
                                    .colorMultiply(Color("SecondaryDark"))
                                    .border(Color("SecondaryDark"), width: 8)
                                
                                    .cornerRadius(12, antialiased: true)
                            ))
                            Spacer()
                            FormView(text: "How frequent does your dog eat ?", isModalVisible: $isModalVisible, field: AnyView(
                                Stepper(String(format: "%.0f meals/day", foodFrequency), value: $foodFrequency, in: 1...10, step: 1)
                                    .font(Font.custom("Take Coffee", size: 24))
                                    .padding()
                                    .foregroundColor(.white)
                                    .colorMultiply(Color("SecondaryDark"))
                                    .border(Color("SecondaryDark"), width: 8)
                                
                                    .cornerRadius(12, antialiased: true)
                            ))
                        }
                    } else if currentStep == .resultWithFood {
                        FormView(text: "You should feed \(nameTxt.capitalized) around", isModalVisible: $isModalVisible, field: AnyView(
                            Text("\(Int(idealFoodGram)) gram/meal")
                                .font(Font.custom("Take Coffee", size: 48))
                                .foregroundColor(Color("PrimaryDark"))
                                .padding(.top, 3)
                        ))
                    }
                    HStack{
                        if currentStep == .resultWithFood{
                            Spacer()
                        }
                        if currentStep != .name {
                            Button{
                                guard currentStep != .name else { return }
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
                            Button{
                                withAnimation{
                                    currentStep = .name
                                }
                            } label: {
                                Image(systemName: "gobackward")
                                    .font(.system(size: 28))
                                    .padding(.vertical)
                                    .padding(.horizontal, 20)
                                    .background(.gray)
                                    .cornerRadius(12)
                                    .foregroundColor(Color("PrimaryLight"))
                            }
                            Spacer()
                        }
                        if currentStep != .resultWithFood {
                            Button{
                                guard !nameTxt.isEmpty else { return }
                                
                                if currentStep == .bodyConditionScore {
                                    var RER = 70.0 * pow(weightTxt, 0.75)
                                    
                                    var signalmentFactor = isSterilized == "Yes" ? 1.6 : 1.8
                                    
                                    var ageFactor: Double
                                    if ageInMonths <= 4 {
                                        ageFactor = 3
                                    } else if ageInMonths <= 7 {
                                        ageFactor = 2
                                    } else if ageInMonths <= 12 {
                                        ageFactor = 1.6
                                    } else if ageInMonths <= 7 * 12 {
                                        ageFactor = 1
                                    } else {
                                        ageFactor = 0.8
                                    }
                                    
                                    var activityLevelFactor: Double
                                    if activityLevel == "Inactive" {
                                        activityLevelFactor = 1
                                    } else if activityLevel == "Moderate" {
                                        activityLevelFactor = 1.2
                                    } else if activityLevel == "Active" {
                                        activityLevelFactor = 1.4
                                    } else {
                                        activityLevelFactor = 1.6
                                    }
                                    
                                    var bodyConditionScoreFactor: Double
                                    if bodyCondition < 4 {
                                        bodyConditionScoreFactor = 1.2
                                    } else if bodyCondition < 6 {
                                        bodyConditionScoreFactor = 1
                                    } else {
                                        bodyConditionScoreFactor = 0.8
                                    }
                                    
                                    MER = RER * signalmentFactor * ageFactor * activityLevelFactor * bodyConditionScoreFactor
                                    
                                    
                                    idealWeight = (100 / ((bodyCondition - 5) * 10 + 100)) * weightTxt
                                } else if currentStep == .food {
                                    idealFoodGram = (MER / foodKcal) / foodFrequency
                                }
                                
                                withAnimation{
                                    currentStep = currentStep.next()
                                }
                            } label: {
                                Text(currentStep == .name ? "Start" : "Next")
                                    .font(Font.custom("Take Coffee", size: 32))
                                    .bold()
                                    .padding(.vertical)
                                    .padding(.horizontal, 50)
                                    .background(nameTxt.isEmpty ? .gray : Color("PrimaryDark"))
                                    .cornerRadius(12)
                                    .foregroundColor(Color("PrimaryLight"))
                            }
                        }
                        
                        
                    }
//                    .border(.red)
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
                        VStack{
                            if currentStep == .result {
                                TypewriterText(finalText: "Here are the results! If you need help calculating the right amount of food to fulfill the needed calories, click Next!")
                            } else {
                                TypewriterText(finalText: "I'm here to help you calculate your dog's daily calories for a wag-tastic, healthy doggo!!")
                            }
                            
                        }
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
