# ruby script/rails runner "RetrieveSuumoRoom.new.scraping"
require "csv"

class RetrieveSuumoRoom
  def scraping
    search_url = "https://suumo.jp/jj/chintai/ichiran/FR301FC001/?ar=030&bs=040&pc=50&smk=&po1=25&po2=99&shkr1=03&shkr2=03&shkr3=03&shkr4=03&ekInput=00680&ta=13&kskbn=01&tj=10&nk=0&cb=0.0&ct=14.0&co=1&md=04&md=06&md=07&md=10&et=15&mb=40&mt=9999999&cn=9999999&fw2="
    links = []

    while true
      current_page = retrieve_data(search_url)

      # 取得した response から、links をまとめて取り出す
      links += current_page.links_with(text: "詳細を見る")

      next_link = current_page.search(".pagination_set-nav p a")&.select { |page| page.inner_text == "次へ"}&.first
      break unless next_link
      search_url = "https://suumo.jp" + next_link.get_attribute("href")

      # マナー
      puts "#{search_url}"
      sleep 10
    end
    output = output_csv(links).force_encoding("utf-8")
    puts "#{output.encoding}"
    file_path = File.join(Rails.root, 'tmp', "#{Time.now.strftime('%Y%m')}_rental_list.csv")
    File.open(file_path, 'w:UTF-8') do |f|
      f.puts output
    end
  end

  private

  def output_csv(links)
    CSV.generate do |writer|
      csv_header = [
        "物件コード",
        "住所",
        "間取り",
        "面積",
        "築年数",
        "構造",
        "最寄り駅1",
        "最寄り駅2",
        "最寄り駅3",
        "賃料",
        "管理費",
        "敷金",
        "礼金",
        "保証金",
        "敷引/償却",
        "仲介手数料",
      ]
      writer << csv_header
      links.each do |link|
        show_page = link.click
        # table_areaいらない
        table_area = show_page.search("//*[@id='js-view_gallery']/div[3]/table")
        csv_body = [
          show_page.at('//*[@id="contents"]/div[4]/table/tr[6]/td[1]')&.inner_text.presence || show_page.at('//*[@id="contents"]/div[2]/table/tr[6]/td[1]')&.inner_text, # 物件コード
          table_area.at("tr[1]/td")&.inner_text, # 住所
          table_area.at("tr[3]/td[2]")&.inner_text, # 間取り
          table_area.at("tr[3]/td[4]")&.inner_text.to_f, #専有面積
          show_page.at('//*[@id="js-view_gallery"]/div[3]/table/tr[4]/td[1]')&.inner_text.match(/\d+/).to_s.to_i, # 築年数
          show_page.at('//*[@id="contents"]/div[4]/table/tr[1]/td[2]')&.inner_text&.gsub(/\t|\r|\n/,"").presence || show_page.at('//*[@id="contents"]/div[2]/table/tr[1]/td[2]')&.inner_text&.gsub(/\t|\r|\n/,""), # 構造
          table_area.at("tr[2]/td/div[1]")&.inner_text, # 最寄り駅1
          table_area.at("tr[2]/td/div[2]")&.inner_text, # 最寄り駅2
          table_area.at("tr[2]/td/div[3]")&.inner_text, # 最寄り駅3
          (show_page.at('//*[@id="js-view_gallery"]/div[1]/div[1]/div[1]/span[1]')&.inner_text&.to_f * 10000)&.to_i, # 賃料
          show_page.at('//*[@id="js-view_gallery"]/div[1]/div[1]/div[1]/span[2]/text()').inner_text.gsub(//,)&.to_s&.to_i, # 管理費
          (show_page.at('//*[@id="js-view_gallery"]/div[1]/div[1]/div[2]/span[1]')&.inner_text.match(/\d+(?:\.\d+)?/)&.to_s&.to_f * 1000)&.to_i, # 敷金
          (show_page.at('//*[@id="js-view_gallery"]/div[1]/div[1]/div[2]/span[1]')&.inner_text&.match(/\d+(?:\.\d+)?/)&.to_s&.to_f * 1000)&.to_i, # 礼金
          (show_page.at('//*[@id="js-view_gallery"]/div[1]/div[1]/div[2]/span[3]')&.inner_text.match(/\d+(?:\.\d+)?/)&.to_s&.to_f * 1000).to_i, # 保証
          (show_page.at('//*[@id="js-view_gallery"]/div[1]/div[1]/div[2]/span[4]')&.inner_text.match(/\d+(?:\.\d+)?/).to_s.to_f * 1000)&.to_i, # 敷引,償却
          show_page.at('//*[@id="contents"]/div[4]/table/tr[7]/td/ul/li')&.inner_text&.gsub(/\t|\r|\n/,""), # 仲介手数料
        ]
        writer << csv_body
        # マナー
        puts "#{csv_body}"
        sleep 10
      end
    end
  end

  def retrieve_data(link)
    agent = Mechanize.new
    agent.get(link)
  end
  # ひとまずのDB化をするに当たってのclass仮
  # building
    # suumo_number:string floor:string area:integer age:integer structure:preferences
  # station class (最寄り駅を割り出すclass)
    # building:references name:string walk:integer
  # address class(住所住処がわかる) tokyo sumida などで分けていく
    # building:references city:string ward:string line:string
  # structure(建造物) class (あらかじめデータを作っておく)
   # name:string (鉄筋や、鉄骨)
  # cost関連 はひとまずまとめる
   # building:references rent:integer administration_fee:integer set_deposit:integer reward:integer bond_payment:integer repaymentinteger commision:integer
end
