require_relative './xmlrpc.rb'
require_relative './settings.rb'

module Nessus
  class Scan
    #
    # Wrapper for XMLRPC client
    # 
    # @attr_reader [String] uuid of scan template
    # @attr_reader [Fixnum] scan id
    # @attr_reader [Hash] full scan details
    # @attr_reader [Result] full scan result
    #
    attr_reader :uuid, :id, :details, :result
    #
    # Create a new scan instance
    # 
    # @param [String] nessus scan template name
    # @param [Array<String>] target addresses e.g http://localhost:3000
    #
    # @return [Scan]
    #
    def initialize(name, targets)
      set_uuid(name)
      setup_scan(targets)
    end
    #
    # Launches the scan
    #
    # @return [Result] the result hash from the scan
    # 
    def launch!
      client.scan_launch(@id)

      loop do
        raw    = client.scan_details(@id)
        status = raw['info']['status']

        if status != 'running'
          @result = Result.new(raw)
          break
        end
          
        sleep Nessus::Settings.refresh_interval
      end
    end
    #
    # View the result of a finished scan
    #
    # @return [Hash] the raw result hash from the scan
    #
    def view
      result && result.raw
    end
    #
    # Export scan to csv file
    #
    # @param [String] output filepath
    #
    # @return [Fixnum] bytes written to file
    #
    def export_csv(filepath)
      csv_id   = client.scan_export(@id, 'csv')
      csv_data = client.report_download(@id, csv_id['file'])

      File.write(filepath, csv_data)
    end

    private

    def set_uuid(name)
      @uuid = client
                .list_template('scan')
                .fetch('templates', [])
                .find { |t| t['name'] == name }
                .fetch('uuid')
    end

    def setup_scan(targets)
      @details = client.scan_create(
        @uuid,
        "Automated Scan #{Time.now}",
        "This scan was created by the Nessus ruby client as part of automated testing",
        targets
      )

      @id = @details['scan']['id']
    end

    def client
      @client ||= Nessus::Client.new(
        Nessus::Settings.host,
        Nessus::Settings.username,
        Nessus::Settings.password,
        Nessus::Settings.ssl_verify
      )
    end

    class Result
      attr_reader :raw

      def initialize(raw)
        @raw = raw
      end

      def critical?
        check('critical')
      end

      def high?
        check('high')
      end

      def medium?
        check('medium')
      end

      private

      def check(severity)
        raw['hosts'].any? { |h| h.fetch(severity) > 0 } 
      end
    end
  end
end