module Dradis
  module Plugins
    module PdfExport
      class ExportsController < Dradis::Plugins::Export::BaseController
        skip_before_action :validate_template

        # This method cycles throw the notes in the reporting category and creates
        # a simple PDF report with them.
        def create
          exporter = Dradis::Plugins::PdfExport::Exporter.new(export_params)
          pdf = exporter.export

          send_data pdf.render, filename: "dradis_report-#{Time.now.to_i}.pdf",
                                type: 'application/pdf',
                                disposition: 'inline'
        end
      end
    end
  end
end
