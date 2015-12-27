require "mkmf"

path = "/src/github.com/camilo/rubby"
gopaths = (ENV['GOPATH'] || "").split(':').reject(&:empty?)

raise  "$GOPATH must be set" if gopaths.empty?

found = []

gopaths.each do |gopath|
  try_path = gopath + path

  found[0] ||= find_header("librubby.h", try_path)
  found[1] ||= find_library("rubby", "PushUrl", try_path)
  found[2] ||= find_library("rubby", "Start", try_path)
  found[3] ||= find_library("rubby", "Stop", try_path)

  break if found.reduce(true){ |memo, n| memo && n }
end

create_makefile "gubby"
