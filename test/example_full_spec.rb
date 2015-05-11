require 'rspec'
require 'yml_builder'

describe 'Проверка формирования файла' do

  it 'Test' do
    price = YmlBuilder::Yml.new
    price.shop.name = 'Магазин ТЕСТ'
    price.shop.company = "ООО 'Рога & Копыта'"
    price.shop.url = 'http://nosite.ru'
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

    price.local_delivery_cost = 350

    item = YmlBuilder::Offer.new('simple')
    item.id = 6
    item.type = 'simple'
    item.available = true
    item.currency_id = 'RUR'
    item.delivery = true
    item.category_id = 1
    item.name = 'Товар №6'
    item.url = 'http://nosite/items/6'
    item.price = 300.90
    item.add_picture('http://nosite.ru/image1')
    item.add_picture('http://nosite.ru/image2')
    item.add_cover_picture('http://nosite.ru/image_cover')
    item.add_param(name: 'Обложка', value: 'Мягкая')
    item.add_param(name: 'Страниц', value: 10, unit: 'шт.')

    price.offers.add(item)

    item = YmlBuilder::Offer.new('simple')
    item.id = 3
    item.type = 'simple'
    item.available = false
    item.currency_id = 'RUR'
    item.delivery = true
    item.category_id = 2
    item.name = 'Товар №3'
    item.url = 'http://nosite/items/3'
    item.price = 100
    item.add_picture('http://nosite.ru/image1')
    item.add_picture('http://nosite.ru/image2')
    item.add_cover_picture('http://nosite.ru/image_cover')
    item.add_param(name: 'Обложка', value: 'Мягкая')
    item.add_param(name: 'Страниц', value: 10, unit: 'шт.')

    price.offers.add(item)

    puts price.to_yml
    price.save('test_yml.yml')
    puts price.stats.inspect

  end
end