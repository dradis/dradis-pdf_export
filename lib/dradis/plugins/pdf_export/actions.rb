module Dradis
  module PdfExport
    module Actions

      # This method cycles throw the notes in the reporting category and creates
      # a simple PDF report with them.
      #
      def to_pdf(params={})
        pdf = Processor.new(params)
        pdf.generate()

        send_data pdf.render, filename: "dradis_report-#{Time.now.to_i}.pdf",
                              type: 'application/pdf',
                              disposition: 'inline'
      end
    end
  end
end