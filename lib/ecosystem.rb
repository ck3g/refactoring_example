require 'json'

# Stub class
class Rails
  def self.root
    "."
  end
end

class Ecosystem
  FILENAME = "#{Rails.root}/data/default_ecosystems.json"

  def self.load_json
    JSON.parse(File.open(FILENAME , "r").read)
  end
end
