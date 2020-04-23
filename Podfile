#
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '11.0'

workspace 'SudoOperations'
use_frameworks!
inhibit_all_warnings!

project 'SudoOperations', {
    'Debug-Dev' => :debug,
    'Debug-QA' => :debug,
    'Debug-Prod' => :debug,
    'Release-Dev' => :release,
    'Release-QA' => :release,
    'Release-Prod' => :release
}

target 'SudoOperations' do
  inherit! :search_paths
  podspec :name => 'SudoOperations'
end

target 'SudoOperationsTests' do
  inherit! :search_paths
  podspec :name => 'SudoOperations'
end
