def yesno
  begin
    system("stty raw -echo")
    str = STDIN.getc
  ensure
    system("stty -raw echo")
  end
  if str.downcase == "y"
    return true
  elsif str.downcase == "n"
    return false
  else
    raise "Invalid response. Please enter y/n."
  end
end