Pod::Spec.new do |spec|
  spec.name                  = 'SudoOperations'
  spec.version               = '6.0.1'
  spec.author                = { 'Sudo Platform Engineering' => 'sudoplatform-engineering@anonyome.com' }
  spec.homepage              = 'https://sudoplatform.com'
  spec.summary               = 'Operations SDK for the Sudo Platform by Anonyome Labs.'
  spec.license               = { :type => 'Apache License, Version 2.0',  :file => 'LICENSE' }
  spec.source                = { :git => 'https://github.com/sudoplatform/sudo-operations-ios.git', :tag => "v#{spec.version}" }
  spec.source_files          = 'SudoOperations/**/*.swift'
  spec.ios.deployment_target = '13.0'
  spec.requires_arc          = true
  spec.swift_version         = '5.0'

  spec.dependency 'SudoLogging', '~> 0.3'
  spec.dependency 'SudoApiClient', '~> 7.0'
  spec.dependency 'AWSAppSync', '~> 3.2'
end
