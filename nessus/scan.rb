require_relative './xmlrpc.rb'
require_relative './settings.rb'

module Nessus
  class Scan
    attr_reader :uuid, :id, :details, :result

    def self.web_app(targets)
      templates = client.list_template('scan')

      #get the name => webapp template from the list
      new(uuid, targets)
    end    

    def initialize(uuid, targets)
      @uuid = uuid
      setup_scan(targets)
    end

    def launch
      client.scan_launch(@id)

      loop do
        raw    = client.scan_details(@id)
        status = raw['info']['status']

        break if status != 'running'
          
        sleep Nessus::Settings.refresh_interval
      end
    end

    def view
      client.scan_details(scan_id)
    end

    def export_csv(filepath)
      csv_id   = client.scan_export(@id, 'csv')
      csv_data = client.report_download(@id, csv_id['file'])

      File.write(filepath, csv_data)
    end

    private

    def setup_scan(targets)
      @details = client.scan_create(
        @uuid,
        "Automated Scan #{DateTime.now}",
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
  end
end