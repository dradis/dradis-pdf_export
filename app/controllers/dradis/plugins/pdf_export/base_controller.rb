module Dradis
  module Plugins
    module PdfExport

      class BaseController < Dradis::Frontend::AuthenticatedController
        # This method cycles throw the notes in the reporting category and creates
        # a simple PDF report with them.
        def index
          # these come from Export#create
          export_manager_hash   = session[:export_manager].with_indifferent_access
          content_service_class = export_manager_hash[:content_service].constantize

          exporter = Dradis::Plugins::PdfExport::Exporter.new

          exporter = Dradis::Plugins::CSV::Exporter.new(
            content_service: content_service_class.new(plugin: Dradis::Plugins::PdfExport)
          )

          pdf = exporter.export(export_manager_hash)

          send_data pdf.render, filename: "dradis_report-#{Time.now.to_i}.pdf",
                                type: 'application/pdf',
                                disposition: 'inline'
        end
      end

    end
  end
end