module YmlBuilder # :nodoc:
  class Common

    def self.encode_special_chars(out)
      return out.to_s.gsub(/[\"\&\>\<\']/, '"' => '&quot;',
                           '&'                 => '&amp;',
                           '>'                 => '&gt;',
                           '<'                 => '&lt;',
                           "'"                 => '&apos;')
    end


    def self.convert_key(key)
      return 'currencyId' if key == :currency_id
      return 'categoryId' if key == :category_id
      key.to_s
    end

  end
end