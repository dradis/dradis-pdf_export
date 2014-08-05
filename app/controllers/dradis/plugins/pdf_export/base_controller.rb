module Dradis
  module Plugins
    module PdfExport

      class BaseController < Dradis::Frontend::AuthenticatedController
        # This method cycles throw the notes in the reporting category and creates
        # a simple PDF report with them.
        def index
          # these come from Export#create
          export_manager = session[:export_manager].with_indifferent_access

          exporter = Dradis::Plugins::PdfExport::Exporter.new
          pdf = exporter.export(export_manager)

          send_data pdf.render, filename: "dradis_report-#{Time.now.to_i}.pdf",
                                type: 'application/pdf',
                                disposition: 'inline'
        end
      end

    end
  end
end