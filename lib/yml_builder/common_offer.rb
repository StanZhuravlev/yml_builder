module YmlBuilder
  class CommonOffer
    attr_accessor :id
    attr_accessor :type
    attr_accessor :available
    attr_accessor :bid

    attr_accessor :mandatories

    def initialize
      init_class
    end

    def init_class
      @params = Hash.new
      @meta = Hash.new
      @picture = Array.new

      @id = 0
      @type = 'unknown'
      @available = false
      @bid = nil

      @mandatories = Array.new
    end

    def add_picture(url)
      @picture << url
      @picture.uniq!
      warn "Предупреждение: число картинок превышает 10 (offer_id=#{@id}). Сокращаем до 10" if @picture.count > 10
      @picture = @picture[0,9]
    end

    def add_cover_picture(url)
      @picture.unshift(url)
      @picture.uniq!
      warn "Предупреждение: число картинок превышает 10 (offer_id=#{@id}). Сокращаем до 10" if @picture.count > 10
      @picture = @picture[0,9]
    end

    def add_param(name:, unit: nil, value:)
      @meta[name] = { unit: unit, value: value}
    end

    def method_missing(method_sym, *arguments, &block)
      if @params.include?(method_sym.to_s.gsub(/=$/, '').to_sym)
        processing_method(method_sym, arguments.first)
      else
        super
      end
    end

    def processing_method(method_sym, value)
      if method_sym.to_s.match(/=$/)
        key = method_sym.to_s.gsub(/=$/, '')
        warn "Предупреждение: url не должен превышать 512 символов" if key == 'url' && value.length > 512
        warn "Предупреждение: price не может быть равен нулю" if key == 'price' && value.to_f == 0
        warn "Предупреждение: weight не может быть равен нулю" if key == 'weight' && value.to_f == 0
        @params[key.to_sym] = value
      else
        @params[method_sym.to_s.gsub(/=$/, '').to_sym]
      end
    end

    def header_line
      out = Array.new
      out << "id=#{@id.to_s.inspect}"
      out << "type=#{@type.to_s.inspect}" if @type != 'simple'
      out << "available=\"#{@available.inspect}\""
      out << "bid=#{@bid.inspect}" unless @bid.nil?
      "<offer #{out.join (' ')}>"
    end

    def footer_line
      '</offer>'
    end

    def param_line(name, data)
      if data[:unit].nil?
        "<param name=#{::YmlBuilder::Common.encode_special_chars(name.to_s).inspect}>#{::YmlBuilder::Common.encode_special_chars(data[:value].to_s)}</param>"
      else
        "<param name=#{::YmlBuilder::Common.encode_special_chars(name.to_s).inspect} unit=#{::YmlBuilder::Common.encode_special_chars(data[:unit]).inspect}>#{::YmlBuilder::Common.encode_special_chars(data[:value].to_s)}</param>"
      end
    end

    def to_yml_subsections(key)
      out = Array.new

      if key == :picture
        @picture.each do |url|
          out << "  <picture>#{url}</picture>"
        end
      else
        @meta.each do |name, data|
          out << "  #{param_line(name, data)}"
        end
      end

      out
    end

    def to_yml_mandatories(key, value)
      raise "Ошибка секции 'offer': не заполнено обязательное значение #{key.to_s.inspect}" if (value.nil? || value.to_s == '')
      key_xml = ::YmlBuilder::Common.convert_key(key)
      "  <#{key_xml}>#{::YmlBuilder::Common.encode_special_chars(value)}</#{key_xml}>"
    end

    def to_yml_optional(key, value)
      return nil if value.nil?
      key_xml = ::YmlBuilder::Common.convert_key(key)
      "  <#{key_xml}>#{::YmlBuilder::Common.encode_special_chars(value)}</#{key_xml}>"
    end

    def to_yml(ident = 4)
      out = Array.new
      out << header_line

      @params.each do |key, value|
        if [:picture, :param].include?(key)
          out += to_yml_subsections(key)
        elsif @mandatories.include?(key)
          out << to_yml_mandatories(key, value)
        else
          out << to_yml_optional(key, value)
        end
      end
      out.compact!

      out << footer_line
      out.map! { |line| ' '.rjust(ident, ' ') + line }
      out.join("\n")
    end

  end
end