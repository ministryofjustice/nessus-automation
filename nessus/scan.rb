require_relative './xmlrpc.rb'
require_relative './settings.rb'

module Nessus
  class Scan
    attr_reader :uuid, :id, :details, :result

    def initialize(name, targets)
      set_uuid(name)
      setup_scan(targets)
    end

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

    def view
      result && result.raw
    end

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
        !critical? && check('high')
      end

      def medium?
        !critical? && !high? && check('medium')
      end

      private

      def check(severity)
        raw['hosts'].any? { |h| h.fetch(severity) > 0 } 
      end
    end
  end
end