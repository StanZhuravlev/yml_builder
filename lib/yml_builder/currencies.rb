module YmlBuilder
  class Currencies

    def initialize
      init_class
    end


    # Метод формирует фрагмент YML файла каталога Яндекс.Маркет, содержащий список валют
    #
    # @param [Integer] ident отступ от левого края в символах
    # @return [String] фрагмент YML файла каталога Яндекс.Маркет
    def to_yml(ident = 4)
      out = Array.new
      out << '<currencies>'

      @params.each do |key, value|
        out << "  <currency id=#{key.to_s.upcase.inspect} rate=#{value.to_s.upcase.inspect}/>" unless value.nil?
      end
      warn "Предупреждение: не указано ни одной валюты в секции 'currencies'" if out.count == 1

      out << '</currencies>'

      out.map! { |line| line = ' '.rjust(ident, ' ') + line }

      out.join("\n")
    end


    private


      def valid?(method_sym, allow, value)
        return true if value.to_s.match(/^\s*[+-]?((\d+_?)*\d+(\.(\d+_?)*\d+)?|\.(\d+_?)*\d+)(\s*|([eE][+-]?(\d+_?)*\d+)\s*)$/)
        return true if allow.include?(value)
        warn "Предупреждение: значение валюты #{method_sym.to_s.upcase} может быть цифрой или значением из #{allow.inspect}"
        false
      end


      def processing_method(method_sym, value)
        if method_sym.to_s.match(/=$/)
          key   = method_sym.to_s.gsub(/=$/, '')
          allow = [:cbrf, :nbu, :nbk, :cb]
          valid?(key.to_s, allow, value)

          @params[key.to_sym] = value
        else
          @params[method_sym.to_s.gsub(/=$/, '').to_sym]
        end
      end


      def init_class
        @params = Hash.new

        @params[:rur] = nil
        @params[:rub] = nil
        @params[:usd] = nil
        @params[:eur] = nil
        @params[:uah] = nil
        @params[:kzt] = nil
      end


      def method_missing(method_sym, *arguments, &block)
        if @params.include?(method_sym.to_s.gsub(/=$/, '').to_sym)
          processing_method(method_sym, arguments.first)
        else
          super
        end
      end

  end
end