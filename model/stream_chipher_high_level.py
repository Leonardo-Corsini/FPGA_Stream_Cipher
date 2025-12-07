def xtime(d: int) -> int:
    d &= 0xFF
    
    d7 = (d >> 7) & 1
    d6 = (d >> 6) & 1
    d5 = (d >> 5) & 1
    d4 = (d >> 4) & 1
    d3 = (d >> 3) & 1
    d2 = (d >> 2) & 1
    d1 = (d >> 1) & 1
    d0 = (d >> 0) & 1
    
    e7 = d6
    e6 = d5
    e5 = d4
    e4 = d3 ^ d7
    e3 = d2 ^ d7
    e2 = d1
    e1 = d0 ^ d7
    e0 = d7
    
    e = (e7 << 7) | (e6 << 6) | (e5 << 5) | (e4 << 4) | \
        (e3 << 3) | (e2 << 2) | (e1 << 1) | e0
        
    return e

def s(A: int) -> int:
    A &= 0xFFFFFFFF
    
    A0 = (A >> 24) & 0xFF
    A1 = (A >> 16) & 0xFF
    A2 = (A >> 8)  & 0xFF
    A3 = (A >> 0)  & 0xFF
    
    xtime_output = xtime(A1 ^ A2)
    
    f = xtime_output ^ A2 ^ A3 ^ A0
    
    return f & 0xFF

def stream_cipher(key: int, plaintext_byte: int, i: int) -> int:
    
    counter_block = (key + i) & 0xFFFFFFFF
    s_output = s(counter_block)
    ciphertext_byte = (plaintext_byte & 0xFF) ^ s_output
    
    return ciphertext_byte