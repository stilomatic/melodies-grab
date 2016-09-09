# Uncomment this line to define a global platform for your project

platform :ios, '8.1'
inhibit_all_warnings!

target 'melodies grab' do
   pod 'MIKMIDI', '~> 1.6'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        puts "#{target.name}"
    end
end

project 'FFTVisuals/FFTVisuals.xcodeproj'
workspace 'melodies'
