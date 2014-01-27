require 'scrypt'
require 'yaml'
require 'io/console'

puts "Enter your username (screen_name)"
screen_name = gets.chomp

puts "Enter your pass to be hashed"
pass = STDIN.noecho(&:gets).chomp

salt = SCrypt::Engine.generate_salt(salt_size: 32)
hashed_pass = SCrypt::Engine.hash_secret(pass, salt, 512)

puts "SALT and HASHED_PASS will be copied inside config.yml (salt and hash respectively)"
puts "SALT: #{salt}"
puts "HASHED_PASS: #{hashed_pass}"

config = YAML::load_file('config.yml')
config['screen_name'] = screen_name
config['password']['salt_size'] = 32
config['password']['key_len'] = 512
config['password']['salt'] = salt
config['password']['hash'] = hashed_pass
File.open('config.yml', 'w') {|f| f.write config.to_yaml }
