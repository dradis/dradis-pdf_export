module Dradis
  module Plugins
    module PdfExport
      class Engine < ::Rails::Engine
        # Standard Rails Engine stuff
        isolate_namespace Dradis::Plugins::PdfExport

        # use rspec for tests
        config.generators do |g|
          g.test_framework :rspec
        end

        # Connect to the Framework
        include Dradis::Plugins::Base

        # plugin_name 'HTML export'
        provides :export
        description 'Generate PDF reports'

        initializer 'dradis-pdf_export.mount_engine' do
          Rails.application.routes.append do
            mount Dradis::Plugins::PdfExport::Engine => '/export/pdf', as: :pdf_export
          end
        end
      end
    end
  end
end
