module Nessus
  module Settings
    extend self

    def host
      ENV.fetch('NESSUS_HOST', 'http://localhost:8834')
    end

    def username
      ENV.fetch('NESSUS_USER', 'test_user')
    end

    def password
      ENV.fetch('NESSUS_PASS', 'test_pass')
    end

    def refresh_interval
      5000
    end
  end
end
