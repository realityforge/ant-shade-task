#!/usr/bin/env ruby

require 'fileutils'

system('mvn clean deploy')

FileUtils.rm_rf 'dist'
FileUtils.cp_r 'target/output', 'dist'

FileUtils.rm_f Dir['dist/**/maven-metadata*']

Dir['dist/**/*-jar-with-dependencies*'].each do |filename|
  FileUtils.mv filename, filename.gsub('-jar-with-dependencies','')
end
