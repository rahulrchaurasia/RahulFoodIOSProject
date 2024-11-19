struct CapsuleButtonStyle: ButtonStyle {
    
    var bgColor: Color = .teal
    var textColor: Color = .white
    var hasBorder: Bool = false
    
    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        configuration.label
            .foregroundColor(textColor)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Capsule().fill(bgColor))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .overlay(
                Capsule()
                    .stroke(Color.gray, lineWidth: hasBorder ? 1 : 0)
            )
    }
}
