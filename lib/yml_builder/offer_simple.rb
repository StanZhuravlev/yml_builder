module YmlBuilder # :nodoc:
  class OfferSimple < YmlBuilder::CommonOffer

    def initialize
      super
      @type = 'simple'

      @params = Hash.new
      @params[:url] = nil
      @params[:price] = nil
      @params[:currency_id] = nil
      @params[:category_id] = nil
      @params[:market_category] = nil
      @params[:picture] = nil
      @params[:store] = nil
      @params[:pickup] = nil
      @params[:delivery] = nil
      @params[:local_delivery_cost] = nil
      @params[:name] = nil
      @params[:vendor] = nil
      @params[:vendor_code] = nil
      @params[:description] = nil
      @params[:country_of_origin] = nil
      @params[:adult] = nil
      @params[:param] = nil
      @params[:weight] = nil
      @params[:dimensions] = nil

      @mandatories = [:url, :price, :currency_id, :category_id, :delivery, :name]
    end

  end
end