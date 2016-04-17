require 'rails_helper'

RSpec.describe Base62 do
  let(:digits) { ('0'..'9').to_a + ('A'..'Z').to_a + ('a'..'z').to_a }

  describe 'digits' do
    it 'should be ordered 0-9 numbers, capital letters and downcase letters' do
      expect(Base62::DIGITS).to eq(digits)
    end
  end

  describe 'encode62' do
    it 'should return base62 encoded value of string' do
      expect(Base62.encode62(0)).to eq('0')
      (1..rand(10..100)).each do |number|
        num = number
        encoded = ''
        while num > 0
          encoded.prepend digits[num % 62]
          num /= 62
        end
        expect(Base62.encode62(number)).to eq(encoded)
      end
    end
  end
end
