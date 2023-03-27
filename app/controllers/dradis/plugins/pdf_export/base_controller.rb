module Dradis
  module Plugins
    module PdfExport
      class BaseController < Dradis::Plugins::Export::BaseController
        before_action :validate_scope

        # This method cycles throw the notes in the reporting category and creates
        # a simple PDF report with them.
        def index
          exporter = Dradis::Plugins::PdfExport::Exporter.new(
            export_options.merge(scope: @scope.to_sym)
          )
          pdf = exporter.export

          send_data pdf.render, filename: "dradis_report-#{Time.now.to_i}.pdf",
                                type: 'application/pdf',
                                disposition: 'inline'
        end

        private

        def validate_scope
          @scope = params[:scope]

          unless @scope == 'all' || @scope == 'published'
            raise 'Something fishy is going on...'
          end
        end
      end
    end
  end
end
