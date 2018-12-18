require 'nokogiri'
require 'turbosms'

doc = Nokogiri::HTML(File.read('file.html'))

ttns = doc.css("p[id='number_ttn']")
numbers = doc.css("p[class='recipient_information_text']")

final_ttns = ttns.map { |elem| elem.text[13..29] }
final_numbers = 3.step(numbers.size - 1, 4).map { |i| numbers[i].text[9..20] }

TurboSMS.default_options[:login]    = 'login'
TurboSMS.default_options[:password] = 'password'
TurboSMS.default_options[:sender]   = 'signature'

message_before_ttn = 'Дякуємо!
Ваш вантаж відправлено.
Номер ТТН:
№ '

for i in 0..final_numbers.size
  message_id = TurboSMS.send_sms(final_numbers[i], message_before_ttn + final_ttns[i])
  puts TurboSMS.get_message_status(message_id)
end
