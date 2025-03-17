#convert
import math
import struct

def float_to_floating_point(num: float):
  packed = struct.pack('!f', num)
  integers = [c for c in packed]
  binaries = [bin(i) for i in integers]
  stripped_binaries = [s.replace('0b', '') for s in binaries]
  padded = [s.rjust(8, '0') for s in stripped_binaries]
  return ''.join(padded)

def floating_point_to_float(num: str):
  padded_bytes = [num[i:i + 8] for i in range(0, len(num), 8)]
  integers = [int(b, 2) for b in padded_bytes]
  packed = struct.pack('!BBBB', *integers)
  float_num = struct.unpack('!f', packed)[0]
  return float_num

def bits_to_hexs(bits: str):
  if len(bits) % 4 != 0: return None
  hexs = ''
  for i in range(len(bits) // 4):
    hexs += hex(int(bits[i * 4: i * 4 + 4], 2))[2:]
  return hexs

def hexs_to_bits(hexs: str):
  bits = ''
  for i in range(len(hexs)):
    bits += ("{0:0" + f"{4}" + "b}").format(int(hexs[i], 16))
  return bits

if __name__ == '__main__':
  # print(bits_to_hexs(float_to_floating_point(0)))
  # print(bits_to_hexs(float_to_floating_point(1)))
  print(floating_point_to_float(hexs_to_bits('c140129d')))
  print(floating_point_to_float(hexs_to_bits('3fd3760f')))
  print(floating_point_to_float(hexs_to_bits('4133d35b')))
  # print(floating_point_to_float(hexs_to_bits('403de598')))
