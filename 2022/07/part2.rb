data = File.read(
  File.join(
    File.dirname(__FILE__),
    './input.txt'
  )
).strip

current_path = nil

def change_path(current_path, new_path)
  if new_path == '..'
    current_path.split('/')[0..-2].join('/')
  elsif new_path == '/'
    '/'
  else
    [current_path, new_path].join('/').gsub('//', '/')
  end
end

def compute_flat_sizes(current_path, line, directory_with_sizes, directories_within_directory)
  p1,p2 = line.split(' ')

  directories_within_directory[current_path] ||= []
  directory_with_sizes[current_path] ||= 0

  if p1 == 'dir'
    directories_within_directory[current_path] << [current_path, p2].join('/').gsub('//', '/')
  else
    directory_with_sizes[current_path] += p1.to_i
  end
end

directory_with_sizes = {}
directories_within_directory = {}

data.split("\n").each do |line|
  if line.start_with?('$')
    cmd = line.split(' ')[1]

    if cmd == 'cd'
      current_path = change_path(current_path, line.split(' ')[2])
    end
  else
    compute_flat_sizes(current_path, line, directory_with_sizes, directories_within_directory)
  end
end

directories_within_directory.sort_by do |path, v|
  -1*path.split('/').count
end.each do |directory, sub_directories|
  sub_directories.each do |sub_directory|
    directory_with_sizes[directory] += directory_with_sizes[sub_directory]
  end
end

max_space = 70000000
used_space = directory_with_sizes['/']

current_unused_space = max_space - used_space
target_unused_space = 30000000

final_values = directory_with_sizes.values.select do |size|
  current_unused_space + size >= target_unused_space
end

p final_values.min
