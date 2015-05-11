# Базовый класс для управления формированием прайс-листа. Содержит ссылки на различные секции:
# shop, currencies, categories, offers

module YmlBuilder
  class Yml
    attr_reader :shop
    attr_reader :categories
    attr_reader :currencies
    attr_reader :local_delivery_cost
    attr_reader :offers

    def initialize
      @stats = ::YmlBuilder::Stats.new
      @shop = ::YmlBuilder::Shop.new
      @currencies = ::YmlBuilder::Currencies.new
      @categories = ::YmlBuilder::Categories.new(@stats)
      @offers = ::YmlBuilder::Offers.new(@stats, @categories)
      @local_delivery_cost = nil
    end

    def local_delivery_cost=(value)
      @local_delivery_cost = value
    end

    def lds_to_yml(ident = 4)
      return "" if @local_delivery_cost.nil?
      ' '.rjust(ident, ' ') + "<local_delivery_cost>#{@local_delivery_cost}</local_delivery_cost>\n"
    end


    def add_header_footer(text)
      out = Array.new
      out << "<?xml version=\"1.0\" encoding=\"windows-1251\"?>"
      out << "<!DOCTYPE yml_catalog SYSTEM \"shops.dtd\">"
      out << "<yml_catalog date=#{::Time.now.strftime("%Y-%m-%d %H:%M").inspect}>"
      out << text
      out << "</yml_catalog>"
      out.join("\n")
    end

    def stats
      @stats.stats
    end

    def to_yml
      out = @shop.to_yml
      out.gsub!(/^\s{0,100}\{replace\_currencies\}/, @currencies.to_yml)
      out.gsub!(/^\s{0,100}\{replace\_categories\}/, @categories.to_yml)
      out.gsub!(/^\s{0,100}\{replace\_local\_delivery\_cost\}[\n\r]/, lds_to_yml)
      out.gsub!(/^\s{0,100}\{replace\_offers\}/, @offers.to_yml)

      add_header_footer(out)
    end

    def save(filename)
      File.open(filename, 'w:windows-1251') {|f| f.write(to_yml) }
    end

  end
end