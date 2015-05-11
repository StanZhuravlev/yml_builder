module YmlBuilder
  class Categories
    # Переменная содержит список id категорий, для которых необходимо формировать прайс-лист.
    # Если переменная пуста, то включаются все категории
    attr_reader :filter

    def initialize(stats)
      @stats = stats
      init_class
    end

    def add(opts = {})
      return false unless can_add?(opts[:id])
      allow = [:id, :parent_id, :name]
      raise "Ошибка: для добавления категории используйте ключи #{allow.inspect}" if (opts.keys - allow).count > 0
      raise "Ошибка: не указан 'id' для добавления категории" if opts[:id].nil?
      raise "Ошибка: не указан 'name' для добавления категории" if opts[:name].nil?
      @params[opts[:id]] = { parent_id: opts[:parent_id], name: opts[:name] }
      @params = Hash[ @params.sort_by { |id, data| id } ]
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
    def filter=(allow)
      @filter = allow || Array.new
    end

    # Метод формирует фрагмент YML файла каталога Яндекс.Маркет, содержащий список категорий
    #
    # @param [Integer] ident отступ от левого края в символах
    # @return [String] фрагмент YML файла каталога Яндекс.Маркет, содержащий список категорий
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

    private

    def init_class
      @params = Hash.new
      self.filter = nil
    end

  end
end