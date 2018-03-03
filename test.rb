#! /usr/bin/env ruby
require 'json'
require 'csv'
pinmux = CSV.read("51pinmux.csv")
sercom_c = 12
sercom_d = 13
#sercoms = {}
chip_types = ['G','J','N','P']
sercoms = {G:{}, J:{}, N:{}, P:{}}
pinmux.each do |pin|
  g_pin = nil
  j_pin = nil
  n_pin = nil
  p_pin = nil
  puts "pIN: #{pin.inspect}"
  if pin[0] && (g_pin_match = pin[0].match(/(\d+)/))
    g_pin = g_pin_match.captures[0]
  end
  if (j_pin_match = pin[1].match(/(\d+)/))
    j_pin = j_pin_match.captures[0]
  end
  if (n_pin_match = pin[2].match(/(\d+)/))
    n_pin = n_pin_match.captures[0]
  end
  if (p_pin_match = pin[3].match(/(\d+)/))
    p_pin = p_pin_match.captures[0]
  end

  # we know we're 48 pin'd
  [sercom_c, sercom_d].each do |mux_number|
    if sermatch = pin[mux_number].match(/SERCOM(\d)\/PAD\[(\d)\]/)
      [g_pin, j_pin, n_pin, p_pin].each_with_index do |pin_number, index|
        next if pin_number.nil? 
        chip_type = chip_types[index]
        type_sercoms = sercoms[chip_type.to_sym]

        pad_name = pin[4] 
        sercom_number = sermatch.captures[0].to_i
        sercom_pad_number = sermatch.captures[1].to_i
        # G and J chips only have 6 sercoms
        next if ((chip_type == 'G')||(chip_type == "J")) && sercom_number > 6

        type_sercoms[sercom_number]  = [] if type_sercoms[sercom_number].nil?
        type_sercoms[sercom_number] << {pin: pin_number, pad_name: pad_name, sercom: sercom_number, sercom_pad: sercom_pad_number} 
        if sercom_pad_number == 1
          type_sercoms['sck'] = [] if type_sercoms['sck'].nil?
          type_sercoms['sck'] << {pin: pin_number, pad_name: pad_name, sercom: sercom_number, sercom_pad: sercom_pad_number} 
        end
      end
    end
  end
    
end
puts
puts
puts "JSON"
puts sercoms.to_json
