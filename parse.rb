require 'json'

json = JSON.parse(File.read('./find.json'), symbolize_names: true)
master_data = json[:masters][:noki_irokazu_shohin_t_map].map do |k, h|
  day, color = k.to_s.split('_')
  {
    day: day,
    color: color,
    id: h[:id],
  }
end

prices = {}
master_data.each do |data|
  prices[data[:day]] ||= {}
  prices[data[:day]][data[:color]] ||= {}

  target_keys = json[:masters][:shohin_s_recs].keys.select { |k| k.to_s.start_with?(data[:id]) }
  target_keys.each do |key|
    price = json[:masters][:shohin_s_recs][key]

    prices[data[:day]][data[:color]][price[:busu]] = {
      price: price[:price],
      old_price: price[:old_price],
    }
  end
end

p prices