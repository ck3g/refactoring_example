class Coordinates
  def self.remap_range(input, in_low, in_high, out_low, out_high)
    # map onto [0,1] using input range
    frac = (input - in_low) / (in_high - in_low)
    # map onto output range
    (frac * (out_high - out_low) + out_low).to_i.round
  end
end
