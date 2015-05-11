require 'rspec'
require 'yml_builder'

describe 'Пример 2 - Валюта и категории' do

  it 'Test' do
    price = YmlBuilder::Yml.new
    price.shop.name = 'Магазин ТЕСТ'
    price.shop.company = "ООО 'Рога & Копыта'"
    price.shop.url = 'http://example-site.ru'
    price.shop.phone = '+7 (123) 456-7890'
    price.shop.platform = 'OpenCart'
    price.shop.version = '2.0'

    price.currencies.rub = 1
    price.currencies.usd = 55.04
    price.currencies.eur = :cbrf

    price.categories.add(id: 1, name: "Игрушки")
    price.categories.add(id: 2, name: "Одежда")
    price.categories.add(id: 4, name: "Игрушки для девочек", parent_id: 1)
    price.categories.add(id: 5, name: "Игрушки для мальчиков", parent_id: 1)
    price.categories.add(id: 3, name: "Книги")

    puts price.to_yml

  end
end