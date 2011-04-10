require 'net/http'
require 'net/https'
require 'nokogiri'

class PostreceiveHooks
  def self.run(user, token, repo, urls)
    new(user, token, repo, urls).run
  end

  def initialize(user, token, repo, urls)
    @user = user
    @token = token
    @repo = repo
    @urls = urls
  end

  def run
    raise "No user specified" if @user.nil? || @user.empty?
    raise "No token specified" if @token.nil? || @token.empty?
    raise "No repo specified" if @repo.nil? || @repo.empty?
    raise "No urls specified" if @urls.nil? || @urls.empty?

    puts "Current: "
    puts current_urls

    puts "Required: "
    puts required_urls

    update

    puts "Confirmed: "
    puts current_urls
  end

  def current_urls
    @current_urls ||= load_current_urls
  end

  def load_current_urls
    path = uri.path
    while true
      req = Net::HTTP::Get.new(path)
      req.set_form_data(auth, '&')
      
      res = fetch(req)
      case res
      when Net::HTTPSuccess then break
      when Net::HTTPRedirection then
        path=res['location']
        puts "Redirecting to #{path}"
      else
        raise res
      end
    end

    raise "Repo not found: #{res.code} #{res.body}" unless res.code == "200" 

    doc = Nokogiri::HTML(res.body)
    form = doc.at("form[action='/#{@repo}/edit/postreceive_urls']")
    form.search("input[name='urls[]']").map {|x| x["value"]}.compact
  end

  def required_urls
    (current_urls + @urls).uniq
  end

  def update
    uri = URI.parse "#{admin_page}/postreceive_urls"
    req = Net::HTTP::Post.new(uri.path)

    req.set_form_data(auth + required_urls_data, '&')

    res = fetch(req)
    unless res["Location"] == "#{admin_page}?hooks=1"
      raise "Could not update urls"
    end

    @current_urls = nil
  end

  def required_urls_data
    required_urls.map do |url|
      ["urls[]", url]
    end
  end

  def uri
    @uri ||= URI.parse(admin_page)
  end

  def admin_page
    "https://github.com/#{@repo}/edit"
  end

  def fetch(req)
    server = Net::HTTP.new uri.host, uri.port
    server.use_ssl = uri.scheme == 'https'
    server.verify_mode = OpenSSL::SSL::VERIFY_NONE
    server.start {|http| http.request(req) }
  end

  def auth
    [[:login, @user], [:token, @token]]
  end
end
