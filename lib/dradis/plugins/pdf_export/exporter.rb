module Dradis
  module Plugins
    module PdfExport
      class Exporter < Dradis::Plugins::Export::Base
        def export()
          if File.file?(options[:template])
            load options[:template]
          else
            load File.expand_path('processor.rb', __dir__)
          end
          pdf = Processor.new(content_service: content_service)
          pdf.generate
          pdf
        end
      end
    end
  end
end
