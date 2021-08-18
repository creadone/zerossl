require 'openssl'

module ZeroSSL
  class CSR
    def initialize opts = {}
      opts.transform_keys!(&:to_s)

      @common_name  = opts.dig('common_name')
      @organization = opts.dig('organization')
      @country      = opts.dig('country')
      @state_name   = opts.dig('state_name')
      @locality     = opts.dig('locality')

      @signing_key  = signing_key
      @subject      = subject
    end

    def call
      csr            = OpenSSL::X509::Request.new
      csr.version    = 0
      csr.subject    = subject
      csr.public_key = signing_key.public_key
      csr.sign signing_key, OpenSSL::Digest::SHA256.new

      [csr.to_s, signing_key.to_s]
    end

    private

      def signing_key
        @signing_key ||= OpenSSL::PKey::RSA.new 2048
      end

      def subject
        @subject ||= OpenSSL::X509::Name.new [
          ['CN', @common_name],
          ['O',  @organization],
          ['C',  @country],
          ['ST', @state_name],
          ['L',  @locality]
        ]
      end

  end
end