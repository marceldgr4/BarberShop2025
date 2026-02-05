//
//  OnboardingView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 18/01/26.
//

import CoreLocation
import SwiftUI
import UserNotifications

struct OnboardingView: View {
    @Binding var isFirstLaunch: Bool
    @State var currentPage = 0
    @State var showPermissionAlert = false
    @State var permissionType: PermissionType?
    @State private var dragOffset: CGFloat = 0

    let pages = OnboardingPage.pages
    let haptic = UIImpactFeedbackGenerator(style: .medium)

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    pages[currentPage].backgroundColor,
                    pages[currentPage].backgroundColor.opacity(0.7),
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
                    .frame(height: 5)
                    .padding(.horizontal, 20)

                    Spacer()

                    if pages[currentPage].showSkip {
                        Button(action: skipOnboarding) {
                            Text("Skip")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 5)
                                .background(
                                    Capsule()
                                        .fill(Color.black)
                                        .overlay(
                                            Capsule().stroke(Color.white.opacity(0.5), lineWidth: 1)
                                        )
                                ).shadow(color: .black, radius: 5, y: 2)
                        }
                        .padding(.trailing, 20)
                    }
                }
                .padding(.top, 20)

                Spacer()

                // Bottom controls
                VStack(spacing: 3) {
                    // Page indicators
                    HStack(spacing: 10) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? Color.black : Color.white)
                                .frame(
                                    width: currentPage == index ? 12 : 10,
                                    height: currentPage == index ? 12 : 10
                                )
                                .overlay(
                                    Circle()
                                        .stroke(
                                            Color.white.opacity(0.9),
                                            lineWidth: currentPage == index ? 2 : 0
                                        )
                                        .frame(
                                            width: currentPage == index ? 20 : 8,
                                            height: currentPage == index ? 20 : 8
                                        )
                                )
                                .shadow(color: .black, radius: 4, y: 2)
                                .scaleEffect(currentPage == index ? 1.0 : 0.9)
                                .animation(
                                    .spring(response: 0.4, dampingFraction: 0.7), value: currentPage
                                )
                        }
                    }
                    .padding(.bottom, 10)

                    // Main action button
                    Button(action: {
                        haptic.impactOccurred()
                        handleButtonTap()
                    }) {
                        HStack(spacing: 15) {
                            Text(buttonTitle)
                                .font(.system(size: 20, weight: .bold))
                            if currentPage < pages.count - 1 {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 20, weight: .bold))
                            } else {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 20, weight: .bold))
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.brandGradient)
                                .shadow(color: .black.opacity(0.4), radius: 15, y: 8)
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
                            HStack(spacing: 10) {
                                Image(systemName: "arrow.left")
                                    .font(.system(size: 20, weight: .semibold))
                                Text("Back")
                                    .font(.system(size: 20, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                        }
                        .transition(.opacity)
                    }
                }
                .padding(.bottom, 25)
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
            .allowsHitTesting(false)
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

#Preview() {
    OnboardingView(isFirstLaunch: .constant(true))
}
#Preview("First Page") {
    OnboardingView(isFirstLaunch: .constant(true))
}
