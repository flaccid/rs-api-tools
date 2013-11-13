def editor_command
  ENV.fetch('EDITOR') { 'vi' }
end