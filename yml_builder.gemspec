# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yml_builder/version'

Gem::Specification.new do |spec|
  spec.name          = "yml_builder"
  spec.version       = YmlBuilder::VERSION
  spec.authors       = ["Stan Zhuravlev"]
  spec.email         = ["stan@v-screen.ru"]

  spec.summary       = %q{Набор классов для формирования прайс-листов в формате Яндекс YAML}
  spec.description   = %q{Библиотека содержит набор классов для формирования и валидации прайс-листов
                          в формате Яндекс YAML (Yandex.Market).
                          Текущая версия поддерживает только упрощенные товарные карточки.}
  spec.homepage      = "https://github.com/StanZhuravlev/yml_builder"
  spec.license       = "MIT"
  spec.required_ruby_version = '=> 2.2.1'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  # http://yehudakatz.com/2010/04/02/using-gemspecs-as-intended/
  # spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.files         = Dir.glob("{bin,lib,test}/**/*") + %w(LICENSE.txt README.md CHANGELOG.md)
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib", "lib/yml_builder"]

  spec.add_development_dependency "bundler", "=> 1.9"
  spec.add_development_dependency "rake", "=> 10.0"
end
