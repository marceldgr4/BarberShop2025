//
//  OnboardingView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 18/01/26.
//

import SwiftUI
import UserNotifications
import CoreLocation


struct OnboardingView: View {
    @Binding var isFirstLaunch: Bool
    @State  var currentPage = 0
    @State  var showPermissionAlert = false
    @State  var permissionType: PermissionType?
    @State private var dragOffset: CGFloat = 0
    
    let pages = OnboardingPage.pages
    let haptic = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    pages[currentPage].backgroundColor,
                    pages[currentPage].backgroundColor.opacity(0.7)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 0.5), value: currentPage)
            
            // Main content
            VStack {
                // Top bar with progress and skip button
                HStack {
                    OnboardingProgressBar(
                        currentPage: currentPage,
                        totalPages: pages.count
                    )
                    .frame(height: 4)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    if pages[currentPage].showSkip {
                        Button(action: skipOnboarding) {
                            Text("Skip")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule().fill(Color.white.opacity(0.2))
                                )
                        }
                        .padding(.trailing, 20)
                    }
                }
                .padding(.top, 50)
                
                Spacer()
                
                // Bottom controls
                VStack(spacing: 25) {
                    // Page indicators
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? Color.white : Color.white.opacity(0.4))
                                .frame(
                                    width: currentPage == index ? 12 : 8,
                                    height: currentPage == index ? 12 : 8
                                )
                                .overlay(
                                    Circle()
                                        .stroke(
                                            Color.white.opacity(0.5),
                                            lineWidth: currentPage == index ? 2 : 0
                                        )
                                        .frame(
                                            width: currentPage == index ? 20 : 8,
                                            height: currentPage == index ? 20 : 8
                                        )
                                )
                                .scaleEffect(currentPage == index ? 1.0 : 0.8)
                                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: currentPage)
                        }
                    }
                    .padding(.bottom, 10)
                    
                    // Main action button
                    Button(action: {
                        haptic.impactOccurred()
                        handleButtonTap()
                    }) {
                        HStack(spacing: 12) {
                            Text(buttonTitle)
                                .font(.system(size: 18, weight: .bold))
                            if currentPage < pages.count - 1 {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .bold))
                            } else {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 16, weight: .bold))
                            }
                        }
                        .foregroundColor(pages[currentPage].backgroundColor)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.15), radius: 15, y: 8)
                        )
                    }
                    .buttonStyle(OnboardingButtonStyle(isEnabled: true))
                    .padding(.horizontal, 30)
                    
                    // Back button
                    if currentPage > 0 {
                        Button(action: {
                            haptic.impactOccurred()
                            moveToPreviousPage()
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "arrow.left")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Back")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundColor(.white.opacity(0.9))
                            .padding(.vertical, 12)
                        }
                        .transition(.opacity)
                    }
                }
                .padding(.bottom, 50)
            }
            
            // TabView for pages
            TabView(selection: $currentPage) {
                ForEach(Array(pages.enumerated()), id: \.element.id) { index, page in
                    OnboardingPageView(page: page)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()
        }
        .alert("Permission Required", isPresented: $showPermissionAlert) {
            Button("Allow", role: .none) {
                handlePermission()
            }
            Button("Not Now", role: .cancel) {
                moveToNextPage()
            }
        } message: {
            Text(permissionMessage)
        }
        .onChange(of: currentPage) { _ in
            haptic.impactOccurred()
        }
    }
}

#Preview {
    OnboardingView(isFirstLaunch: .constant(true))
}
#Preview("First Page") {
    OnboardingView(isFirstLaunch: .constant(true))
}
