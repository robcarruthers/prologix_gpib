module PrologixGpib::Lan
  class Error < StandardError
  end

  def discover_devices
    puts devices
  end
end
