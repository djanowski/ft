require "csv"
require "net/http/persistent"

class FusionTables
  Error = Class.new(RuntimeError)

  class Connection
    URL = URI.parse("http://tables.googlelabs.com/api/query")

    def http
      @http ||= Net::HTTP::Persistent.new("fusiontables").tap do |http|
        http.headers["Content-Type"] = "application/x-www-form-urlencoded"
      end
    end

    def query(sql)
      url = URL.dup

      url.query = "sql=#{URI.escape(sql)}"
      res = http.request(url)

      case res
      when Net::HTTPOK
        CSV.parse(res.body.force_encoding(Encoding::UTF_8))
      when Net::HTTPBadRequest
        message = CGI.unescapeHTML(res.body[%r[<title>(.*)</title>]i, 1])
        raise Error.new("#{message}. SQL was: #{sql}")
      else
        raise "Got #{res.class}: #{res.body}"
      end
    end
  end
end
