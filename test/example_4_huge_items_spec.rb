require 'rspec'
require 'yml_builder'

# Запрос URL
# У пользователя не отрабатывает генерация 60 тыс. товаров
# В ходе тестирования стало понятно, что огромная задержка происходит
# в функции to_yaml. Функция переписана вручную.

describe 'Пример 4 - Формирование выгрузки на 100 тыс. товаров' do

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
    price.categories.add(id: 1, name: "Тестовая категория")

    0.upto(100_000) do |tovar_id|
      if tovar_id % 1000 == 0
        puts "#{tovar_id}/100000"
      end

      item = YmlBuilder::Offer.new('simple')
      item.id = tovar_id
      item.available = [true, false].sample
      item.currency_id = ['RUR', 'EUR'].sample
      item.delivery =[true, false].sample
      item.category_id = 1
      item.name = "Товар #{tovar_id}"
      item.url = "http://example-site.ru/items/#{tovar_id}"
      item.price = Random.rand(300) + 100
      item.add_picture("http://example-site.ru/#{tovar_id}/image1")
      item.add_param(name: 'Обложка', value: 'Мягкая')
      item.add_param(name: 'Страниц', value: 10, unit: 'шт.')

      price.offers.add(item)
    end

    puts
    puts "Добавление товаров завершено"
    print "Фрагмент итоговой выгрузки... "
    puts price.to_yml[1..1024]
    puts price.stats.inspect
  end

end

