# -*- encoding: utf-8 -*-

require File.expand_path('../lib/dradis/plugins/pdf_export/version', __FILE__)
version = Dradis::Plugins::PdfExport::version

Gem::Specification.new do |spec|
  spec.platform = Gem::Platform::RUBY
  spec.name = 'dradis-pdf_export'
  spec.version = version
  spec.required_ruby_version = '>= 1.9.3'
  spec.license = 'GPL-2'

  spec.authors = ['Daniel Martin']
  spec.description = 'Export to PDF plugin for the Dradis Framework'
  spec.summary = 'Dradis PDF export plugin'
  spec.homepage = 'https://dradis.com/support/guides/reporting/pdf_reports.html'

  spec.files = `git ls-files`.split($\)
  spec.executables = spec.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'dradis-plugins', '>= 4.8.0'
  spec.add_dependency 'prawn', '~> 2.5'
  spec.add_dependency 'prawn-table', '~> 0.2.2'

  spec.add_development_dependency 'capybara', '~> 1.1.3'
  spec.add_development_dependency 'database_cleaner'
  spec.add_development_dependency 'factory_girl_rails'
  spec.add_development_dependency 'rake', '>= 12.3.3'
  spec.add_development_dependency 'rspec-rails', '~> 2.11.0'
  spec.add_development_dependency 'sqlite3'
end
