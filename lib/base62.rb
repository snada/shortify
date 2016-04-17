# No standard found (?), preferring 0-9 + A-Z + a-z
# according to duosexagesimal numeral system mentioned in:
# https://en.wikipedia.org/wiki/List_of_numeral_systems
class Base62
  DIGITS = ('0'..'9').to_a + ('A'..'Z').to_a + ('a'..'z').to_a

  def self.encode62(num)
    return '0' if num == 0

    encoded = ''
    while num > 0
      encoded.prepend DIGITS[num % 62]
      num /= 62
    end

    return encoded
  end
end
