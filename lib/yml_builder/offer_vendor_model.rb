module YmlBuilder # :nodoc:
  class OfferVendorModel < YmlBuilder::CommonOffer

    def initialize
      super

      @type = 'vendor.model'

      @params[:m]               = Hash.new
      @params[:m][:url]         = nil
      @params[:m][:price]       = nil
      @params[:m][:currency_id] = nil
      @params[:m][:category_id] = nil
      @params[:m][:delivery]    = nil
      @params[:m][:vendor]      = nil
      @params[:m][:model]       = nil

      @params[:o]                         = Hash.new
      @params[:o][:local_delivery_cost]   = nil
      @params[:o][:type_prefix]           = nil
      @params[:o][:vendor_code]           = nil
      @params[:o][:description]           = nil
      @params[:o][:manufacturer_warranty] = nil
      @params[:o][:country_of_origin]     = nil
      @params[:o][:available]             = nil
      @params[:o][:sales_notes]           = nil
      @params[:o][:downloadable]          = nil
      @params[:o][:adult]                 = nil
    end

  end
end