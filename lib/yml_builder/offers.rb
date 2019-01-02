# Модуль управления карточками товара разного типа. По сути - это класс-массив, в котором
# хранятся все товары

module YmlBuilder
  class Offers

    def initialize(stats, categories)
      @stats      = stats
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
      idx = 1
      out << add_ident("<offers>", ident)
      @offers.each do |_, offer|
        # Формируем один товар в YAML, разбиваем на строки, чтобы к каждой
        # добавить нужное количество пробелов для формирования корректного
        # YAML-файла
        arr = offer.to_yml(2).split(/[\n\r]/)
        arr.map! { |line| add_ident(line, ident) }
        out << arr.join("\n")
        # puts "#{idx}/#{@offers.count}" if idx % 1000 == 0
        idx += 1
      end
      out << add_ident("</offers>", ident)
      out.join("\n")
    end


    private


      def add_ident(str, ident)
        ' '.rjust(ident, ' ') + str
      end


      def init_class
        @offers = Hash.new
      end

  end
end