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
            VStack(spacing: 0) {
                Spacer()
                
                // MARK: - Icon/Image
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
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
                        .frame(width: 120, height: 120)
                        .foregroundColor(.white)
                        .scaleEffect(isAnimating ? 1.0 : 0.5)
                }
                .padding(.bottom, 60)
                
                // MARK: - Content
                VStack(spacing: 20) {
                    Text(page.title)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .opacity(isAnimating ? 1.0 : 0.0)
                        .offset(y: isAnimating ? 0 : 20)
                    
                    Text(page.description)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .opacity(isAnimating ? 1.0 : 0.0)
                        .offset(y: isAnimating ? 0 : 20)
                }
                
                Spacer()
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
                withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                    isAnimating = true
                }
            }
        }
    }

    // MARK: - Preview
    #Preview {
        OnboardingPageView(page: OnboardingPage.pages[0])
    }
