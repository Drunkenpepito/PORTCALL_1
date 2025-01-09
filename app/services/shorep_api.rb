class ShorepApi
  def initialize
    @base_url = 'https://windmarineops.herokuapp.com/api/v1/'
    @api_key = ENV['SHORE_REP_SECRET_KEY']
  end

  def get_suppliers(page_nb = nil)
    url = "#{@base_url}suppliers?page=#{page_nb}"
    response = HTTParty.get(url, headers: { 'ApiKey' => @api_key })
    JSON.parse(response.body)
  end

  def get_a_supplier(id)
    url = "#{@base_url}suppliers/#{id}"
    response = HTTParty.get(url, headers: { 'ApiKey' => @api_key })
    JSON.parse(response.body)
  end

end
