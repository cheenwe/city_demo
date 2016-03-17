namespace :local do

  #rake local:country
  #rake local:area
    def path name
      File.read("#{Rails.root}/db/#{name}")
    end

  desc "国家"
  task :country => :environment do
    ## 国家信息
    # countries = YAML::load(path("country.json"))
    countries =  JSON.parse(path("country.json"))
    n = 100000
    countries.each do |key, value|
      n= n+1
      puts "===creating===#{key}===#{value}===#{n}==="
      Local::Contuny.create(id: n, name: value, abbr: key ) unless Local::Contuny.find_by_abbr(key).present?
    end
  end

  desc "省市县"
  task :area => :environment do
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
          puts "===省===#{id[0..1]}===#{text}===#{abbr}==="
        elsif id.end_with?('00')                          # 市
          puts "===市===#{id[0..3]}===#{text}===#{abbr}==="
          Local::City.create(name: text, id: id[0..3], abbr:abbr, parent_id: id[0..1] )  unless Local.find_by_id(id[0..3]).present?
        else #区
          puts "===区===#{id}===#{text}===#{abbr}==="
          Local::District.create(name: text, id: id, abbr:abbr, parent_id: id[0..3] )  unless Local.find_by_id(id).present?
        end
      else
          puts "=== 街道===#{id}===#{text}===#{abbr}==="
        Local::Street.create(name: text, id: id, abbr:abbr, parent_id: id[0..5] )  unless Local.find_by_id(id).present?
      end
    end
  end


  desc "全部"
  task :init => :environment do
    countries =  JSON.parse(path("demo.json"))
    countries.each do |c|
      puts "==#{c["name"]}="
      Local::Contuny.create(name: c["name"], type: c["type"], parent_id: c["parent_id"], abbr: c["abbr"], id: c["id"])
    end
  end

  desc "删除所有"
  task :delete_all => :environment do
    puts "deleting....#{Local.all.size} "
    Local.delete_all
    puts "delete_all"
  end

end
