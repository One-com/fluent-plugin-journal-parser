Gem::Specification.new do |spec|
  spec.name          = 'fluent-plugin-journal-parser'
  spec.version       = '0.1.0'
  spec.authors       = ['Emil Renner Berthing']
  spec.email         = ['erb@one.com']
  spec.licenses      = ['Apache-2.0']

  spec.summary       = %q{Fluentd plugin to parse systemd journal export format.}
  spec.homepage      = 'https://github.com/One-com/fluent-plugin-journal-parser'

  spec.files         = ['lib/fluent/plugin/parser_journal.rb']
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'fluentd', '~> 0.12'
end
