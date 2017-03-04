# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

plugin 'cocoapods-keys', {
  :project => "SwiftActorsSample",
  :keys => [
    "OpenWeatherApiKey"
  ]
}


target 'SwiftActorsSample' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SwiftActorsSample
  pod "Himotoki", "~> 3.0"
  pod 'R.swift'
  pod "SwiftActor", :git => "https://github.com/SwiftActor/SwiftActor"
  pod "SwiftActors", :git => "https://github.com/applideveloper/SwiftActors"

  target 'SwiftActorsSampleTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'SwiftActorsSampleUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
