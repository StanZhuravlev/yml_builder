module YmlBuilder
  class Shop

    def initialize
      init_class
    end

    # Метод формирует фрагмент YML файла каталога Яндекс.Маркет для описания Интернет-магазина
    #
    # @return [String] фрагмент YML файла каталога Яндекс.Маркет
    def to_yml
      out = Array.new
      out << '  <shop>'

      @params[:m].each do |key, value|
        raise "Ошибка секции 'company': не заполнено значение для обязательного ключа #{key.to_s.inspect}" if value == ''
        out << "    <#{key}>#{::YmlBuilder::Common.encode_special_chars(value)}</#{key}>"
      end

      @params[:o].each do |key, value|
        unless value.nil?
          out << "    <#{key}>#{::YmlBuilder::Common.encode_special_chars(value)}</#{key}>"
        end
      end

      out << '    {replace_currencies}'
      out << '    {replace_categories}'
      out << '    {replace_local_delivery_cost}'
      out << '    {replace_offers}'
      out << '  </shop>'
      out.join("\n")
    end


    private

    def init_class
      @params = Hash.new

      @params[:m] = Hash.new
      @params[:m][:name] = ''
      @params[:m][:company] = ''
      @params[:m][:url] = ''

      @params[:o] = Hash.new
      @params[:o][:phone] = nil
      @params[:o][:platform] = nil
      @params[:o][:version] = nil
      @params[:o][:agency] = nil
      @params[:o][:email] = nil
      @params[:o][:adult] = nil
      @params[:o][:cpa] = nil
    end

    def method_missing(method_sym, *arguments, &block)
      if @params[:m].include?(method_sym.to_s.gsub(/=$/, '').to_sym)
        processing_method(:m, method_sym, arguments.first)
      elsif @params[:o].include?(method_sym.to_s.gsub(/=$/, '').to_sym)
        processing_method(:o, method_sym, arguments.first)
      else
        super
      end
    end

    def processing_method(part, method_sym, value)
      if method_sym.to_s.match(/=$/)
        key = method_sym.to_s.gsub(/=$/, '')
        warn "Предупреждение: название магазина не должно быть больше 20 символов" if key == 'name' && value.length > 20
        @params[part][key.to_sym] = value
      else
        @params[part][method_sym.to_s.gsub(/=$/, '').to_sym]
      end
    end


  end
end