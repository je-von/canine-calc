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
    @State private var modalContent: AnyView?
    @State private var errorMessage: String = ""
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
                    amplitude: 25,
                    contentMode: .contain
                )
                .frame(height: 130)
                .padding(.bottom, -20)
                .foregroundColor(.gray)
            }
            .frame(minHeight: 0, maxHeight: .infinity, alignment: .bottom)
            VStack{
                HStack{
                    Text("Welcome to ")
                        .foregroundColor(Color("SecondaryDark"))
                    + 
                    Text("CanineCalc ")
                        .foregroundColor(Color("PrimaryDark"))
                    +
                    Text("!")
                        .foregroundColor(Color("SecondaryDark"))
                }.font(Font.custom("Take Coffee", size: 48))
                
                
                VStack(spacing: 20){
                    if currentStep == .name {
                        FormView(text: "What's your precious little pup's name ?", field: AnyView(
                            TextField("", text: $nameTxt)
                                .font(Font.custom("Take Coffee", size: 24))
                                .padding() 
                                .foregroundColor(.white)
                                .colorMultiply(Color("SecondaryDark"))
                                .border(Color("SecondaryDark"), width: 8)
                                .cornerRadius(12, antialiased: true)
                        ))
                    } else if currentStep == .age {
                        FormView(text: "How old is \(nameTxt.capitalized) ?", field: AnyView(
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
                        FormView(text: "What's \(nameTxt.capitalized)'s weight ?", field: AnyView(
                            Stepper(String(format: "%.1f kg", weightTxt), value: $weightTxt, in: 1...80, step: 0.1)
                                .font(Font.custom("Take Coffee", size: 24))
                                .padding()
                                .foregroundColor(.white)
                                .colorMultiply(Color("SecondaryDark"))
                                .border(Color("SecondaryDark"), width: 8)
                            
                                .cornerRadius(12, antialiased: true)
                        )) 
                        
                    } else if currentStep == .reproductiveStatus {
                        FormView(text: "Is \(nameTxt.capitalized) sterilized ?", field: AnyView(
                            Picker("", selection: $isSterilized) {
                                ForEach(["Yes", "No"], id: \.self){
                                    Text($0)
                                }
                            }
                                .pickerStyle(SegmentedPickerStyle())
                                .frame(height: 60)
                        ))
                        
                        
                    } else if currentStep == .activityLevel {
                        FormView(text: "How active is \(nameTxt.capitalized) ?", field: AnyView(
                            Picker("", selection: $activityLevel) {
                                ForEach(["Inactive", "Moderate", "Active", "Energetic"], id: \.self){
                                    Text($0)
                                }
                            }
                                .pickerStyle(SegmentedPickerStyle())
                                .frame(height: 60)
                        ))
                        
                        
                    } else if currentStep == .bodyConditionScore {
                        FormView(text: "What is \(nameTxt.capitalized)'s Body Condition Score ?", field: AnyView(
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
                            FormView(text: "\(nameTxt.capitalized)'s daily calorie needs", field: AnyView(
                                Text("\(Int(MER)) kcal/day")
                                    .font(Font.custom("Take Coffee", size: 48))
                                    .foregroundColor(Color("PrimaryDark"))
                                    .padding(.top, 3)
                            ))
                            Spacer()
                            FormView(text: "\(nameTxt.capitalized)'s ideal weight", field: AnyView(
                                Text("\(Int(idealWeight)) kg")
                                    .font(Font.custom("Take Coffee", size: 48))
                                    .foregroundColor(Color("PrimaryDark"))
                                    .padding(.top, 3)
                            ))
                        }
                    } else if currentStep == .food {
                        HStack{
                            FormView(text: "What's \(nameTxt.capitalized)'s food kcal/gram ?", field: AnyView(
                                Stepper(String(format: "%.2f kcal/gram", foodKcal), value: $foodKcal, in: 0.1...100, step: 0.05)
                                    .font(Font.custom("Take Coffee", size: 24))
                                    .padding()
                                    .foregroundColor(.white)
                                    .colorMultiply(Color("SecondaryDark"))
                                    .border(Color("SecondaryDark"), width: 8)
                                
                                    .cornerRadius(12, antialiased: true)
                            ))
                            Spacer()
                            FormView(text: "How frequent does \(nameTxt.capitalized) eat ?", field: AnyView(
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
                        FormView(text: "You should feed \(nameTxt.capitalized) around", field: AnyView(
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
                                if nameTxt.isEmpty { 
                                    errorMessage = "Pretty please, tell us your doggie's name first! It's just to add a dash of cuteness and make it extra special!"
                                    return 
                                }
                                errorMessage = ""
                                
                                if currentStep == .bodyConditionScore {
                                    MER = getDailyCalorie()
                                    idealWeight = getIdealWeight()
                                } else if currentStep == .food {
                                    idealFoodGram = getIdealFoodGram()
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
                    
                    if currentStep == .resultWithFood{
                        Button{
                            showModal(AnyView(
                                VStack{
                                    Text("Why is it important")
                                }
                            ))
                        } label: {
                            Text("Why is it important?")
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
                    Spacer()
                    VStack(spacing: 0){
                        HStack{
                            Text("Hi, I'm ")
                                .font(Font.custom("Take Coffee", size: 32))
                                .foregroundColor(Color("SecondaryDark"))
                            + 
                            Text("Kisses ")
                                .font(Font.custom("Take Coffee", size: 32))
                                .foregroundColor(Color("PrimaryDark"))
                            +
                            Text("!")
                                .font(Font.custom("Take Coffee", size: 32))
                                .foregroundColor(Color("SecondaryDark"))
                        }
                        .padding(.top, 100)
                        VStack{
                            if !errorMessage.isEmpty {
                                TypewriterText(finalText: errorMessage)
                            } else if currentStep == .age{
                                TypewriterText(finalText: "Dog's calorie needs vary by age, with puppies needing higher levels for growth and development than adult dogs.")
                            } else if currentStep == .weight {
                                TypewriterText(finalText: "A dog's weight is crucial for calculating their calorie requirements and achieving their ideal weight.")
                            } else if currentStep == .reproductiveStatus {
                                TypewriterText(finalText: "Intact dogs need more calories for reproduction, neutered dogs require fewer due to hormonal changes affecting metabolism and weight.")
                            } else if currentStep == .activityLevel {
                                TypewriterText(finalText: "A dog's playfulness and energy level affect their calorie needs, with more active pups needing extra fuel to keep up with their playful antics!")
                            } else if currentStep == .bodyConditionScore {
                                TypewriterText(finalText: "Gently check your dog and feel their ribs and vertebrae. Need guide? Click the Paw below!", showModal: {
                                    showModal(AnyView(
                                        VStack{
                                            Image("bcs")
                                                .resizable()
                                                .scaledToFit()
                                            Text("Source: Nestlé Purina PetCare")
                                        }
                                    ))
                                })
                            } else if currentStep == .result {
                                TypewriterText(finalText: "Results are up! Need help with food calculations for the right calories? Click Next for a paw-some solution!")
                            } else if currentStep == .food {
                                TypewriterText(finalText: "To serve the paw-fect portion for your pup, check the kcal/gram listed on your dog's food label! Need example? Click the Paw!", showModal: {
                                    showModal(AnyView(
                                        VStack{
                                            Image("food_label")
                                                .resizable()
                                                .scaledToFit()
                                            Text("If the units shown is not \"kcal/g\", please convert it first!")
                                                .font(Font.custom("Take Coffee", size: 24))
                                                .foregroundColor(Color("SecondaryDark"))
                                            Text("Source: Royal Canin, KIN Dog Food, Pedigree Petfoods")
                                        }
                                    ))
                                })
                                
                            } else if currentStep == .resultWithFood {
                                TypewriterText(finalText: "Ta-da! Final results in! Thanks for using my services! Feed your pup right for a happy, healthy journey!")
                            } else {
                                TypewriterText(finalText: "I'm here to help you calculate your dog's daily calories for a wag-tastic, healthy doggo!!")
                            }
                            
                        }
                        .font(Font.custom("Take Coffee", size: 28))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("SecondaryDark"))
                        .padding(.bottom, -10)
                        .padding(.leading, 20)
                        .padding(.trailing, 40)
                    }
                    .frame(width: 500)
                    .background(Image("bubble")
                        .resizable()
                        .scaledToFill()
                        .padding(.top, -100)
                        .scaleEffect(CGSize(width: -1.1, height: -1))
                    )
                    .padding(8)
                    
                    ZStack{
                        LottieView(state: LUStateData(type: .name("kisses", .main), speed: 0.5, loopMode: .loop))
                            .zIndex(50)
                    }
                    .scaledToFill()
                    .frame(width: 300, height: 600)
                    .padding(.vertical, -40)
//                    .frame(width: 300)
                    .zIndex(50)
                    Spacer()
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
                VStack(alignment: .trailing){
                    Button{
                        withAnimation{
                            isModalVisible = false
                        }
                    }label: {
                        Image(systemName: "xmark")
                            .foregroundColor(Color("SecondaryDark"))
                    }
                    .padding([.top, .trailing])
                    modalContent
                        .padding() 
                }
                .background(BlurEffect()).blurEffectStyle(.systemMaterialLight)
                .cornerRadius(20, antialiased: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(20)
            }
        }
        
        .background(Color("PrimaryLight"))
        
    }
    
    func showModal(_ content: AnyView){
        modalContent = content
        withAnimation{
            isModalVisible = true            
        }
    }
    
    func getDailyCalorie() -> Double {
        let RER = 70.0 * pow(weightTxt, 0.75)
        
        let signalmentFactor = isSterilized == "Yes" ? 1.6 : 1.8
        
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
        
        return RER * signalmentFactor * ageFactor * activityLevelFactor * bodyConditionScoreFactor
    }
    
    func getIdealWeight() -> Double {
        return (100 / ((bodyCondition - 5) * 10 + 100)) * weightTxt
    }
    
    func getIdealFoodGram() -> Double {
        return (MER / foodKcal) / foodFrequency
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
