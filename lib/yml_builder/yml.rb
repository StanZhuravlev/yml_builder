# Базовый класс для управления формированием прайс-листа. Содержит ссылки на различные секции:
# shop, currencies, categories, offers

module YmlBuilder
  class Yml
    # Ссылка на класс, описывающий контакты Интернет-магазина ({YmlBuilding::Shop})
    # @example Примеры использования
    #   price = YmlBuilder::Yml.new
    #   price.shop.phone = '+7 (123) 456-7890'
    attr_reader :shop
    # Ссылка на класс, описывающий категории (YmlBuilding::Categories)
    # @example Примеры использования
    #   price = YmlBuilder::Yml.new
    #   price.categories.add(id: 1, name: "Игрушки")
    #   price.categories.add(id: 4, name: "Игрушки для девочек", parent_id: 1)
    attr_reader :categories
    # Ссылка на класс, описывающий валюты ({YmlBuilding::Currencies})
    # @example Примеры использования
    #   price = YmlBuilder::Yml.new
    #   price.currencies.rub = 1
    #   price.currencies.usd = 55.04
    #   price.currencies.eur = :cbrf
    attr_reader :currencies
    # Ссылка на класс, управляющий товарами (офферами) ({YmlBuilding::Offers})
    attr_reader :offers
    # Переменая, хранящая стоимость доставки в локации расположения Интернет-магазина
    # @example Примеры использования
    #   price = YmlBuilder::Yml.new
    #   price.local_delivery_cost = 300
    attr_reader :local_delivery_cost


    def initialize
      @stats               = ::YmlBuilder::Stats.new
      @shop                = ::YmlBuilder::Shop.new
      @currencies          = ::YmlBuilder::Currencies.new
      @categories          = ::YmlBuilder::Categories.new(@stats)
      @offers              = ::YmlBuilder::Offers.new(@stats, @categories)
      @local_delivery_cost = nil
    end


    # Метод устанавливает стоимость доставки в месте локации магазина. Например, если магазин находится в Москве,
    # то при указанни данной стоимости, она будет показана покупателям в этом же районе.
    #
    # @param [Float] value стоимость доставки в месте локации магазина
    # @return [None] нет
    def local_delivery_cost=(value)
      @local_delivery_cost = value
    end


    # Метод возвращает статистику по результатам генерации прайс-листа: всего товаров, товаров в наличии, стоимость
    # товаров в наличии (без учета количества)
    #
    # @return [None] нет
    # @example Примеры использования
    #   price = YmlBuilder::Yml.new
    #   price.stats                    #=> { :categories => 0, :total => 2, :available => 1, :price => 300.9 }
    def stats
      @stats.stats
    end


    # Метод возвращает текстовую строку с прайс-листом в формате Яндекс.Маркет
    #
    # @return [String] строка с прайс-листом в формате utf-8
    # @example Примеры использования
    #   price = YmlBuilder::Yml.new
    #   price.to_yml
    def to_yml
      out = @shop.to_yml
      out.gsub!(/^\s{0,100}\{replace\_currencies\}/, @currencies.to_yml)
      out.gsub!(/^\s{0,100}\{replace\_categories\}/, @categories.to_yml)
      out.gsub!(/^\s{0,100}\{replace\_local\_delivery\_cost\}[\n\r]/, lds_to_yml)
      out.gsub!(/^\s{0,100}\{replace\_offers\}/, @offers.to_yml)

      add_header_footer(out)
    end


    # Метод для записи прайслиста в файл. Запись осущесствится в кодировке windows-1251
    #
    # @param [String] filename название файла для записи прайс-листа
    # @return [None] нет
    # @example Примеры использования
    #   price = YmlBuilder::Yml.new
    #   price.save('price.yml')
    def save(filename)
      File.open(filename, 'w:utf-8') { |f| f.write(to_yml) }
    end


    private


      def add_header_footer(text)
        out = Array.new
        out << "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
        out << "<!DOCTYPE yml_catalog SYSTEM \"shops.dtd\">"
        out << "<yml_catalog date=#{::Time.now.strftime("%Y-%m-%d %H:%M").inspect}>"
        out << text
        out << "</yml_catalog>"
        out.join("\n")
      end


      def lds_to_yml(ident = 4)
        return "" if @local_delivery_cost.nil?
        ' '.rjust(ident, ' ') + "<local_delivery_cost>#{@local_delivery_cost}</local_delivery_cost>\n"
      end

  end
end
