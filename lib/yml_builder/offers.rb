module YmlBuilder
  class Offers

    def initialize(stats, categories)
      @stats = stats
      @categories = categories
      init_class
    end

    def init_class
      @offers = Hash.new
    end

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

  end
end