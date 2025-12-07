from stream_chipher_high_level import stream_cipher
from os import urandom
from random import randint



for i in range(0,10):
    ciphertext_bytes = bytearray()
    plaintext_bytes = bytearray()
    
    key = urandom(4)             
    plaintext = urandom(8)
    for j in range(0,8):
        p_byte = plaintext[j]
        key_32bit = int.from_bytes(key, byteorder='big')
        c_byte = stream_cipher(key_32bit, p_byte, j)
        ciphertext_bytes.append(c_byte)
        plaintext_bytes.append(p_byte)

    with open("../modelsim/tv/keys.mem", "a") as f:
        f.write(f"{key.hex()}\n")
    
    with open("../modelsim/tv/plaintexts.mem", "a") as f:
        f.write(f"{plaintext_bytes.hex()} \n")

    with open("../modelsim/tv/ciphers.mem", "a") as f:
        f.write(f"{ciphertext_bytes.hex()}\n")
    

    
