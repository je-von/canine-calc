import SwiftUI
struct Carousel: View{
    @State private var slideIndex = 0
    var body: some View{
        HStack{
            Button{
                withAnimation{
                    slideIndex = slideIndex > 0 ? slideIndex - 1 : slideIndex
                }
            }label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color("SecondaryDark"))
                    .font(.system(size: 32))
            }
            TabView(selection: $slideIndex) {
                VStack{
                    Image("hattie")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(8)
                    VStack(alignment: .leading){
                        Text("Meet Hattie")
                            .font(Font.custom("Take Coffee", size: 32))
                            .foregroundColor(Color("SecondaryDark"))
                        Text("The UK's heaviest dog, known as \"Hattie the Fattie\", has died from liver failure after reaching a weight of 50kg on a diet of burgers. Despite shedding half of her body weight through a strict weight-controlled diet, Hattie could not overcome her health issues.")
                            .foregroundColor(Color("SecondaryDark"))
                        .font(.system(size: 24))
                        Text("Source: dailystar.co.uk")
                    }
                }
                .tag(0)
                VStack{
                    Image("missy")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(8)
                    VStack(alignment: .trailing){
                        Text("Meet Missy")
                            .font(Font.custom("Take Coffee", size: 32))
                            .foregroundColor(Color("SecondaryDark"))
                        Text("Missy has died one month after being rescued. Officials say Missy weighed less than 30 pounds when she was brought in, but she was supposed to weigh over 50 pounds. This made her one of the most severe cases of malnutrition seen by Evansville Animal Control officials.")
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(Color("SecondaryDark"))
                        .font(.system(size: 24))
                        Text("Source: 14news.com")
                    }
                }
                .tag(1)
                VStack{
                    TypewriterText(finalText: "Feed your furry friend right, because a healthy weight can be a matter of life and death for your beloved dog - remember, prevention is key, don't wait until it's too late!")
                        .font(Font.custom("Take Coffee", size: 32))
                        .foregroundColor(Color("SecondaryDark"))
                        .multilineTextAlignment(.center)
                }
                    .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .frame(height: 750)
            Button{
                withAnimation{
                    slideIndex = slideIndex < 2 ? slideIndex + 1 : slideIndex
                }
            }label: {
                Image(systemName: "chevron.right")
                    .foregroundColor(Color("SecondaryDark"))
                    .font(.system(size: 32))
            }
        }
    }
}
