# Класс обеспечивает добавление в парйс-лист Yandex.Market категорий Интернет-магазинов

module YmlBuilder
  class Categories
    # Переменная содержит список id категорий, для которых необходимо формировать прайс-лист.
    # Если переменная пуста, то включаются все категории
    # @example Примеры использования
    #   price = YmlBuilder::Yml.new
    #   price.categories.filter = [1, 3, 4, 5]
    attr_reader :filter


    def initialize(stats)
      @stats = stats
      init_class
    end


    # Метод добавляет категорию Интернет-магазина в прайс-лист с учетом выставленных в значении filter настроек.
    #
    # @param [Hash] opts параметры категорий Интернет-магазина
    # @option opts [Object] :id идентификатор категории (обязательно)
    # @option opts [Integer] :parent_id идентификатор родительской категории (опционально)
    # @option opts [String] :name название категории (обязательно)
    # @return [Boolean] true, если категория была добавлена, и false, если добавление запрещено в filter
    # @example Примеры использования
    #   price = YmlBuilder::Yml.new
    #   price.categories.add(id: 1, name: 'Игрушки')
    #   price.categories.add(id: 2, name: 'Игрушки для девочек', parent_id: 1)
    def add(opts = {})
      return false unless can_add?(opts[:id])
      allow = [:id, :parent_id, :name]
      raise "Ошибка: для добавления категории используйте ключи #{allow.inspect}" if (opts.keys - allow).count > 0
      raise "Ошибка: не указан 'id' для добавления категории" if opts[:id].nil?
      raise "Ошибка: не указан 'name' для добавления категории" if opts[:name].nil?
      @params[opts[:id]] = { parent_id: opts[:parent_id], name: opts[:name] }
      @params            = Hash[@params.sort_by { |id, data| id }]
      @stats.add(:categories, 1)
      true
    end


    # Метод проверяет необходимость добавления категории или товара в прайс-лист
    # с учетом выставленных в значении filter настроек.
    #
    # @param [Object] id идентифкатор категории товара
    # @return [Boolean] true, если данный id категории указан в filter как допустимый для включения в прайс-лист
    def can_add?(id)
      @filter.count == 0 ? true : @filter.include?(id)
    end


    # Метод позволяет огарничить формирование прайс-листа только категориями, указанными в данном поле
    # Filter может принимать значения nil или [], тогда считается, что допустимо включение в прайс-лист
    # всех товаров.
    # @param [Array] allow массив id категорий, который должны попадать в результирующий прайс-лист
    # @example Примеры использования
    #   price = YmlBuilder::Yml.new
    #   price.categories.filter = [1, 3, 4, 5]
    def filter=(allow)
      @filter = allow || Array.new
    end


    # Метод формирует фрагмент YML файла каталога Яндекс.Маркет, содержащий список категорий
    #
    # @param [Integer] ident отступ от левого края в символах
    # @return [String] фрагмент YML файла каталога Яндекс.Маркет
    def to_yml(ident = 4)
      out = Array.new
      out << '<categories>'

      @params.each do |id, value|
        if value[:parent_id].nil?
          out << "  <category id=#{id.to_s.inspect}>#{::YmlBuilder::Common.encode_special_chars(value[:name])}</category>"
        else
          out << "  <category id=#{id.to_s.inspect} parentId=#{value[:parent_id].to_s.inspect}>#{::YmlBuilder::Common.encode_special_chars(value[:name])}</category>"
        end
      end
      warn "Предупреждение: не указано ни одной категории в секции 'categories'" if out.count == 1

      out << '</categories>'

      out.map! { |line| line = ' '.rjust(ident, ' ') + line }
      out.join("\n")
    end


    # Метод возвращает true, если категория, передаваемая в качестве параметра, уже добавлена в прайс-лист
    #
    # @param [Object] id идентификатор категории
    # @return [Boolean] true, если категория с заданным id уже была добавлена в прайс-лист
    def has?(id)
      @params[id].nil? ? false : true
    end


    private


      def init_class
        @params     = Hash.new
        self.filter = nil
      end

  end
end