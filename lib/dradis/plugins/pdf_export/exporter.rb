module Dradis
  module Plugins
    module PdfExport
      class Processor
        include Prawn::View

        def initialize(args = {})
          content_service = args[:content_service]
          @document = Prawn::Document.new(top_margin: 70)

          @author = 'Security Tester'
          @email  = 'tester@securitytesting.com'
          @issues = content_service.all_issues
          @notes  = content_service.all_notes
          @title  = "Dradis Framework - v#{Dradis::CE::VERSION::STRING}"

          sort_issues
        end

        def generate
          cover_page
          # project_notes

          table_of_contents
          summary_of_findings
          detailed_findings
          tool_list
        end

        private
        def sort_issues
          sorted = { info: [], low: [], medium: [], high: []}
          @issues.each do |issue|
             cvss = issue.fields['CVSSv2'].to_f;
             case cvss
               when 0..0.9
                 sorted[:info] << issue
               when 1.0..3.9
                 sorted[:low] << issue
               when 4.0..6.9
                 sorted[:medium] << issue
               else
                 sorted[:high] << issue
             end
           end
           @sorted = sorted[:high] + sorted[:medium] + sorted[:low] + sorted[:info]
        end

        def cover_page
          move_down 50
          image "#{Engine.config.paths['app/assets'].expanded.first}/dradis_ce_full_sm.png", position: :center
          move_down 20

          text '<b><font size="24">Security Assessment Report</font></b>', inline_format: true, align: :center
          move_down 20
          text "BlackHat Arsenal 2025", align: :center


          bounding_box([300, 150], width: 200, height: 150) do
            # transparent(0.5) { stroke_bounds }  # This will stroke on one page
            text "<b>Author</b>: #{@author}", inline_format: :true
            text "<b>Email</b>: #{@email}", inline_format: :true
            text "<b>Date</b>: #{Time.now.strftime('%Y-%m-%d')}", inline_format: :true
            # transparent(0.5) { stroke_bounds }  # And this will stroke on the next
          end
          start_new_page
        end

        def project_notes
          draw_header

          text 'Project notes'
          move_down 20

          @notes.each do |note|
            fields = note.fields
            text "<b>#{fields['Title']}</b>", inline_format: true
            text fields['Description']
          end

          start_new_page
        end

        def summary_of_findings
          draw_header

          outline.add_subsection_to('Report Content') do
            outline.page destination: page_number, title: 'Summary of Findings'
          end

          text 'SUMMARY OF FINDINGS'
          move_down 20

          @sorted.each do |note|
            fields = note.fields
            text "• #{fields['Title']} (#{fields['CVSSv2']})"
          end

          start_new_page
        end

        def detailed_findings
          draw_header

          outline.add_subsection_to('Report Content') do
            outline.page destination: page_number, title: 'Detailed Findings'
          end

          text 'DETAILED FINDINGS'
          move_down 20

          @sorted.each do |note|
            fields = note.fields
            text "<b>#{fields['Title']}</b> (#{fields['CVSSv2']})", inline_format: true
            text fields['Description']

            move_down 20
            text "<b>Mitigation:</b>", inline_format: true
            text fields['Mitigation']
            start_new_page
          end
        end

        def tool_list
          draw_header

          outline.update do
            page destination: page_number, title: 'Tools Used'
          end

          text 'TOOLS USED'
          move_down 20

          data = [
            ['Name', 'Description']
          ]

          data << ['Dradis Framework', "Collaboration and reporting framework\nhttps://dradis.com" ]

          table data, header: true, position: :center
        end

        def table_of_contents
          outline.define do
            section('Report Content')
          end
        end

        def draw_header
          fill_color 'efefef'
          fill_rectangle [bounds.left-50, bounds.top + 100], bounds.width + 100, 87
          fill_color '000000'

          box = bounding_box [bounds.left-50, bounds.top+50], :width  => (bounds.width + 100) do

            font "Helvetica"
            text "Security Assessment Report", align: :center
            move_down 20

            stroke_color 'dadada'
            stroke_horizontal_rule
            stroke_color '000000'

          end
          move_down 40
        end

      end

      class Exporter < Dradis::Plugins::Export::Base
        def export()
          pdf = Processor.new(content_service: content_service)
          pdf.generate
          pdf
        end
      end
    end
  end
end
