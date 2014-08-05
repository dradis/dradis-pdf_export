require 'dradis/pdf_export/actions'
require 'dradis/pdf_export/exporter'
require 'dradis/pdf_export/version'

module Dradis
  module PdfExport
    # class Configuration < ::Configurator
    #   configure :namespace => 'pdfexport'
    #   setting :category, :default => 'PDF ready'
    #   # setting :template, :default => Rails.root.join( 'vendor', 'plugins', 'html_export', 'template.html.erb' )
    # end
  end
end


# This includes the export plugin module in the dradis export plugin repository
module Plugins
  module Export
    include Dradis::PdfExport
  end
end
