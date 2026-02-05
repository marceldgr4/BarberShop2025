//
//  OnboardingExtesion.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 18/01/26.
//

//

import Foundation
import SwiftUI

// MARK: - Animated Button Style
struct OnboardingButtonStyle: ButtonStyle {
    let isEnabled: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.5), value: configuration.isPressed)
    }
}

// MARK: - Page Transition Modifier
struct PageTransition: ViewModifier {
    let isActive: Bool

    func body(content: Content) -> some View {
        content
            .scaleEffect(isActive ? 1.0 : 0.9)
            .opacity(isActive ? 1.0 : 0.0)
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isActive)
    }
}

extension View {
    func pageTransition(isActive: Bool) -> some View {
        modifier(PageTransition(isActive: isActive))
    }
}

// MARK: - Particle Effect (Optional Enhancement)
struct ParticleView: View {
    @State private var particles: [Particle] = []
    let color: Color

    struct Particle: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
        var scale: CGFloat
        var opacity: Double
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles) { particle in
                    Circle()
                        .fill(color.opacity(particle.opacity))
                        .frame(width: 4 * particle.scale, height: 4 * particle.scale)
                        .position(x: particle.x, y: particle.y)
                }
            }
            .onAppear {
                startAnimation(in: geometry.size)
            }
        }
    }

    private func startAnimation(in size: CGSize) {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            let newParticle = Particle(
                x: CGFloat.random(in: 0...size.width),
                y: CGFloat.random(in: 0...size.height),
                scale: CGFloat.random(in: 0.5...1.5),
                opacity: Double.random(in: 0.3...0.7)
            )
            particles.append(newParticle)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                particles.removeAll { $0.id == newParticle.id }
            }
        }
    }
}

// MARK: - Enhanced Onboarding Page with Particles
struct EnhancedOnboardingPageView: View {
    let page: OnboardingPage
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            // Background particles
            ParticleView(color: .white)
                .opacity(0.6)
                .allowsHitTesting(false)

            VStack(spacing: 0) {
                Spacer()

                // Icon with glow effect
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 280, height: 280)
                        .blur(radius: 10)
                        .scaleEffect(isAnimating ? 1.1 : 0.9)
                        .opacity(isAnimating ? 0.8 : 0.4)

                    Circle()
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 220, height: 220)
                        .scaleEffect(isAnimating ? 1.0 : 0.9)

                    Image(systemName: page.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.white)
                        .scaleEffect(isAnimating ? 1.0 : 0.5)
                        .shadow(color: .white.opacity(0.5), radius: 20)
                }
                .padding(.bottom, 60)

                // Content
                VStack(spacing: 20) {
                    Text(page.title)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .shadow(color: .black.opacity(0.3), radius: 5)
                        .opacity(isAnimating ? 1.0 : 0.0)
                        .offset(y: isAnimating ? 0 : 30)

                    Text(page.description)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.white.opacity(0.95))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .opacity(isAnimating ? 1.0 : 0.0)
                        .offset(y: isAnimating ? 0 : 30)
                }

                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [page.backgroundColor, page.backgroundColor.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .onAppear {
            withAnimation(.spring(response: 1.0, dampingFraction: 0.7)) {
                isAnimating = true
            }
        }
    }
}

// MARK: - Onboarding Progress Bar
struct OnboardingProgressBar: View {
    let currentPage: Int
    let totalPages: Int

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                Rectangle()
                    .fill(Color.black.opacity(0.4))
                    .frame(height: 4)
                    .cornerRadius(5)

                // Progress
                Rectangle()
                    .fill(Color.brandAccent)
                    .frame(
                        width: geometry.size.width * CGFloat(currentPage + 1) / CGFloat(totalPages),
                        height: 9
                    )
                    .cornerRadius(5)
                    .animation(.spring(response: 0.5), value: currentPage)
            }
        }
        .frame(height: 4)
    }
}
#Preview("Onboarding Page - Welcome") {
    EnhancedOnboardingPageView(
        page: OnboardingPage(
            title: "sparkles",
            description: "Bienvenido",
            imageName: "Descubre la mejor experiencia de barbería",
            backgroundColor: Color(red: 0.0, green: 0.4, blue: 0.8), showSkip: false
        ))
}

#Preview("Progress Bar - Start") {
    OnboardingProgressBar(currentPage: 0, totalPages: 4)
}

#Preview("Progress Bar - Middle") {
    OnboardingProgressBar(currentPage: 2, totalPages: 4)

}

#Preview("Progress Bar - End") {
    OnboardingProgressBar(currentPage: 3, totalPages: 4)

}
