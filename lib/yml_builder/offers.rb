# Модуль управления карточками товара разного типа. По сути - это класс-массив, в котором
# хранятся все товары

module YmlBuilder
  class Offers

    def initialize(stats, categories)
      @stats = stats
      @categories = categories
      init_class
    end

    # Метод добавляет товар в прайс-лист с учетом выставленных в значении filter настроек.
    #
    # @param [{YmlBuilder::CommonOffer}] offer карточка товара
    # @example Примеры использования
    #   price = YmlBuilder::Yml.new
    #   price.offers.add(offer)
    def add(offer)
      return false unless @categories.can_add?(offer.category_id)
      @offers[offer.id] = offer

      # Формируем статистику
      @stats.add(:total, 1)
      if offer.available
        @stats.add(:available, 1)
        @stats.add(:price, (offer.price || 0))
      end
      true
    end

    # Метод формирует фрагмент YML файла каталога Яндекс.Маркет для всего списка товаров
    #
    # @param [Integer] ident отступ от левого края в символах
    # @return [String] фрагмент YML файла каталога Яндекс.Маркет
    def to_yml(ident = 4)
      @offers = @offers.sort_by { |id, offer| id }

      out = Array.new
      out << "<offers>"
      @offers.each do |id, offer|
        out += offer.to_yml(2).split(/[\n\r]/)
      end
      out << "</offers>"

      out.map! { |line| ' '.rjust(ident, ' ') + line }
      out.join("\n")
    end


    private


    def init_class
      @offers = Hash.new
    end

  end
end