# frozen_string_literal: true

require_relative "lib/heitt/version"

Gem::Specification.new do |spec|
  spec.name = "heitt"
  spec.version = HEITT::VERSION
  spec.authors = ["Jonathan Botchway Owusu"]
  spec.email = ["jbotchwayowusu@gmail.com"]
  spec.summary = "Hash Extraction, Identification and Triage Tool."
  spec.description = "Hash Extraction, Identification and Triage Tool."
  spec.homepage = HEITT::GITHUB
  spec.required_ruby_version = ">= 3.1.0"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = HEITT::GITHUB
  spec.metadata["changelog_uri"] = "#{HEITT::GITHUB}/blob/main/CHANGELOG.md"
  spec.files  = Dir["lib/**/*.rb"]
  spec.bindir = "bin"
  spec.executables = ["heitt"]#spec.files.grep(%r{\Abin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
   spec.add_dependency "colorize", "~> 0.8.1" # For colored output

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
