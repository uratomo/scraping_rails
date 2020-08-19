# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'


  [
    "木造",
    "鉄骨鉄筋",
    "鉄骨",
    "鉄筋コン",
    "軽量鉄骨",
    "気泡コン",
    "その他",
  ].each do |st|
    s = Structure.new
    s.name = st
    s.save!
    puts "structureが保存できた"
  end

csv_text = File.read(Rails.root.join('lib', 'seeds', 'building_list.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')

structures = Structure.all
puts "aaa#{structures}"

ActiveRecord::Base.transaction do
  csv.each do |row|
    b = Building.new
    b.suumo_number = row["物件コード"]
    b.floor = row["間取り"]
    b.area = row["面積"]
    b.age = row["築年数"]
    b.structure_id = structures.select{ |s| s.name == row["構造"] }.pluck(:id).first || 7
    b.save!
    # structure_id を発見して、t.structure_idを設定する
    # stationを作成する
    [row["最寄り駅1"], row["最寄り駅2"], row["最寄り駅3"]].each do |row|
      line, name, walk = row&.split(/\/| /)
      st = b.stations.build
      st.line = line
      st.name = name
      st.walk = walk&.match(/\d+/)&.to_s&.to_i
      st.save!
    end
    # addressを作成する
    # matchお勉強
    address_row = row["住所"].match(/(.+[都|県|府])(.+[区|市])(.+)/)
    ad = b.addresses.build
    ad.city = address_row[1]
    ad.ward = address_row[2]
    ad.line = address_row[3]
    ad.save!
    # cost
    c = b.costs.build
    c.rent = row["賃料"]
    c.administration_fee = row["管理費"] * 1000
    # 取り出し方修正
    c.set_deposit = row["敷金"].present? ? (row["敷金"].to_f * 1000).to_i : 0
    # 取り出し方修正
    c.reward = row["礼金"].present? ?  (row["礼金"].to_f * 1000).to_i : 0
    # 取り出し方が悪い。修正
    c.bond_payment = row["保証金"].present? ? (row["保証金"].to_f * 1000).to_i : 0
    c.repayment = row["敷引/償却"].present? ? (row["敷引/償却"].to_f * 1000).to_i : 0
    c.commission = row["仲介手数料"]
    c.save!
    puts "#{b.suumo_number}, #{b.area} saved"
  end
end
