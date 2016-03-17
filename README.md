# 国家及城市表单的实现
使用同一张表实现:国家-省-市-县-镇 的级联

## 字段整理如下:
>表名:locals

  字段名 |名称|类型
  -----|------|-------
  name |名称|string
  type |类型|string
  parent_id |父级|integer
  abbr |缩写|string

## 定义读文档方法
```ruby
def path name
  File.read("#{Rails.root}/db/#{name}")
end
```
## 国家信息

```ruby
# countries = YAML::load(path("country.json"))
countries =  JSON.parse(path("country.json"))

n = 100000
countries.each do |key, value|
  n= n+1
  Local::Contuny.create(id: n, name: value, abbr: key ) unless Local::Contuny.find_by_abbr(key).present?
end
```
## 省市县及街道
```ruby
areas = JSON.parse(path("areas.json"))

streets = areas.values.flatten
contuny_id = Local::Contuny.find_by_abbr("CN").id
streets.each do |street|
  id = street['id']
  text = street['text']
  abbr = Pinyin.t(text) { |letters| letters[0].upcase }

  if id.size == 6    # 省市区
    if id.end_with?('0000')                           # 省
      Local::Province.create(name: text, id: id[0..1], abbr:abbr, parent_id: contuny_id ) unless Local.find_by_id(id[0..1]).present?

    elsif id.end_with?('00')                          # 市
      Local::City.create(name: text, id: id[0..3], abbr:abbr, parent_id: id[0..1] )  unless Local.find_by_id(id[0..3]).present?
    else #区
      Local::District.create(name: text, id: id, abbr:abbr, parent_id: id[0..3] )  unless Local.find_by_id(id).present?
    end
  else
    Local::Street.create(name: text, id: id, abbr:abbr, parent_id: id[0..5] )  unless Local.find_by_id(id).present?
  end
end
```

## 用法
### 1.直接把db/locals.sql 导入到数据库 2.36 sec

### 2.原始数据: 比较慢 47907 条数据 用了53分钟
>rake local:country
>rake local:area


### 3.使用json数据
>rake local:init
