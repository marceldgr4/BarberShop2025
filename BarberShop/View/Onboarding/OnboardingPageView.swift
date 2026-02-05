//
//  OnboardingPageView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 18/01/26.
//

import SwiftUI

struct OnboardingPageView: View {

    let page: OnboardingPage
    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: 2) {
            Spacer()

            // MARK: - Icon/Image
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.4))
                    .frame(width: 280, height: 280)
                    .scaleEffect(isAnimating ? 1.0 : 0.8)
                    .opacity(isAnimating ? 1.0 : 0.5)

                Circle()
                    .fill(Color.white.opacity(0.15))
                    .frame(width: 220, height: 220)
                    .scaleEffect(isAnimating ? 1.0 : 0.9)

                Image(systemName: page.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 140)
                    .foregroundColor(.white)
                    .scaleEffect(isAnimating ? 1.0 : 0.5)
            }
            .padding(.bottom, 70)

            // MARK: - Content
            VStack(spacing: 25) {
                Text(page.title)
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .shadow(color: .black.opacity(0.3), radius: 5, y: 2)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .offset(y: isAnimating ? 0 : 20)

                Text(page.description)
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(.white.opacity(0.95))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .offset(y: isAnimating ? 0 : 25)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [page.backgroundColor, page.backgroundColor.opacity(0.5)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                isAnimating = true
            }
        }

    }

}

// MARK: - Preview
#Preview {
    OnboardingPageView(page: OnboardingPage.pages[0])
}
