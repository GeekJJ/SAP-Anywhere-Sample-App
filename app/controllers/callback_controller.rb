class CallbackController < ApplicationController
  def install
    @token = ""
    operation = params[:op]
    if operation == 'Install'
      occ_host = params[:sapanywhere]
      timestamp = params[:timestamp]
      hmac = params[:hmac]
      @confirm_url = "#{occ_host}/oauth/authorize?response_type=code&client_id=#{api_key}&scope=#{install_scope}&redirect_uri=http://localhost:3000/call_back/install"
      redirect_to @confirm_url and return
    else
      auth_code = params[:code]
      occ_host = params[:sapanywhere]
      @token = token(occ_host, auth_code, "http://localhost:3000/call_back/install")
      redirect_to action: :success and return
    end
  end

  def success
    @token = "" unless @token
  end

  def test
    @content = params
  end

  private
    def token(occ_host, auth_code, redirect_url)
      results = []
      url = URI.parse("#{occ_host}/oauth/token?client_id=#{api_key}&client_secret=#{api_secret}&grant_type=authorization_code&code=#{auth_code}&redirect_uri=#{redirect_url}")
      # req = Net::HTTP::Get.new(url.to_s)
      res = Net::HTTP.start(url.host, url.port,
        :use_ssl => url.scheme == 'https',
        :verify_mode => OpenSSL::SSL::VERIFY_NONE) { |http|
        request = Net::HTTP::Get.new url
        request.add_field("Content-Type", "application/json")

        res = http.request request # Net::HTTPResponse object
        # http.request(req)
      }
      results = JSON.parse res.body
      results['refresh_token']
    end
end
