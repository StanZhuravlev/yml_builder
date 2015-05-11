module YmlBuilder
  class Offer

    def self.new(type)
      case type.downcase
        when 'simple'
          ::YmlBuilder::OfferSimple.new
        else
          raise "Ошибка: неизвестный тип оффера (#{type})"
      end
    end

  end
end