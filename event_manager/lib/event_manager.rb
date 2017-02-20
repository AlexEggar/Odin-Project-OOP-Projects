require 'csv'
require 'sunlight/congress'
require 'erb'
require 'date'

Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"

def most_frequent(input)
  input.each do |k,v|
    puts k if v == input.values.max
  end
end

def registration_frequency(date)

  date = DateTime.strptime(date,'%m/%d/%y %H:%M')
  date = [date.hour, date.wday]
end

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5,"0")[0..4]
end

def legislators_by_zipcode(zipcode)
  Sunlight::Congress::Legislator.by_zipcode(zipcode)
end

def save_thank_you_letters(id,form_letter)
  Dir.mkdir("output") unless Dir.exists? "output"

  filename = "output/thanks_#{id}.html"
File.open(filename,'w') do |file|
  file.puts form_letter
end
end

def clean_phonenum(number)

number.gsub!(/\D/,'')
if number.length == 11 && number[1] == '1'
number.slice(1..-1)
elsif number.length == 10 && number.match(/\d/)
 number
else
  number = '0000000000'
end
end



puts "EventManager initialized"

contents = CSV.open 'event_attendees.csv', headers: true, header_converters: :symbol

template_letter = File.read "form_letter.erb"
erb_template = ERB.new template_letter

hours = Hash.new(0)
weekdays = Hash.new(0)

contents.each do |row|
  id = row[0]
  name = row[:first_name]

  zipcode = clean_zipcode(row[:zipcode])

  date = registration_frequency(row[:regdate])

  hours[date[0]] += 1
  weekdays[date[1]] += 1

  number = clean_phonenum(row[:homephone])
  puts number
  legislators = legislators_by_zipcode(zipcode)

  form_letter = erb_template.result(binding)

  save_thank_you_letters(id,form_letter)


end
puts 'Most frequent hours:'
most_frequent(hours)
puts 'Most frequent days:'
most_frequent(weekdays)
