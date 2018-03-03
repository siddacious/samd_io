require 'csv'
lns = File.open(ARGV[0]).readlines.map(&:strip)
CSV.open("#{ARGV[0]}.csv", "w") do |csv|
  lns.each do |l|
    row = l.split(" ")
    unless row[11].match(/X\d+\/Y\d+/)
      row.insert(11, '-')
    end
    puts row.length
    (24-row.length).times do 
      puts 'inserting'
      row.insert(0, '-')
    end
    csv << row
   
  end
end
