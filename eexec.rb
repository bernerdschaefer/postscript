require 'securerandom'

def encode(data, r=55665, n=4)
  c1 = 52845
  c2 = 22719

  (SecureRandom.random_bytes(n) << data).bytes.map do |plain|
    cipher = (plain ^ (r >> 8)) & 0xFF
    r = ((cipher + r) * c1 + c2) & 0xFFFF
    cipher
  end.pack("C*")
end

def decrypt(data, r=55665, n=4)
  c1 = 52845
  c2 = 22719

  plain_text = data.bytes.map do |cipher|
    plain = (cipher ^ (r >> 8)) & 0xFF
    r = ((cipher + r) * c1 + c2) & 0xFFFF
    plain
  end

  plain_text.slice!(4, plain_text.length).pack("C*")
end

puts decrypt(encode("dup /Private 10"))
