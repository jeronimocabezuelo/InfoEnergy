//
//  ClockView.swift
//  InfoEnergy
//
//  Created by Jerónimo Cabezuelo Ruiz on 22/9/24.
//

import SwiftUI

struct ClockView: View {
    var period: Period
    
    var hours: [Int] {
        switch period {
        case .flat:
            return Int.flatHours
        case .valley:
            return Int.valleyHours
        case .point:
            return Int.pointHours
        case .total:
            return Array(0..<24)
        }
    }
    
    // Definir los colores para los tres periodos
    func colorForHour(_ hour: Int) -> Color {
        let period = hour.period
        return period.color
    }
    
    var size: CGFloat = 150
    var crownWidth: CGFloat { size/7 }
    var textYOffset: CGFloat { -size/2 + crownWidth/2 }
    
    var body: some View {
        ZStack {
            ForEach(hours, id: \.self) { hour in
                // Dibuja un arco para cada hora
                let offset: Double = -6
                let startAngle = (Double(hour) + offset) * 360 / 24
                let endAngle = (Double(hour + 1) + offset + 0.01) * 360 / 24
                ClockArc(
                    startAngle: Angle(degrees: startAngle),
                    endAngle: Angle(degrees: endAngle),
                    color: colorForHour(hour),
                    crownWidth: crownWidth
                )
            }
            
            // Añadir el texto de cada hora
            ForEach(hours, id: \.self) { hour in
                let middleAngle = Angle(degrees: (Double(hour) + 0.5) * 360 / 24) // Ángulo medio para centrar el texto
                Text("\(hour)")
                    .foregroundColor(.white)
                    .rotationEffect(-middleAngle) // Rotar el texto para alinearlo con el arco
                    .offset(x: 0, y: textYOffset) // Mover el texto hacia el borde de la corona
                    .rotationEffect(Angle(degrees: middleAngle.degrees)) // Ajustar la rotación para que no gire con el arco
            }
        }
        .frame(width: size, height: size)
        .background(
            Circle()
                .fill(Color.annotationBackground.opacity(0.8))
        )
    }
}

fileprivate struct ClockArc: View {
    var startAngle: Angle
    var endAngle: Angle
    var color: Color
    
    var crownWidth: CGFloat = 20
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                let radius = min(geometry.size.width, geometry.size.height) / 2
                
                // Definir el arco
                path.addArc(center: center,
                            radius: radius,
                            startAngle: startAngle,
                            endAngle: endAngle,
                            clockwise: false)
                
                // Definir un arco interno para simular una corona continua
                path.addArc(center: center,
                            radius: radius - crownWidth, // Ajusta este valor para controlar el grosor de la corona
                            startAngle: endAngle,
                            endAngle: startAngle,
                            clockwise: true)
                
                path.closeSubpath() // Cerramos el camino para rellenar
            }
            .fill(color) // Rellenar el arco con el color correspondiente
        }
    }
}
