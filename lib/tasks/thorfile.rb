class PdfExportTasks < Thor
  include Rails.application.config.dradis.thor_helper_module

  namespace 'dradis:plugins:pdf'

  desc 'export', 'export the current repository structure as PDF document'
  method_option :output,   required: false, type: :string, desc: 'the report file to create (if ends in .pdf), or directory to create it in'

  def export
    require 'config/environment'

    # The options we'll end up passing to the Processor class
    opts = {}

    report_path = options.output || Rails.root
    unless report_path.to_s =~ /\.pdf\z/
      date = DateTime.now.strftime('%Y-%m-%d')
      base_filename = "dradis-report_#{date}.pdf"

      report_filename = NamingService.name_file(
        original_filename: base_filename,
        pathname: Pathname.new(report_path)
      )

      report_path = File.join(report_path, report_filename)
    end

    detect_and_set_project_scope

    exporter = Dradis::Plugins::PdfExport::Exporter.new(task_options)
    pdf = exporter.export

    File.open(report_path, 'wb') do |f|
      f << pdf.render
    end

    logger.info{ "Report file created at:\n\t#{report_path}" }
  end

end
