require 'zurb-foundation'
require './my_app'
require 'encrypted_cookie'
require 'rack/csrf'


# Set this to the root of your project when deployed:
http_path = "/"
css_dir = "assets/css"
sass_dir = "assets/scss"
images_dir = "assets/images"
javascripts_dir = "assets/javascript"

# You can select your preferred output style here (can be overridden via the command line):
# output_style = :expanded or :nested or :compact or :compressed

# To enable relative paths to assets via compass helper functions. Uncomment:
relative_assets = true

# To disable debugging comments that display the original location of your selectors. Uncomment:
# line_comments = false


# If you prefer the indented syntax, you might want to regenerate this
# project again passing --syntax sass, or you can uncomment this:
# preferred_syntax = :sass
# and then run:
# sass-convert -R --from scss --to sass assets/scss scss && rm -rf sass && mv scss sass

module MyTwitter
  def self.app
    yaml_config = YAML::load_file('config.yml')
    Rack::Builder.app do
      cookie_settings = {
        :key          => 'my-twitter',
        :path         => "/",
        :expire_after => 86400,             # In seconds, 1 day.
        :secret       => yaml_config["COOKIE_KEY"], # load this into the environment of the server
        :secure       => true,
        :httponly     => true
      }
      # AES encryption of session cookies
      use Rack::Session::EncryptedCookie, cookie_settings
      #use Rack::Session::Cookie, cookie_settings
      use Rack::Csrf, raise: true
      # other stuff here
      run MyApp
    end
  end
end

