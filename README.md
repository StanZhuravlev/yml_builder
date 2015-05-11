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

### Пример 2 - Добавление валют и категорий

На втором шаге, осуществляется добавление необходимых валют из числа поддерживаемых Яндекс.Маркет, а также категорий
в которых будут размещены товары.

```ruby
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
```

Результатом данного кода будет являться сгенерированная XML-сруктура следующего вида.

```xml
<?xml version="1.0" encoding="windows-1251"?>
<!DOCTYPE yml_catalog SYSTEM "shops.dtd">
<yml_catalog date="2015-05-11 14:28">
  <shop>
    <name>Магазин ТЕСТ</name>
    <company>ООО &apos;Рога &amp; Копыта&apos;</company>
    <url>http://example-site.ru</url>
    <phone>+7 (123) 456-7890</phone>
    <platform>OpenCart</platform>
    <version>2.0</version>
    <currencies>
      <currency id="RUB" rate="1"/>
      <currency id="USD" rate="55.04"/>
      <currency id="EUR" rate="CBRF"/>
    </currencies>
    <categories>
      <category id="1">Игрушки</category>
      <category id="2">Одежда</category>
      <category id="3">Книги</category>
      <category id="4" parentId="1">Игрушки для девочек</category>
      <category id="5" parentId="1">Игрушки для мальчиков</category>
    </categories>
    <offers>
    </offers>
  </shop>
</yml_catalog>
```

### Пример 3 - Добавление товаров

Затем необходимо сформировать информацию о оферах, и добавить их в список товаров (offers). Офферы создаются через вызов
отдельного класса - YmlBuilder.Offer. На самом деле, это "рамочный" класс, который на самом деле вернет экземпляры
классов, соответствующих типам товаров Yandex.Market. Напрмиер, ```ruby YmlBuilder::Offer.new('simple')``` создает
описание урощенной карточки товара. Если вместо simple указать любой другой тип, то в данной версии библиотеки
будет вызвано исключение.

Кроме того, через вызов ```ruby offer.add_picture``` добавляются ссылки на картинки, описывающие товар. Каждый вызов метода
добавляет ссылку на фотографю товара в конце списка picture. При этом контролируется, чтобы размер списка изображений
не превышал 10. При превышении массив фотографий всегда обрезается до 10. Чтобы добавить основную фотографию товара
необходимо вызвать метод ```ruby offer.add_cover_picture```. Данный метод просто добавляет картинку в начало списка
фотографий. Если вызвать данный метод два раза, то список фотографий будет выглядеть как две основные фотографии.

Через вызов ```ruby offer.add_param``` добавляются различные вспомогательные параметры - вес, продолжительность записи,
размеры одежды и прочая информация.

```ruby
item = YmlBuilder::Offer.new('simple')
item.id = 6
item.available = true
item.currency_id = 'RUR'
item.delivery = true
item.category_id = 1
item.name = 'Товар №6'
item.url = 'http://example-site.ru/items/6'
item.price = 300.90
item.add_picture('http://example-site.ru/image1')
item.add_picture('http://example-site.ru/image2')
item.add_cover_picture('http://example-site.ru/image_cover')
item.add_param(name: 'Обложка', value: 'Мягкая')
item.add_param(name: 'Страниц', value: 10, unit: 'шт.')

price.offers.add(item)

item = YmlBuilder::Offer.new('simple')
item.id = 3
item.available = false
item.currency_id = 'RUR'
item.delivery = true
item.category_id = 2
item.name = 'Товар №3'
item.url = 'http://example-site.ru/items/3'
item.price = 100
item.add_picture('http://example-site.ru/image1')
item.add_picture('http://example-site.ru/image2')
item.add_cover_picture('http://example-site.ru/image_cover')
item.add_param(name: 'Обложка', value: 'Мягкая')
item.add_param(name: 'Страниц', value: 10, unit: 'шт.')

price.offers.add(item)
```

Результатом данного кода будет являться сгенерированная XML-сруктура следующего вида.

```xml
<?xml version="1.0" encoding="windows-1251"?>
<!DOCTYPE yml_catalog SYSTEM "shops.dtd">
<yml_catalog date="2015-05-11 14:40">
  <shop>
    <name>Магазин ТЕСТ</name>
    <company>ООО &apos;Рога &amp; Копыта&apos;</company>
    <url>http://example-site.ru</url>
    <phone>+7 (123) 456-7890</phone>
    <platform>OpenCart</platform>
    <version>2.0</version>
    <currencies>
      <currency id="RUB" rate="1"/>
      <currency id="USD" rate="55.04"/>
      <currency id="EUR" rate="CBRF"/>
    </currencies>
    <categories>
      <category id="1">Игрушки</category>
      <category id="2">Одежда</category>
      <category id="3">Книги</category>
      <category id="4" parentId="1">Игрушки для девочек</category>
      <category id="5" parentId="1">Игрушки для мальчиков</category>
    </categories>
    <offers>
      <offer id="3" available="false">
        <url>http://nosite/items/3</url>
        <price>100</price>
        <currencyId>RUR</currencyId>
        <categoryId>2</categoryId>
        <picture>http://example-site.ru/image_cover</picture>
        <picture>http://example-site.ru/image1</picture>
        <picture>http://example-site.ru/image2</picture>
        <delivery>true</delivery>
        <name>Товар №3</name>
        <param name="Обложка">Мягкая</param>
        <param name="Страниц" unit="шт.">10</param>
      </offer>
      <offer id="6" available="true">
        <url>http://nosite/items/6</url>
        <price>300.9</price>
        <currencyId>RUR</currencyId>
        <categoryId>1</categoryId>
        <picture>http://example-site.ru/image_cover</picture>
        <picture>http://example-site.ru/image1</picture>
        <picture>http://example-site.ru/image2</picture>
        <delivery>true</delivery>
        <name>Товар №6</name>
        <param name="Обложка">Мягкая</param>
        <param name="Страниц" unit="шт.">10</param>
      </offer>
    </offers>
  </shop>
</yml_catalog>
```

### Дополнительные возможности

В ряде случаев (размещение в тематических прайс-агрегаторах, ограничение показа товаров в Яндекс.Маркет) необходимо
генерировать различные прайс-листы. При использовании бибилиотеки YmlBuild это можно сделать через указание допустимых
категорий в методе filter. Вызов данного метода должен быть осуществлен до добавления первой категории или товара.

```ruby
price.categories.filter = [1, 10, 12, 20]
```

Для указания в соответствии с требованиями Yandex цены доставки в место локации магазина, необходимо использовать
метод local_delivery_cost.

```ruby
price.local_delivery_cost = 300
```

Метод to_yml формирует выходную строку в формате utf-8. Для записи прайс-листа рекомендуется использовать метод save,
передава ему имя файла для записи.

```ruby
price.save('price.xml')
```


## Contributing

1. Fork it ( https://github.com/[my-github-username]/yml_builder/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
