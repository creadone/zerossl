require_relative 'lib/zerossl/version'

Gem::Specification.new do |spec|
  spec.name          = "zerossl"
  spec.version       = ZeroSSL::VERSION
  spec.authors       = ["creadone"]
  spec.email         = ["creadone@gmail.com"]

  spec.summary       = %q{Ruby client to obtain SSL certificate from ZeroSSL via REST API}
  spec.description   = %q{Ruby client to obtain SSL certificate from ZeroSSL via REST API}
  spec.homepage      = "https://github.com/creadone/zerossl"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"]    = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/creadone/zerossl"

  spec.add_runtime_dependency 'dry-configurable', '~> 0.11'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
