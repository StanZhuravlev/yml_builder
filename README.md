# YmlBuilder

Библиотека YmlBuilder предназначена для формирования прайс-листов в формате Яндекс.Маркет. Библиотека обеспечивает формирвоание
прайс-листов с учетом правил Yandex (названия секций, ключей, порядок следования ключей и пр.), а также валидацию
большинства ошибок, связанных с генерацией прайс-листов.

## Установка

Добавить в Gemfile:

```ruby
gem 'yml_builder'
```

Установить гем cредствами Bundler:

    $ bundle

Или установить его отдельно:

    $ gem install yml_builder

# Зависимости

Для работы гема требуется Ruby не младше версии 2.2.1. Также для работы необходим гем StTools (https://github.com/StanZhuravlev/st_tools).

## Использование

Библиотека работает с кодировкой UTF-8, однако формирование прайс-листа осуществляется в соответствии с рекомендациями,
в кодировке windows-1251. Все работа строится на базе двух основных классов - YmlBuilder::Yml и YmlBuilder::Offer.
Остальные классы являются вспомогательными, и в пользовательских приложениях использоваться не должны. Использование
классов продемонстрировано ниже на базе примеров. Все примеры можно найти в папке /test

В соответствии со спецификацией Yandex.Market, все значения в прайс-листе делятся на две группы: обязательные и опциональные.
Если при формировании прайс-листа не заданы какие-либо обязательные параметры, то будет вызвано исключение с детальным
описанием причин.

_Ограничения библиотеки: поскольку она писалась под конкретный проект, в ней реализован только один тип товара - упрощенный.
В библиотеке заложены возможности расширения под дугие типы, но такое расширение будет создаваться только по необходимости.
Пишите, если требуется подержка других карточек, сделаю_

### Пример 1 - Создание прайс-листа и настройка магазина

Первым шагом необходимо создать прайс-лист, и настроить параметры Интернет-магазина.

```ruby
price = YmlBuilder::Yml.new
price.shop.name = 'Магазин ТЕСТ'
price.shop.company = "ООО 'Рога & Копыта'"
price.shop.url = 'http://example-site.ru'
price.shop.phone = '+7 (123) 456-7890'
price.shop.platform = 'OpenCart'
price.shop.version = '2.0'
puts price.to_yml
```

Результатом данного кода будет являться сгенерированная XML-сруктура следующего вида.

```xml
<?xml version="1.0" encoding="windows-1251"?>
<!DOCTYPE yml_catalog SYSTEM "shops.dtd">
<yml_catalog date="2015-05-11 14:07">
  <shop>
    <name>Магазин ТЕСТ</name>
    <company>ООО &apos;Рога &amp; Копыта&apos;</company>
    <url>http://example-site.ru</url>
    <phone>+7 (123) 456-7890</phone>
    <platform>OpenCart</platform>
    <version>2.0</version>
    <currencies>
    </currencies>
    <categories>
    </categories>
    <offers>
    </offers>
  </shop>
</yml_catalog>
```

Также будет сгенерировано два предупреждения

```txt
Предупреждение: не указано ни одной валюты в секции 'currencies'
Предупреждение: не указано ни одной категории в секции 'categories'
```


## Contributing

1. Fork it ( https://github.com/[my-github-username]/yml_builder/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
