module PrologixGpib::Usb::Commands
  def config
    error_message = 'Error'
    ver = version.split('version').map(&:strip)
    return { error: error_message } unless ver.count == 2 && ver[0].include?('Prologix')
    conf = {}
    conf[:device_name] = ver[0]
    conf[:firmware] = ver[1]
    conf[:mode] = { '1' => 'Controller', '0' => 'Device' }.fetch(mode, error_message)
    conf[:device_address] = address[/([1-9])/].nil? ? error_message : address[/([1-9])/]
    conf[:auto_read] = { '1' => 'Enabled', '0' => 'Disabled', 'Unrecognized command' => 'NA' }.fetch(auto, error_message)
    tmo = timeout
    conf[:read_timeout] =
      case tmo
      when 'Unrecognized command'
        'NA'
      when /([1-1000])/
        tmo
      else
        error_message
      end
    conf[:eoi_assertion] = { '1' => 'Enabled', '0' => 'Disabled' }.fetch(eoi, error_message)
    conf[:eos] =
      case eos
      when '0'
        'Append CR+LF'
      when '1'
        'Append CR to instrument commands'
      when '2'
        'Append LF to instrument commands'
      when '3'
        'Do not append anything to instrument commands'
      else
        error_message
      end
    conf[:eot] = { '1' => 'Enabled', '0' => 'Disabled' }.fetch(eot, error_message)
    eot_str = eot_char
    # conf[:eot_char] = eot_str.to_i.chr[/([ -~])/].nil? ? error_message : "'#{eot_str.to_i.chr}', ascii #{eot_str}"
    conf
  end

  #  This command configures the Prologix GPIB-USB controller to be a :controller or :device.
  def mode=(op_mode)
    mode =
      case op_mode
      when :controller, 1, '1'
        1
      when :device, 0, '0'
        0
      else
        ''
      end
    write("++mode #{mode}")
  end
  alias set_operation_mode mode=

  def mode
    device_query('++mode')
  end
  alias operation_mode mode

  # Timeout value, in milliseconds, used in the read command and spoll command.
  # Any value between 1 and 3000 milliseconds.
  def timeout=(milliseconds)
    return unless connected? || milliseconds.class != Integer

    write("++read_tmo_ms #{milliseconds}")
  end

  def timeout
    device_query('++read_tmo_ms')
  end

  # PrologixGPIB-USB controller can be configured to automatically address instruments to 'talk' after sending a command in order to read the response.
  # *** Avaliable in Controller mode. When enabled can cause the prologix controller to lockup. ***
  def auto=(auto_mode)
    mode =
      case auto_mode
      when :enable, 1, '1'
        1
      when :disable, 0, '0'
        0
      else
        ''
      end
    write("++auto #{mode}")
  end
  alias set_auto_read_after_write auto=

  def auto
    device_query('++auto')
  end
  alias auto_read_after_write auto

  # In :controller mode, address refers to the GPIB address of the instrument being controlled.
  # In :device mode, it is the address of the GPIB peripheral that Prologix GPIB-USB controller is emulating.
  def address=(addr)
    write("++addr #{addr}")
  end
  alias set_address address=

  def address
    device_query('++addr')
  end

  # This command enables or disables the assertion of the EOI signal with the last character of any command sent over GPIB port.
  # Some instruments require EOI signal to be asserted in order to properly detect the end of a command.
  def eoi=(eoi_mode)
    mode =
      case eoi_mode
      when :disable, '0', 0
        0
      when :enable, '1', 1
        1
      else
        raise ArgumentError, "Invalid arg: '#{eoi_mode}'"
      end
    write("++eoi #{mode}")
  end

  def eoi
    device_query('++eoi')
  end

  # This command specifies GPIB termination characters. When data from host is received over USB, all non-escaped LF, CR and ESC characters are removed and GPIB terminators, as specified by this command, are appended before sending the data to instruments.
  # This command does not affect data from instruments received over GPIB port.
  # EXAMPLES:
  # 0 Append CR+LF
  # 1 Append CR to instrument commands
  # 2 Append LF to instrument commands
  # 3 Do not append anything to instrument commands
  def eos=(eos_mode)
    error_message = "Invalid arg: '#{eos_mode}'"
    raise ArgumentError, error_message unless [0, 1, 2, 3].include? eos_mode

    write("++eos #{eos_mode}")
  end

  def eos
    device_query('++eos')
  end

  # This command enables or disables the appending of a user specified character (see eot_char) to USB output whenever EOI is detected while reading a character from the GPIBport.
  def eot=(eot_mode)
    mode =
      case eot_mode
      when 0, '0', false, :disable
        0
      when 1, '1', true, :enable
        1
      else
        raise ArgumentError, "Invalid arg: '#{eot_mode}'"
      end
    write("++eot_enable #{mode}")
  end

  def eot
    device_query('++eot_enable')
  end

  def eot_char=(char)
    write("++eot_enable #{char}")
  end

  def eot_char
    device_query('++eot_char')
  end

  def version
    device_query('++ver')
  end

  def savecfg
    device_query('++savecfg')
  end

  def trigger(addr_list = [])
    write("++trg #{addr_list.join(' ')}")
  end

  def reset
    write('++rst')
  end

  def flush
    return unless connected?

    loop until serial_port.getbyte.nil?
  end

  private

  def device_query(command)
    flush
    write(command)
    readline
  end
end
