#
# Define static scan settings
#
module Nessus
  module Settings
    extend self
    # 
    # Host for Nessus instance
    #
    # @return [String] 
    #
    def host
      ENV.fetch('NESSUS_HOST', 'http://localhost:8834')
    end
    # 
    # Nessus username
    #
    # @return [String] 
    #
    def username
      ENV.fetch('NESSUS_USER', 'test_user')
    end
    # 
    # Nessus password
    #
    # @return [String] 
    #
    def password
      ENV.fetch('NESSUS_PASS', 'test_pass')
    end
    # 
    # SSL connection settings for Nessus instance
    #
    # @note set to 'ssl_verify' in PRODUCTION
    #
    # @return [String] 
    #
    def ssl_verify
      'none' # ssl_verify for secure connection
    end
    # 
    # Refresh interval when checking for job completion
    #
    # @return [Fixnum] 
    #
    def refresh_interval
      5
    end
  end
end
