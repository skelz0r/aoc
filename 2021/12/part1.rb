# frozen_string_literal: true

require 'byebug'

@connexions = File.read(
  File.join(
    File.dirname(__FILE__),
    './example1.txt'
  )
).split("\n").map do |line|
  line.split('-')
end

@map = @connexions.inject({}) do |hash, connexion|
  if connexion.include?('start')
    hash['start'] ||= []
    hash['start'] << (connexion - ['start']).first
  elsif connexion.include?('end')
    hash[(connexion - ['end']).first] ||= []
    hash[(connexion - ['end']).first] << 'end'
  else
    left, right = connexion
    hash[left] ||= []
    hash[left] << right

    hash[right] ||= []
    hash[right] << left
  end

  hash
end

p @map

def traverse(track)
  if track.last == 'end'
    @paths << track
    return
  end

  @map[track.last].each do |cave|
    if cave.upcase == cave
      traverse(track.dup + [cave])
    elsif track.count(cave) == 0
      traverse(track.dup + [cave])
    end
  end
end

@paths = []

traverse(['start'])
p @paths.count
