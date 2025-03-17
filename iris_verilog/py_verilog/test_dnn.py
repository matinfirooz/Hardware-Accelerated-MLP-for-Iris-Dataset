##test_dnn
import math

from convert import *

layers = [
  [
    [
      [-0.9625484, 0.2623965, 0.53647584, -0.31854045],
      [-0.04564629, 0.08359738, -1.0004255, 0.23383659],
      [2.694976, -0.5877245, 2.845446, -0.7494745],
      [2.5595367, -0.33822346, 1.3281347, -0.12019187]
    ],
    [-1.1635648, -0.12427775, -0.5958142, 0.0]
  ], [
    [
      [-1.2052867, 1.5368472, 0.02476507, 2.2805846],
      [0.40936843, -0.37030256, 0.39406562, -0.18069215],
      [-1.0619785, 1.1906158, 2.5496893, 1.254845],
      [-0.86346734, 0.39323288, -0.52617943, 0.5954327]
    ],
    [1.1019912, -1.3505068, 0.00183545, -1.4194555]
  ], [
    [
      [1.4364738, -1.3739165, 0.32878414],
      [0.15349068, -1.2063856, 1.9425795],
      [-2.436204, 1.1588786, 0.23146966],
      [-0.6557887, -0.62194896, 2.7259479]
    ],
    [2.3177414, 0.22783826, -2.5455537]
  ]
]

def relu(layer):
  for i in range(len(layer)):
    if layer[i] < 0: layer[i] = 0
  return layer

def softmax(layer):
  max_value = max(layer)
  for i in range(len(layer)):
    layer[i] = math.exp(layer[i] - max_value)
  return layer

def hardmax(layer):
  max_value = max(layer)
  for i in range(len(layer)):
    if layer[i] == max_value: layer[i] = 1
    else: layer[i] = 0
  return layer

def forward_layer(layer, input_layer, activation_function):
  output = []
  for i in range(len(layer[0][0])):
    _sum = layer[1][i]
    print(input_layer)
    for j in range(len(layer[0])): _sum += input_layer[j] * layer[0][j][i]
    output.append(_sum)
  output = activation_function(output)
  return output

def forward(layers, input_layer):
  output = None
  for i, layer in enumerate(layers):
    if i == 0: output = forward_layer(layer, input_layer, relu)
    elif i == len(layers) - 1: output = forward_layer(layer, output, hardmax)
    else: output = forward_layer(layer, output, relu)
  return output

def create_memory_pages(one_input):
  mem_files = open('mem.page', 'w+')
  for l in range(8):
    try: layer = layers[::-1][l]
    except: layer = [[[0 for _ in range(8)] for _ in range(7)], [0 for _ in range(8)]]
    for i in range(6, -1, -1):
      line = ''
      for j in range(8):
        try: weight = layer[0][i][j]
        except: weight = 0
        line += bits_to_hexs(float_to_floating_point(weight))
      mem_files.write(line + '\n')
    line = ''
    for i in range(8):
      try: bias = layer[1][i]
      except: bias = 0
      line += bits_to_hexs(float_to_floating_point(bias))
    mem_files.write(line + '\n')
  line = ''
  for i in range(8):
    try: n_input = one_input[::-1][i]
    except: n_input = 0
    line += bits_to_hexs(float_to_floating_point(n_input))
  mem_files.write(line + '\n')
  mem_files.close()

def main():
  inputs = [
    [0.61538464, 0.38461536, 0.17948717, 0.0],
    [0.55128205, 0.35897437, 0.16666666, 0.01282051],
    [0.6923077, 0.3205128, 0.55128205, 0.14102565],
    [0.9102564, 0.44871795, 0.7692307, 0.30769232]
  ]

  output = forward(layers, inputs[2])
  print(f'\n{output = }')

  create_memory_pages(inputs[2])

if __name__ == '__main__': main()
