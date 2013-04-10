#!/usr/bin/env ruby
# encoding: utf-8
Version = '20130410-102621'

ELEMENTS = 10000
TIMES = 1000

require 'benchmark'
def benchmark(a1, a2)
  Benchmark.bm(20) do |x|
    x.report("Add") do
      TIMES.times do
        a1 + a2
      end
    end
    x.report("Sub") do
      TIMES.times do
        a1 - a2
      end
    end
    x.report("Mul") do
      TIMES.times do
        a1 * a2
      end
    end
    x.report("Div") do
      TIMES.times do
        a1 / a2
      end
    end
  end
end


# CArray
class Array
  def +(other)
    clone = self.clone
    self.length.times do |i|
      self.length.times do |j|
        clone[i][j]+=other[i][j]
      end
    end 
    clone
  end
  def -(other)
    clone = self.clone
    self.length.times do |i|
      self.length.times do |j|
        clone[i][j]-=other[i][j]
      end
    end 
    clone
  end
  def *(other)
    clone = self.clone
    self.length.times do |i|
      self.length.times do |j|
        clone[i][j]*=other[i][j]
      end
    end 
    clone
  end
  def /(other)
    clone = self.clone
    self.length.times do |i|
      self.length.times do |j|
        clone[i][j]/=other[i][j]
      end
    end 
    clone
  end
end

a1 = Array.new(ELEMENTS){|i| i+1.0}
a2 = Array.new(ELEMENTS){|i| i+5.0}
n = Math.sqrt(ELEMENTS)
unless (n.to_i - n).abs < 1e-10
    warn "Math.sqrt(ELEMENTS (#{ELEMENTS})) must be an integer."
    exit
end
n = n.to_i
m1 = []
m2 = []
m1 << a1.slice!(0,n) while !a1.empty?
m2 << a2.slice!(0,n) while !a2.empty?

# CArray
puts "CArray"
benchmark(m1, m2)
puts

# GSL::Matrix
require 'gsl'
a1 = Array.new(ELEMENTS){|i| i+1.0}
a2 = Array.new(ELEMENTS){|i| i+5.0}
gm1 = GSL::Matrix.alloc(a1, n, n)
gm2 = GSL::Matrix.alloc(a2, n, n)
puts "GSL::Matrix"
benchmark(gm1, gm2)
puts

# NMatrix
#require 'nmatrix'
require 'nmatrix-0.0.3'
nm1 = NMatrix.new([n,n], a1, :float64)
nm2 = NMatrix.new([n,n], a2, :float64)
puts "NMatrix"
benchmark(nm1, nm2)
puts

# NArray
begin
require 'narray'
rescue
end
na1 = NArray.to_na(m1)
na2 = NArray.to_na(m2)
puts "NArray"
benchmark(na1, na2)
puts

# GSL::Matrix.to_nm
nm3 = gm1.to_nm
nm4 = gm2.to_nm
puts "NMatrix from GSL::Matrix (to_nm)"
benchmark(nm3, nm4)
puts

